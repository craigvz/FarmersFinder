//
//  MarketLocation.m
//  FarmersFinder
//
//  Created by Craig Vanderzwaag on 2/9/16.
//  Copyright © 2016 blueHula Studios. All rights reserved.
//

#import "MarketLocation.h"

@implementation MarketLocation

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
        
    }
    return self;
}

- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    
    return _address;
}


@end
