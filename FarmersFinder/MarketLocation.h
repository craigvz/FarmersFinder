//
//  MarketLocation.h
//  FarmersFinder
//
//  Created by Craig Vanderzwaag on 2/9/16.
//  Copyright © 2016 blueHula Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MarketLocation : MKPinAnnotationView

@property (copy) NSString *name;
@property (copy) NSString *address;

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;


@end
