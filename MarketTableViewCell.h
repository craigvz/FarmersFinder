//
//  MarketTableViewCell.h
//  FarmersFinder
//
//  Created by Craig Vanderzwaag on 2/9/16.
//  Copyright © 2016 blueHula Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarketTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;

@end
