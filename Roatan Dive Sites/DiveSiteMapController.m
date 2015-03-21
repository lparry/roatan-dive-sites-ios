#import "DiveSiteMapController.h"

#define ResultsTableView self.searchResultsTableViewController.tableView

#define Identifier @"DiveSiteCell"

@interface DiveSiteMapController ()<GMSMapViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UITableViewDataSource, UITableViewDelegate> {

}

@end

@implementation DiveSiteMapController



- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Dive Site Map";
    }
    return self;
}

- (GMSMarker*) makeMarkerForSite:(NSString *)name withLat:(NSNumber *)lat withLng:(NSNumber *)lng{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
    marker.title = name;
    marker.snippet = @"extra data goes here";
    marker.map = self.mapView;
//    marker.icon = [UIImage imageNamed:@"turtle"];

    
    return marker;
}


- (void)viewDidLoad {
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:16.304449
                                                            longitude:-86.594018
                                                                 zoom:15];
    [self.mapView setCamera:camera];
    self.mapView.mapType = kGMSTypeHybrid;
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    self.mapView.settings.rotateGestures = NO;
    self.mapView.settings.tiltGestures = NO;
    
    
    NSMutableArray *tempMarkers = [NSMutableArray arrayWithObjects:
                               nil];
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"dive-sites" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSArray *siteData = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions
                                                  error:nil];
    
    for (NSDictionary *data in siteData) {
        [tempMarkers addObject: [self makeMarkerForSite: data[@"name"]
                                                withLat: (NSNumber *)data[@"latitude"]
                                                withLng: (NSNumber *)data[@"longitude"]]];

    }
    

    self.markers = tempMarkers;
    tempMarkers = nil;
    
    self.tableData = [self.markers sortedArrayUsingComparator:^NSComparisonResult(GMSMarker *obj1, GMSMarker *obj2) {
        return [obj2.title localizedCaseInsensitiveCompare:obj1.title] == NSOrderedAscending;
    }];

   // self.results = [[NSMutableArray alloc] init];
    
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
    else {
       // self.results = [self.tableData copy];
       // [self.searchResultsTableViewController.tableView reloadData];
    }
}

- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

    //[searchBar setShowsCancelButton:NO animated:YES];
    self.searchBar.text = nil;
    [self.searchController setActive:NO];
    
    [searchBar resignFirstResponder];

//    [self.view bringSubviewToFront:self.mapView];
//
//    [searchBar resignFirstResponder];
//    [ResultsTableView resignFirstResponder];
//    [ResultsTableView removeFromSuperview];
//    [self.searchController setDimsBackgroundDuringPresentation:NO];
//    self.searchController.dimsBackgroundDuringPresentation = NO;
//    ResultsTableView.hidden = YES;
//    NSLog(@"%i", self.searchController.isModalInPopover);

    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchTableList];
    if (self.results.count == 1) {
        [self animateToMarker:(GMSMarker*)self.results[0]];

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

    cell.textLabel.text = ((GMSMarker*)self.results[indexPath.row]).title;
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    [self animateToMarker:(GMSMarker*)self.results[indexPath.row]];
  

}



#pragma mark - Search Results Updating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {

    if (self.searchBar.text.length > 0) {
        NSString *text = self.searchBar.text;
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *diveSite, NSDictionary *bindings) {

            NSRange range = [[(GMSMarker*)diveSite title] rangeOfString:text options:NSCaseInsensitiveSearch];

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

- (void) animateToMarker:(GMSMarker*) marker {
    [self pressSearchBarCancelButton];
    
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat: 2] forKey:kCATransactionAnimationDuration];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: marker.position.latitude
                                                            longitude:marker.position.longitude
                                                                 zoom:16];
    [self.mapView animateToCameraPosition: camera];
    [CATransaction commit];
    [self.mapView setSelectedMarker:marker];
}

@end