//
//  MenuViewController.h
//  iAttendance
//
//  Created by Christopher L. Price on 3/7/15.
//  Copyright (c) 2015 Christopher L. Price. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"

@interface MenuViewController : UIViewController<UITableViewDataSource, FUIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userProfileName;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UILabel *accountType;

@end
