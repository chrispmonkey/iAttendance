//
//  HomeViewController.h
//  iAttendance
//
//  Created by Christopher L. Price on 3/7/15.
//  Copyright (c) 2015 Christopher L. Price. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"
#import <MessageUI/MessageUI.h>

@interface HomeViewController : UIViewController<FUIAlertViewDelegate, MFMailComposeViewControllerDelegate>

- (IBAction)menuButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *adminButton;
@property (weak, nonatomic) IBOutlet UIButton *attendeeButton;
@property (weak, nonatomic) NSTimer *fadeTimer;

- (IBAction)infoButtonPressed:(id)sender;

@end
