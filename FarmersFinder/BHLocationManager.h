//
//  BHLocationManager.h
//  emsguide
//
//  Created by Craig VanderZwaag on 1/24/13.
//  Copyright (c) 2013 blueHulaStudios. All rights reserved.
//

//Singleton class which can be used to obtain user location information

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@protocol BHLocationManagerDelegate

- (void)locationUpdate:(CLLocation*)location;

@end


@interface BHLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, weak) id  delegate;


+ (BHLocationManager*)sharedManager;

@end
