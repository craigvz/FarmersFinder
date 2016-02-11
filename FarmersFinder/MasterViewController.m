//
//  MasterViewController.m
//  FarmersFinder
//
//  Created by Craig Vanderzwaag on 2/9/16.
//  Copyright © 2016 blueHula Studios. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "MarketTableViewCell.h"
#import "PopViewController.h"

@interface MasterViewController () <UIViewControllerPreviewingDelegate>

@property NSArray *markets;
@property (nonatomic, weak) NSDictionary *selectedMarketObject;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Create Array of Markets from Plist
    NSArray *unsortedMarkets = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sloMarkets" ofType:@"plist"]];
    
    //Sort Markets by date
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"marketStart" ascending: YES];
    
    //Instantiate our Markets Array with data sorted by date from now (soonest first)
    _markets = [unsortedMarkets sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [self checkFor3DTouch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkFor3DTouch {
    
        // register for 3D Touch (if available)
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            
        [self registerForPreviewingWithDelegate:(id)self sourceView:self.view];
        NSLog(@"3D Touch is available! Hurra!");
            
        // no need for our alternative anymore
        //   self.longPress.enabled = NO;
            
        } else {
            
        NSLog(@"3D Touch is not available on this device. Sniff!");
            
        // handle a 3D Touch alternative (long gesture recognizer)
        //   self.longPress.enabled = YES;
            
    }
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        //determine selected cell row
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        //create market object from selected row
        _selectedMarketObject = self.markets[indexPath.row];
        
        //instatiate detail view controller
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        
        //set detail item (marketObject)
        [controller setDetailItem:_selectedMarketObject];
        
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.markets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MarketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //create object for each cell
    NSDictionary *marketObject = self.markets[indexPath.row];
    
    //handle date formatting
    NSDate *startDate = [marketObject objectForKey:@"marketEnd"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, h:mm a"];
    NSString *startString = [dateFormatter stringFromDate:startDate];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *dayString = [dateFormatter stringFromDate:startDate];
    
    //set cell labels
    cell.cityLabel.text = [marketObject objectForKey:@"city"];
    cell.addressLabel.text = [marketObject objectForKey:@"address"];
    cell.timeLabel.text = startString;
    
    //set cell image
    if ([dayString isEqualToString:@"Monday"]) {
        cell.cellImage.image = [UIImage imageNamed:@"M"];
    }
    
    if ([dayString isEqualToString:@"Tuesday"]) {
        cell.cellImage.image = [UIImage imageNamed:@"Tu"];
    }
    
    if ([dayString isEqualToString:@"Wednesday"]) {
        cell.cellImage.image = [UIImage imageNamed:@"W"];
    }
    
    if ([dayString isEqualToString:@"Thursday"]) {
        cell.cellImage.image = [UIImage imageNamed:@"Th"];
    }
    
    if ([dayString isEqualToString:@"Friday"]) {
        cell.cellImage.image = [UIImage imageNamed:@"F"];
    }
    
    if ([dayString isEqualToString:@"Saturday"]) {
        cell.cellImage.image = [UIImage imageNamed:@"Sa"];
    }
    
    if ([dayString isEqualToString:@"Sunday"]) {
        cell.cellImage.image = [UIImage imageNamed:@"Su"];
    }
   
    return cell;
}

#pragma mark Peek and Pop

- (nullable UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    // check if we're not already displaying a preview controller
    if ([self.presentedViewController isKindOfClass:[PopViewController class]]) {
        return nil;
    }
    
    // shallow press: return the preview controller here (peek)
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    NSLog(@"INDEX PATH --> %@", indexPath);
    
    if (indexPath) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        //create object for each cell
        _selectedMarketObject = self.markets[indexPath.row];

        //Instatiate PopViewController
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PopViewController *previewController = [storyboard instantiateViewControllerWithIdentifier:@"pop"];
        
        previewController.passedMarketObject = _selectedMarketObject;
        
        previewingContext.sourceRect = cell.frame;
        
        return previewController;
    }
    
    return nil;
    
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
    // deep press: bring up the commit view controller (pop)
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *commitController = [storyboard instantiateViewControllerWithIdentifier:@"detail"];

    [commitController setDetailItem:_selectedMarketObject];

    [self showViewController:commitController sender:self];
}


@end
