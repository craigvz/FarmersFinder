//
//  PopViewController.m
//  FarmersFinder
//
//  Created by Craig Vanderzwaag on 2/11/16.
//  Copyright © 2016 blueHula Studios. All rights reserved.
//

#import "PopViewController.h"
#import <MapKit/MapKit.h>

@interface PopViewController ()


@end

@implementation PopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _featureLabel.text = [_passedMarketObject objectForKey:@"feature"];;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Preview Actions

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    
    // setup a list of preview actions
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"Route to Market" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Action 1 triggered");
        [self routeToIncidentFromUserLocation];
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"Visit Website" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Action 2 triggered");
        [self openURL];
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"Cancel" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Destructive Action triggered");
    }];
    
    // add them to an arrary
    NSArray *actions = @[action1, action2, action3];
    
    return actions;
    
}

-(void)routeToIncidentFromUserLocation {
    
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,};
    
    CLLocationCoordinate2D endingCoord = CLLocationCoordinate2DMake([[_passedMarketObject objectForKey:@"lat"] doubleValue], [[_passedMarketObject objectForKey:@"lon"] doubleValue]);
    
    MKPlacemark *endLocation = [[MKPlacemark alloc] initWithCoordinate:endingCoord addressDictionary:nil];
    
    MKMapItem *endingItem = [[MKMapItem alloc] initWithPlacemark:endLocation];
    
    endingItem.name = @"Market Location";
    
    [endingItem openInMapsWithLaunchOptions:launchOptions];
    
}

-(void)openURL {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_passedMarketObject objectForKey:@"url"]]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
