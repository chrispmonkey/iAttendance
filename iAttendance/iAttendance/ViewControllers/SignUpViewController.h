//
//  SignUpViewController.h
//  iAttendance
//
//  Created by Christopher L. Price on 3/7/15.
//  Copyright (c) 2015 Christopher L. Price. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"

@interface SignUpViewController : UIViewController <UITextFieldDelegate, FUIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *firstNameView;
@property (weak, nonatomic) IBOutlet UIView *lastNameView;
@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet FUIButton *signUpButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)signUpButtonPressed:(id)sender;

@end
