//
//  ViewController.h
//  Roatan Dive Sites
//
//  Created by Lucas Parry on 10/3/15.
//  Copyright (c) 2015 Lucas Parry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface DiveSiteMapController : UIViewController

@property (nonatomic, retain) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UISearchController *searchController;
@property (strong, nonatomic) IBOutlet UITableViewController *searchResultsTableViewController;

@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) NSArray *markers;



@end

