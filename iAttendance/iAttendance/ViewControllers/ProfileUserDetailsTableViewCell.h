//
//  ProfileUserDetailsTableViewCell.h
//  Spotter
//
//  Created by Christopher L. Price on 3/2/15.
//  Copyright (c) 2015 Christopher L. Price. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileUserDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *UserDetailsTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *boyGirlIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userQuickDetailLabel;

@end
