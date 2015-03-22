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
    newSite.mooringSystem = mooring_system;
    [newSite calculateDepths];

    [newSite makeMarkerForSite];
    
    return newSite;
}

- (void) makeMarkerForSite{
    self.marker = [[GMSMarker alloc] init];
    self.marker.position = CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
    self.marker.title = self.name;
    self.marker.snippet = [self stringForSnippet];
    //    self.marker.icon = [UIImage imageNamed:@"turtle"];

}

- (GMSCameraPosition *) cameraPosition{
    return [GMSCameraPosition cameraWithLatitude: [self.latitude doubleValue]
                                       longitude: [self.longitude doubleValue]
                                            zoom:16];

}

- (NSString *) stringForSnippet{
    NSString *string = @"\n";
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:6];
    
    
    if (self.depthInFeet != 0) {
        string = [string  stringByAppendingFormat: @"%ldM / %ldft, ", (long)self.depthInMetres, (long)self.depthInFeet];
    }else{
        string = [string stringByAppendingString: @"Unknown depth, "];
    }
    
    if ([self.mooringSystem length] > 0){
     string = [string  stringByAppendingFormat: @"%@ mooring", self.mooringSystem];
    }else{
        string = [string stringByAppendingString: @"Unknown mooring"];
    }
    
    string = [string  stringByAppendingFormat: @"\n\nGPS: %@, %@", [formatter stringFromNumber:self.latitude], [formatter stringFromNumber:self.longitude ]];

    return string;
}

- (void) calculateDepths {
    // Intermediate
    NSString *numberString;
    
    NSScanner *scanner = [NSScanner scannerWithString:self.depth];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    // Throw away characters before the first number.
    [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
    
    // Collect numbers.
    [scanner scanCharactersFromSet:numbers intoString:&numberString];
    
    // Result.
    self.depthInFeet = [numberString integerValue];
    self.depthInMetres = self.depthInFeet / 3.28084;
}


@end