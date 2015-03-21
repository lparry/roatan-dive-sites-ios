//
//  DiveSite.m
//  Roatan Dive Sites
//
//  Created by Lucas Parry on 21/3/15.
//  Copyright (c) 2015 Lucas Parry. All rights reserved.
//

#import "DiveSite.h"

@implementation DiveSite

+ (id)diveSiteWithName:(NSString *)name latitude:(NSNumber *)lat longitude:(NSNumber *)lng depth:(NSString *)depth mooringSystem:(NSString *)mooring_system {
    
    DiveSite *newSite = [[self alloc] init];
    newSite.name = name;
    newSite.latitude = lat;
    newSite.longitude = lng;
    newSite.depth = depth;
    newSite.mooring_system = mooring_system;
    [newSite makeMarkerForSite];
    
    return newSite;
}

- (void) makeMarkerForSite{
    self.marker = [[GMSMarker alloc] init];
    self.marker.position = CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
    self.marker.title = self.name;
    self.marker.snippet = self.mooring_system;
    //    self.marker.icon = [UIImage imageNamed:@"turtle"];

}

- (GMSCameraPosition *) cameraPosition{
    return [GMSCameraPosition cameraWithLatitude: [self.latitude doubleValue]
                                       longitude: [self.longitude doubleValue]
                                            zoom:16];

}


@end