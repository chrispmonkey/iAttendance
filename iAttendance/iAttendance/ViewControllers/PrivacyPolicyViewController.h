//
//  PrivacyPolicyViewController.h
//  iAttendance
//
//  Created by Christopher L. Price on 3/7/15.
//  Copyright (c) 2015 Christopher L. Price. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"

@interface PrivacyPolicyViewController : UIViewController<FUIAlertViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *privacyPolicyTextView;
@property (weak, nonatomic) NSTimer *scrollTimer;
@property (weak, nonatomic) IBOutlet FUIButton *cancelButton;
@property (weak, nonatomic) IBOutlet FUIButton *agreeButton;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)agreeButtonPressed:(id)sender;

@end
