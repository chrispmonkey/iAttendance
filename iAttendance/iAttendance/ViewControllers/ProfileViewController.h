//
//  ProfileViewController.h
//  iAttendance
//
//  Created by Christopher L. Price on 3/7/15.
//  Copyright (c) 2015 Christopher L. Price. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "FlatUIKit.h"

@interface ProfileViewController : UIViewController<ECSlidingViewControllerDelegate, FUIAlertViewDelegate,UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *largeProfileImageView;
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *changeProfileImageButton;
- (IBAction)eventsButtonPressed:(id)sender;

- (IBAction)menuButtonPressed:(id)sender;
- (IBAction)changeProfileImageButtonPressed:(id)sender;

@end
