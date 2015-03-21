//
//  DiveSite.h
//  Roatan Dive Sites
//
//  Created by Lucas Parry on 21/3/15.
//  Copyright (c) 2015 Lucas Parry. All rights reserved.
//

#ifndef Roatan_Dive_Sites_DiveSite_h
#define Roatan_Dive_Sites_DiveSite_h

#import <GoogleMaps/GoogleMaps.h>

@interface DiveSite : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSString *depth;
@property (strong, nonatomic) NSString *mooring_system;
@property (strong, nonatomic) GMSMarker *marker;

+ (id)diveSiteWithName:(NSString *)type latitude:(NSNumber *)lat longitude:(NSNumber *)lng depth:(NSString *)depth mooringSystem:(NSString *)mooring_system;


@end

#endif
