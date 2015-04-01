#import "DiveSiteMapController.h"
#import "DiveSite.h"

#define ResultsTableView self.searchResultsTableViewController.tableView

#define Identifier @"DiveSiteCell"

@interface DiveSiteMapController ()<GMSMapViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate> {
    
    CLLocationManager *_locationAuthorizationManager;
}


@end

@implementation DiveSiteMapController

- (void)initializeMapView {

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:16.304449
                                                            longitude:-86.594018
                                                                 zoom:15];
    [self.mapView setCamera:camera];
    [self.mapView setMapType: kGMSTypeHybrid];
    [self enableMyLocation];
    [self.mapView setMinZoom:10 maxZoom:17];
    self.mapView.settings.rotateGestures = NO;
    self.mapView.settings.tiltGestures = NO;
 //   self.mapView.settings.myLocationButton = YES;
    self.mapView.delegate = self;

}

- (void)initializeDiveSites {
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"dive-sites" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSArray *siteData = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:nil];
    
    NSMutableArray *mutableDiveSites = [NSMutableArray arrayWithObjects: nil];
    
    for (NSDictionary *data in siteData) {
        DiveSite *newSite =
         [DiveSite diveSiteWithName:data[@"name"]
                           latitude:data[@"latitude"]
                          longitude:data[@"longitude"]
                              depth:data[@"depth"]
                      mooringSystem:data[@"mooring_system"]];
        newSite.marker.map = self.mapView;

        [mutableDiveSites addObject: newSite];
    }
    
    
    self.diveSites = mutableDiveSites;
    
}

- (void)initializeSearchController {
    self.tableData = [self.diveSites sortedArrayUsingComparator:^NSComparisonResult(DiveSite *obj1, DiveSite *obj2) {
        return [obj2.name localizedCaseInsensitiveCompare:obj1.name] == NSOrderedAscending;
    }];
    
    // Init a search results table view controller and setting its table view.
    self.searchResultsTableViewController = [[UITableViewController alloc] init];
    
    ResultsTableView = [[UITableView alloc] initWithFrame:self.view.frame];
    ResultsTableView.dataSource = self;
    ResultsTableView.delegate = self;
    
    // Registration of reuse identifiers.
    [ResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:Identifier];

    // Init a search controller with its table view controller for results.
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultsTableViewController];
    [self.searchController setDimsBackgroundDuringPresentation:NO];
    
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    
    // Make an appropriate size for search bar and add it as a header view for initial table view.
    [self.searchBar sizeToFit];
    self.searchBar.placeholder = @"Search for a dive site...";
    self.searchBar.delegate = self;
    
    // Enable presentation context.
    self.definesPresentationContext = YES;
    self.searchController.definesPresentationContext = YES;
}

- (void)viewDidLoad {
    [self initializeMapView];
    [self initializeDiveSites];
    [self initializeSearchController];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.mapView.padding = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0);
}

// search bar hax

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
   if([searchText length] != 0) {
        [self searchTableList];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchController setActive:NO];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (self.results.count == 1) {
        [self animateToDiveSite:self.results[0]];

    }
}


#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:Identifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];

    cell.textLabel.text = ((DiveSite *)self.results[indexPath.row]).name;
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    [self animateToDiveSite:self.results[indexPath.row]];
  

}



#pragma mark - Search Results Updating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {

    if (self.searchBar.text.length > 0) {
        NSString *text = self.searchBar.text;
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *diveSite, NSDictionary *bindings) {

            NSRange range = [((DiveSite*)diveSite).name rangeOfString:text options:NSCaseInsensitiveSearch];

            return range.location != NSNotFound;
        }];
        
        // Set up results.
        self.results = [[self.tableData filteredArrayUsingPredicate:predicate] mutableCopy];
        
        // Reload search table view.
        [self.searchResultsTableViewController.tableView reloadData];
    }
}

- (void) searchTableList {
    [ self updateSearchResultsForSearchController:self.searchController];
}

- (void) pressSearchBarCancelButton {
    for (UIView *view in self.searchBar.subviews) {
        for (id subview in view.subviews) {
            if ( [subview isKindOfClass:[UIButton class]] ) {
                [(UIButton*)subview sendActionsForControlEvents: UIControlEventTouchUpInside];
                break;
            }
        }
    }
}

- (void) animateToDiveSite:(DiveSite *) diveSite {
    [self pressSearchBarCancelButton];
    
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat: 2] forKey:kCATransactionAnimationDuration];
    [self.mapView animateToCameraPosition: diveSite.cameraPosition];
    [CATransaction commit];
    [self.mapView setSelectedMarker:diveSite.marker];
}


// Rather than setting -myLocationEnabled to YES directly,
// call this method:

- (void)enableMyLocation
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];

    if (status == kCLAuthorizationStatusNotDetermined){
        [self requestLocationAuthorization];
    }else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted){
        return; // we weren't allowed to show the user's location so don't enable
    }else{
        [self.mapView setMyLocationEnabled:YES];
    }
}

// Ask the CLLocationManager for location authorization,
// and be sure to retain the manager somewhere on the class

- (void)requestLocationAuthorization
{
    _locationAuthorizationManager = [[CLLocationManager alloc] init];
    _locationAuthorizationManager.delegate = self;
    //    _locationAuthorizationManager.distanceFilter = kCLDistanceFilterNone;
    //    _locationAuthorizationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [_locationAuthorizationManager requestWhenInUseAuthorization];
//    [_locationAuthorizationManager startUpdatingLocation];
}

// Handle the authorization callback. This is usually
// called on a background thread so go back to main.

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status != kCLAuthorizationStatusNotDetermined) {
        [self performSelectorOnMainThread:@selector(enableMyLocation) withObject:nil waitUntilDone:[NSThread isMainThread]];
        
        _locationAuthorizationManager.delegate = nil;
        _locationAuthorizationManager = nil;
    }
}

@end