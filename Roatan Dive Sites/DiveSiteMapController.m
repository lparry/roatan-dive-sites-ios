#import "DiveSiteMapController.h"

@interface DiveSiteMapController ()<GMSMapViewDelegate, UISearchBarDelegate> {
    NSMutableArray *contentList;
    NSMutableArray *filteredContentList;
    BOOL isSearching;
}

@property(strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

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

- (GMSMarker*) makeMarkerForSite:(NSString *)name withLat:(double)lat withLng:(double)lng{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(lat, lng);
    marker.title = name;
    marker.snippet = @"foo";
    marker.map = self.mapView;
    marker.icon = [UIImage imageNamed:@"turtle"];

    
    return marker;
}


- (void)viewDidLoad {
    
    
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f,0.0f,320.0f,0.0f)];
    [self.searchBar sizeToFit];
    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.searchBar.placeholder = @"Search for a dive site...";
    self.searchBar.delegate = self;

    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    // 16.304449, -86.594018
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:16.304449
                                                            longitude:-86.594018
                                                                 zoom:15];
    self.mapView = [GMSMapView mapWithFrame:self.view.frame camera:camera];
    self.mapView.mapType = kGMSTypeHybrid;
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    self.mapView.settings.rotateGestures = NO;
    self.mapView.settings.tiltGestures = NO;
    
    [self.view addSubview: self.mapView];
//    [self.view ];
    NSLog(@" %i ", [[self.view subviews] count]);
    
    NSMutableArray *markers = [NSMutableArray arrayWithObjects:
                               nil];
    
    [markers addObject: [self makeMarkerForSite: @"GranMarie's Sea Garden" withLat:16.37303 withLng:-86.48282]];
    [markers addObject: [self makeMarkerForSite: @"Key Hole  " withLat:16.36845 withLng:-86.50275]];
    [markers addObject: [self makeMarkerForSite: @"Spencer's Rose Garden" withLat:16.35742 withLng:-86.53162]];
    [markers addObject: [self makeMarkerForSite: @"B's deep" withLat:16.3538 withLng:-86.53823]];
    [markers addObject: [self makeMarkerForSite: @"Odyssey wreck" withLat:16.35093 withLng:-86.54468]];
    [markers addObject: [self makeMarkerForSite: @"Havey's Hideaway" withLat:16.3491 withLng:-86.5495]];
    [markers addObject: [self makeMarkerForSite: @"Moyra channel" withLat:16.34898 withLng:-86.55148]];
    [markers addObject: [self makeMarkerForSite: @"Lynn's arena" withLat:16.34492 withLng:-86.55585]];
    [markers addObject: [self makeMarkerForSite: @"Barry's reef" withLat:16.34277 withLng:-86.55893]];
    [markers addObject: [self makeMarkerForSite: @"Déjà vu" withLat:16.34218 withLng:-86.56025]];
    [markers addObject: [self makeMarkerForSite: @"Four sponges" withLat:16.34153 withLng:-86.56162]];
    [markers addObject: [self makeMarkerForSite: @"Wrasse hole" withLat:16.34052 withLng:-86.56172]];
    [markers addObject: [self makeMarkerForSite: @"Spooky channel (outside)" withLat:16.33943 withLng:-86.56448]];
    [markers addObject: [self makeMarkerForSite: @"White Hole" withLat:16.33763 withLng:-86.5664]];
    [markers addObject: [self makeMarkerForSite: @"Bears den" withLat:16.33677 withLng:-86.56873]];
    [markers addObject: [self makeMarkerForSite: @"Captain Bob's " withLat:16.33645 withLng:-86.56975]];
    [markers addObject: [self makeMarkerForSite: @"Peter's place" withLat:16.33542 withLng:-86.57105]];
    [markers addObject: [self makeMarkerForSite: @"Zack's Patch" withLat:16.3333 withLng:-86.57162]];
    [markers addObject: [self makeMarkerForSite: @"Mack's wall" withLat:16.33242 withLng:-86.57213]];
    [markers addObject: [self makeMarkerForSite: @"Front Porch" withLat:16.33433 withLng:-86.5712]];
    [markers addObject: [self makeMarkerForSite: @"Tommy's Laugh " withLat:16.32718 withLng:-86.57683]];
    [markers addObject: [self makeMarkerForSite: @"El Aguila " withLat:16.32742 withLng:-86.57822]];
    [markers addObject: [self makeMarkerForSite: @"El Aguila Shore" withLat:16.32713 withLng:-86.57875]];
    [markers addObject: [self makeMarkerForSite: @"El Aguila Boat" withLat:16.3275 withLng:-86.57903]];
    [markers addObject: [self makeMarkerForSite: @"Pillar coral" withLat:16.32632 withLng:-86.58083]];
    [markers addObject: [self makeMarkerForSite: @"Schaeftown" withLat:16.32437 withLng:-86.58237]];
    [markers addObject: [self makeMarkerForSite: @"Green outhouse" withLat:16.32448 withLng:-86.58208]];
    [markers addObject: [self makeMarkerForSite: @"Over Heat" withLat:16.32338 withLng:-86.58293]];
    [markers addObject: [self makeMarkerForSite: @"Hole in the Wallet" withLat:16.32285 withLng:-86.58362]];
    [markers addObject: [self makeMarkerForSite: @"Melissa's" withLat:16.32145 withLng:-86.58435]];
    [markers addObject: [self makeMarkerForSite: @"Robin's Nest" withLat:16.32133 withLng:-86.58485]];
    [markers addObject: [self makeMarkerForSite: @"Gibson bite" withLat:16.32042 withLng:-86.58588]];
    [markers addObject: [self makeMarkerForSite: @"Dennis's Dropoff" withLat:16.31892 withLng:-86.58662]];
    [markers addObject: [self makeMarkerForSite: @"Happily Ever" withLat:16.3184 withLng:-86.58777]];
    [markers addObject: [self makeMarkerForSite: @"Fish den" withLat:16.31735 withLng:-86.58873]];
    [markers addObject: [self makeMarkerForSite: @"Canyon Reef" withLat:16.31513 withLng:-86.59045]];
    [markers addObject: [self makeMarkerForSite: @"Hole in the wall" withLat:16.3138 withLng:-86.59178]];
    [markers addObject: [self makeMarkerForSite: @"The Wife" withLat:16.31235 withLng:-86.59393]];
    [markers addObject: [self makeMarkerForSite: @"Grape escape" withLat:16.31167 withLng:-86.59443]];
    [markers addObject: [self makeMarkerForSite: @"Vern's Drop off" withLat:16.3094 withLng:-86.59613]];
    [markers addObject: [self makeMarkerForSite: @"Dixies" withLat:16.30598 withLng:-86.59745]];
    [markers addObject: [self makeMarkerForSite: @"Moonlight" withLat:16.30552 withLng:-86.59738]];
    [markers addObject: [self makeMarkerForSite: @"Lighthouse reef " withLat:16.30488 withLng:-86.59757]];
    [markers addObject: [self makeMarkerForSite: @"El aquario" withLat:16.30245 withLng:-86.5982]];
    [markers addObject: [self makeMarkerForSite: @"Ocean Groove" withLat:16.30232 withLng:-86.59912]];
    [markers addObject: [self makeMarkerForSite: @"Jolly Roger 1" withLat:16.30108 withLng:-86.5996]];
    [markers addObject: [self makeMarkerForSite: @"Jolly Roger 2" withLat:16.30055 withLng:-86.59987]];
    [markers addObject: [self makeMarkerForSite: @"Haller Deep" withLat:16.30065 withLng:-86.60052]];
    [markers addObject: [self makeMarkerForSite: @"Blue channel" withLat:16.29952 withLng:-86.6009]];
    [markers addObject: [self makeMarkerForSite: @"The Bight" withLat:16.29837 withLng:-86.60052]];
    [markers addObject: [self makeMarkerForSite: @"Bikini Bottom" withLat:16.29783 withLng:-86.60092]];
    [markers addObject: [self makeMarkerForSite: @"Octopus Acre" withLat:16.29525 withLng:-86.60242]];
    [markers addObject: [self makeMarkerForSite: @"Barman's Choice" withLat:16.29343 withLng:-86.60232]];
    [markers addObject: [self makeMarkerForSite: @"Shallow Turtle Crossing" withLat:16.2928 withLng:-86.60258]];
    [markers addObject: [self makeMarkerForSite: @"Deep Turtle Crossing" withLat:16.29352 withLng:-86.60373]];
    [markers addObject: [self makeMarkerForSite: @"Jolly Roger 3" withLat:16.29218 withLng:-86.60253]];
    [markers addObject: [self makeMarkerForSite: @"Shallow seaquest" withLat:16.29068 withLng:-86.60257]];
    [markers addObject: [self makeMarkerForSite: @"Blue Moonshine" withLat:16.29132 withLng:-86.6037]];
    [markers addObject: [self makeMarkerForSite: @"Three Brothers" withLat:16.29082 withLng:-86.60425]];
    [markers addObject: [self makeMarkerForSite: @"Slippery Nick" withLat:16.28997 withLng:-86.60268]];
    [markers addObject: [self makeMarkerForSite: @"Jolly Roger 4" withLat:16.28902 withLng:-86.60265]];
    [markers addObject: [self makeMarkerForSite: @"Alice's Wonderland" withLat:16.28818 withLng:-86.6045]];
    [markers addObject: [self makeMarkerForSite: @"Tabyana's 2" withLat:16.28743 withLng:-86.60375]];
    [markers addObject: [self makeMarkerForSite: @"Punchers Paradise" withLat:16.28565 withLng:-86.60382]];
    [markers addObject: [self makeMarkerForSite: @"Tabyana's 1" withLat:16.28425 withLng:-86.60453]];
    [markers addObject: [self makeMarkerForSite: @"Jumpin Jack" withLat:16.28132 withLng:-86.60443]];
    [markers addObject: [self makeMarkerForSite: @"Jack's Place" withLat:16.2795 withLng:-86.60443]];
    [markers addObject: [self makeMarkerForSite: @"Buchos" withLat:16.27863 withLng:-86.60415]];
    [markers addObject: [self makeMarkerForSite: @"Shallow Buchos" withLat:16.27798 withLng:-86.6031]];
    [markers addObject: [self makeMarkerForSite: @"Chloe's Coral " withLat:16.27708 withLng:-86.6035]];
    [markers addObject: [self makeMarkerForSite: @"Kaylee's Day Dream" withLat:16.27447 withLng:-86.60258]];
    [markers addObject: [self makeMarkerForSite: @"Temptation Reef" withLat:16.27320 withLng:-86.60275]];
    [markers addObject: [self makeMarkerForSite: @"Mandy's Eel garden" withLat:16.27285 withLng:-86.60205]];
    [markers addObject: [self makeMarkerForSite: @"Willie's Wonder" withLat:16.27133 withLng:-86.60217]];
    [markers addObject: [self makeMarkerForSite: @"Black rock" withLat:16.26943 withLng:-86.60302]];
    [markers addObject: [self makeMarkerForSite: @"Bucca Quay" withLat:16.26818 withLng:-86.60325]];
    [markers addObject: [self makeMarkerForSite: @"Texas" withLat:16.26562 withLng:-86.60327]];
    [markers addObject: [self makeMarkerForSite: @"Pablo's place" withLat:16.26558 withLng:-86.60114]];
    [markers addObject: [self makeMarkerForSite: @"R & R's Easel" withLat:16.26768 withLng:-86.59702]];
    [markers addObject: [self makeMarkerForSite: @"Key Hole East" withLat:16.27232 withLng:-86.59174]];
    [markers addObject: [self makeMarkerForSite: @"Angies " withLat:16.29312 withLng:-86.56772]];
    [markers addObject: [self makeMarkerForSite: @"Papa Rons" withLat:16.29132 withLng:-86.56965]];
    [markers addObject: [self makeMarkerForSite: @"South Side 2 Canyon drop" withLat:16.28813 withLng:-86.57387]];
    [markers addObject: [self makeMarkerForSite: @"Pirates Coves" withLat:16.28373 withLng:-86.57918]];
    [markers addObject: [self makeMarkerForSite: @"South Side Cave" withLat:16.27983 withLng:-86.58368]];
    [markers addObject: [self makeMarkerForSite: @"Staghorn Alley" withLat:16.27702 withLng:-86.58648]];
    [markers addObject: [self makeMarkerForSite: @"Swing city" withLat:16.2751 withLng:-86.58915]];
    [markers addObject: [self makeMarkerForSite: @"Blue Hole 1" withLat:16.30287 withLng:-86.51937]];
    [markers addObject: [self makeMarkerForSite: @"Blue Hole 2" withLat:16.2989 withLng:-86.52128]];
    [markers addObject: [self makeMarkerForSite: @"Blue Hole 3" withLat:16.30062 withLng:-86.51885]];
    [markers addObject: [self makeMarkerForSite: @"Litas Hole" withLat:16.31933 withLng:-86.49463]];
    [markers addObject: [self makeMarkerForSite: @"Shark Bait Shallow" withLat:16.32097 withLng:-86.49008]];
    [markers addObject: [self makeMarkerForSite: @"Shark Bait Deep" withLat:16.32207 withLng:-86.48553]];
    [markers addObject: [self makeMarkerForSite: @"Connies Dream" withLat:16.32362 withLng:-86.48353]];
    [markers addObject: [self makeMarkerForSite: @"Marylyns" withLat:16.325 withLng:-86.48238]];
    [markers addObject: [self makeMarkerForSite: @"The cut" withLat:16.3283 withLng:-86.48153]];
    [markers addObject: [self makeMarkerForSite: @"Elbow" withLat:16.33135 withLng:-86.47895]];
    [markers addObject: [self makeMarkerForSite: @"Unkown" withLat:16.33172 withLng:-86.47652]];
    [markers addObject: [self makeMarkerForSite: @"John's Spot" withLat:16.33282 withLng:-86.4731]];
    [markers addObject: [self makeMarkerForSite: @"Cemetery" withLat:16.33563 withLng:-86.4718]];
    [markers addObject: [self makeMarkerForSite: @"Mary's Place" withLat:16.33683 withLng:-86.46867]];
    [markers addObject: [self makeMarkerForSite: @"Mary's 2" withLat:16.33752 withLng:-86.4685]];
    [markers addObject: [self makeMarkerForSite: @"Lobster Fingers" withLat:16.34253 withLng:-86.46532]];
    [markers addObject: [self makeMarkerForSite: @"Arch Bank" withLat:16.34837 withLng:-86.44818]];
    [markers addObject: [self makeMarkerForSite: @"French Bank" withLat:16.3461 withLng:-86.44675]];
    [markers addObject: [self makeMarkerForSite: @"French key Cut" withLat:16.3502 withLng:-86.44603]];
    [markers addObject: [self makeMarkerForSite: @"Frenchys 44" withLat:16.34883 withLng:-86.4436]];
    [markers addObject: [self makeMarkerForSite: @"Gold Chain Reef" withLat:16.3506 withLng:-86.43705]];
    [markers addObject: [self makeMarkerForSite: @"Valley of the kings" withLat:16.35073 withLng:-86.43587]];
    [markers addObject: [self makeMarkerForSite: @"40ft point" withLat:16.35127 withLng:-86.4345]];
    [markers addObject: [self makeMarkerForSite: @"Managerie" withLat:16.35233 withLng:-86.43447]];
    [markers addObject: [self makeMarkerForSite: @"Anchors Place" withLat:16.35495 withLng:-86.42137]];
    [markers addObject: [self makeMarkerForSite: @"Iron Shore" withLat:16.35543 withLng:-86.4192]];
    [markers addObject: [self makeMarkerForSite: @"Inside outside" withLat:16.35575 withLng:-86.40947]];
    [markers addObject: [self makeMarkerForSite: @"Pirates point" withLat:16.35608 withLng:-86.40715]];
    [markers addObject: [self makeMarkerForSite: @"Parrot Tree" withLat:16.35737 withLng:-86.40672]];
    [markers addObject: [self makeMarkerForSite: @"Single diver .com" withLat:16.36373 withLng:-86.4077]];
    [markers addObject: [self makeMarkerForSite: @"Neverstain" withLat:16.35915 withLng:-86.40135]];
    [markers addObject: [self makeMarkerForSite: @"Carib Point" withLat:16.35967 withLng:-86.38825]];
    [markers addObject: [self makeMarkerForSite: @"Key Hole" withLat:16.36858 withLng:-86.38642]];
    [markers addObject: [self makeMarkerForSite: @"Pondview " withLat:16.37288 withLng:-86.3734]];
    [markers addObject: [self makeMarkerForSite: @"Calvins Crack" withLat:16.37538 withLng:-86.36893]];
    [markers addObject: [self makeMarkerForSite: @"Tortuga Reef" withLat:16.37615 withLng:-86.36763]];
    [markers addObject: [self makeMarkerForSite: @"Jonesville Harbor" withLat:16.38353 withLng:-86.35993]];
    [markers addObject: [self makeMarkerForSite: @"Jonesville Channel" withLat:16.38425 withLng:-86.358]];
    [markers addObject: [self makeMarkerForSite: @"Crab Wall" withLat:16.38487 withLng:-86.3523]];
    [markers addObject: [self makeMarkerForSite: @"Reef House" withLat:16.38632 withLng:-86.35022]];
    [markers addObject: [self makeMarkerForSite: @"White House" withLat:16.38762 withLng:-86.33528]];
    [markers addObject: [self makeMarkerForSite: @"Mora channel" withLat:16.34898 withLng:-86.55148]];

    

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.mapView.padding = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0);
}

// search bar hax

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self->isSearching = YES;
    [self.searchBar setShowsCancelButton:YES animated:YES];
//    UISearch

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"Text change - %d",isSearching);
    
    //Remove all objects first.
    [filteredContentList removeAllObjects];
    
    if([searchText length] != 0) {
        isSearching = YES;
//        [self searchTableList];
    }
    else {
        isSearching = NO;
    }
    // [self.tblContentList reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
    [self.searchBar setShowsCancelButton:NO animated:YES];
    self.searchBar.text = nil;
    [searchBar resignFirstResponder];

}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search submitted");
   // [self searchTableList];
}


@end