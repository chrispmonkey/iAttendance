//
//  LoginViewController.h
//  iAttendance
//
//  Created by Christopher L. Price on 3/7/15.
//  Copyright (c) 2015 Christopher L. Price. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import "FlatUIKit.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate, FUIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet FUIButton *signInButton;
@property (weak, nonatomic) IBOutlet FUIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)signInButtonPressed:(id)sender;
- (IBAction)signUpButtonPressed:(id)sender;
- (IBAction)privacyPolicyButtonPressed:(id)sender;
@end
