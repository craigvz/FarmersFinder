//
//  LocationManager.m
//  emsguide
//
//  Created by Craig VanderZwaag on 1/24/13.
//  Copyright (c) 2013 blueHulaStudios. All rights reserved.
//



#import "BHLocationManager.h"

@implementation BHLocationManager

@synthesize locationManager;

- (id)init {
    self = [super init];
    
    if(self) {
        if(self) {
            self.locationManager = [CLLocationManager new];
            [self.locationManager setDelegate:self];
            
            //iOS 8 permissions requirement check
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                
               // NSLog(@"Auth Status %d", [CLLocationManager authorizationStatus]);
                [self.locationManager requestWhenInUseAuthorization];
                
            }
        }
        
        //[self.locationManager setDistanceFilter:100.0f];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
        [self.locationManager startUpdatingLocation];
        
    }
    
    return self;
}



+ (BHLocationManager *)sharedManager
{
    static BHLocationManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[BHLocationManager alloc] init];

    });
    return sharedManager;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [self.delegate locationUpdate:[locations lastObject]];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"this is the location error code --> %d", (error.code == kCLErrorDenied));
    
}

@end
