//
//  DetailViewController.m
//  FarmersFinder
//
//  Created by Craig Vanderzwaag on 2/9/16.
//  Copyright © 2016 blueHula Studios. All rights reserved.
//

#import "DetailViewController.h"
#import "MarketLocation.h"

#define METERS_PER_MILE 1609.344

@interface DetailViewController ()

@property (nonatomic, strong) MKPinAnnotationView *marketLocation;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        
        //Create CLLocationCoordinate2D
        CLLocationCoordinate2D marketCoord;
        marketCoord.latitude = [[_detailItem objectForKey:@"lat"]doubleValue];
        marketCoord.longitude = [[_detailItem objectForKey:@"lon"]doubleValue];
        
        //Create Market Location Annotation object
        _marketLocation = [[MarketLocation alloc] initWithName:@"Farmer's Market" address:[_detailItem objectForKey:@"address"] coordinate:marketCoord];
        
        //Add Annotation to Map
        [_marketMapView addAnnotation:(id)_marketLocation];
        
        //Adjust map to annotation
        [self zoomToFitAnnotations];
        
        //Select annotation so View shows with detail
        [_marketMapView selectAnnotation:(id)_marketLocation animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set inital zoom level
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude =  35.428612;
    zoomLocation.longitude= -120.363723;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 75*METERS_PER_MILE, 75*METERS_PER_MILE);
    
    [_marketMapView setRegion:viewRegion animated:YES];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *annotationIdentifier = @"AnnotationIdentifier";
    
    
    MarketLocation *pinView = (MarketLocation *) [_marketMapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    
    //If not already instatiated, create MKPinAnnotation
    if (!pinView)
    {
        pinView = [[MarketLocation alloc]
                   initWithAnnotation:annotation
                   reuseIdentifier:annotationIdentifier];
        
        pinView.pinTintColor = [UIColor redColor];
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

        
    }
    else
    {
        pinView.annotation = annotation;
    }
    
    return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    
    //get ending coordinate from selected pin annotation
    CLLocationCoordinate2D endingCoord;
    endingCoord.latitude = [[_marketMapView.selectedAnnotations objectAtIndex:0]coordinate].latitude;
    endingCoord.longitude = [[_marketMapView.selectedAnnotations objectAtIndex:0]coordinate].longitude;
    
    MKPlacemark *endLocation = [[MKPlacemark alloc] initWithCoordinate:endingCoord addressDictionary:nil];
    
    //adds location name to the ending point for diplay in the Maps App
    MKMapItem *endingItem = [[MKMapItem alloc] initWithPlacemark:endLocation];
    endingItem.name = @"Farmer's Market";
    
    //using Apple Maps- launches saying we want driving directions
    NSMutableDictionary *launchOptions = [[NSMutableDictionary alloc] init];
    [launchOptions setObject:MKLaunchOptionsDirectionsModeDriving forKey:MKLaunchOptionsDirectionsModeKey];
    [endingItem openInMapsWithLaunchOptions:launchOptions];
    
}


- (BOOL)openMapsWithItems:(NSArray *)mapItems launchOptions:(NSDictionary *)launchOptions{
    [MKMapItem openMapsWithItems:mapItems launchOptions:launchOptions];
    return YES;
    
}


-(void)zoomToFitAnnotations {
    
    //Sets zoom area to fit all annotations
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in _marketMapView.annotations)
        
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 20, 20);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    
    double inset = -zoomRect.size.width * 250;
    [_marketMapView setVisibleMapRect:MKMapRectInset(zoomRect, inset, inset) animated:YES];
    
}

@end
