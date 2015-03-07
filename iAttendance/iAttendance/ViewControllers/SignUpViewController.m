//
//  SignUpViewController.m
//  iAttendance
//
//  Created by Christopher L. Price on 3/7/15.
//  Copyright (c) 2015 Christopher L. Price. All rights reserved.
//

#import "SignUpViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

@interface SignUpViewController ()

@end

@implementation SignUpViewController

UITextField *activeField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    
    // Changes the corner radius of the views behind the textFields
    self.firstNameView.layer.cornerRadius = 6.0f;
    self.lastNameView.layer.cornerRadius = 6.0f;
    self.usernameView.layer.cornerRadius = 6.0f;
    self.emailView.layer.cornerRadius = 6.0f;
    self.passwordView.layer.cornerRadius = 6.0f;
    
    
    if ([self.usernameTextField respondsToSelector:@selector(setAttributedPlaceholder:)] && [self.emailTextField respondsToSelector:@selector(setAttributedPlaceholder:)] && [self.passwordTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor whiteColor];
        self.firstNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{NSForegroundColorAttributeName: color}];
        self.lastNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{NSForegroundColorAttributeName: color}];
        
        self.usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
        self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
        //self.emailTextBox.textColor = [UIColor whiteColor];
        self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
        //self.passwordTextBox.textColor = [UIColor whiteColor];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    
    // FLAT UIKIT BUTTON CUSTOMIZATIONS
    // SignIn Button
    
//    UIGraphicsBeginImageContext(self.view.frame.size);
//    //[[UIImage imageNamed:@"login_background_blur.png"] drawInRect:self.view.bounds];
//    [[UIImage imageNamed:@"background.jpg"] drawInRect:self.view.frame];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    self.signUpButton.buttonColor = [UIColor concreteColor];
    self.signUpButton.shadowColor = [UIColor asbestosColor];
    self.signUpButton.shadowHeight = 3.0f;
    self.signUpButton.cornerRadius = 6.0f;
    //self.signUpButton.titleLabel.font = [UIFont boldFlatFontOfSize:30];
    [self.signUpButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.signUpButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.usernameTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [self registerForKeyboardNotifications];

}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)signUpButtonPressed:(id)sender {
    
    PFUser *user = [PFUser user];
    user[@"firstName"] = self.firstNameTextField.text;
    user[@"lastName"] = self.lastNameTextField.text;
    user.username = self.usernameTextField.text;
    user.password = self.passwordTextField.text;
    user.email = self.emailTextField.text;
    
    // other fields can be set just like with PFObject
    //user[@"phone"] = @"415-392-0202";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            NSLog(@"User successfully signed up!");
            [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text
                                            block:^(PFUser *user, NSError *error) {
                                                if (user) {
                                                    // Do stuff after successful login.
                                                    NSLog(@"User successfully logged in!");
                                                    // Makes the root view controller dismiss the view. The login view controller may still be available.
                                                    // May be a better and more efficient way to do this
                                                    // Check out  http://stackoverflow.com/questions/14907518/modal-view-controllers-how-to-display-and-dismiss
                                                    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                                                } else {
                                                    // The login failed. Check error to see why.
                                                    NSString *errorString = [error userInfo][@"error"];
                                                    // Show the errorString somewhere and let the user try again.
                                                    FUIAlertView * loginAlert =[[FUIAlertView alloc ] initWithTitle:@"Log In Error"
                                                                                                            message:errorString
                                                                                                           delegate:self
                                                                                                  cancelButtonTitle:@"OK"
                                                                                                  otherButtonTitles: nil];
                                                    loginAlert.tag = 101;
                                                    loginAlert.titleLabel.textColor = [UIColor cloudsColor];
                                                    loginAlert.titleLabel.font = [UIFont boldFlatFontOfSize:16];
                                                    loginAlert.messageLabel.textColor = [UIColor cloudsColor];
                                                    loginAlert.messageLabel.font = [UIFont flatFontOfSize:14];
                                                    loginAlert.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
                                                    loginAlert.alertContainer.backgroundColor = [UIColor midnightBlueColor];
                                                    loginAlert.defaultButtonColor = [UIColor cloudsColor];
                                                    loginAlert.defaultButtonShadowColor = [UIColor asbestosColor];
                                                    loginAlert.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
                                                    loginAlert.defaultButtonTitleColor = [UIColor asbestosColor];
                                                    
                                                    [loginAlert show];
                                                    
                                                }
                                            }];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            FUIAlertView * loginAlert =[[FUIAlertView alloc ] initWithTitle:@"Sign Up Error"
                                                                    message:errorString
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
            loginAlert.tag = 100;
            loginAlert.titleLabel.textColor = [UIColor cloudsColor];
            loginAlert.titleLabel.font = [UIFont boldFlatFontOfSize:16];
            loginAlert.messageLabel.textColor = [UIColor cloudsColor];
            loginAlert.messageLabel.font = [UIFont flatFontOfSize:14];
            loginAlert.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
            loginAlert.alertContainer.backgroundColor = [UIColor midnightBlueColor];
            loginAlert.defaultButtonColor = [UIColor cloudsColor];
            loginAlert.defaultButtonShadowColor = [UIColor asbestosColor];
            loginAlert.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
            loginAlert.defaultButtonTitleColor = [UIColor asbestosColor];
            
            [loginAlert show];
        }
    }];

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if(textField==self.firstNameTextField){
        [self.lastNameTextField becomeFirstResponder];
    }else if (textField == self.lastNameTextField)
    {
        [self.usernameTextField becomeFirstResponder];
    }else if (textField == self.usernameTextField)
    {
        [self.emailTextField becomeFirstResponder];
    }else if (textField == self.emailTextField)
    {
        [self.passwordTextField becomeFirstResponder];
    }else if (textField == self.passwordTextField)
    {
        [textField resignFirstResponder];
    }
    else{
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)dismissKeyboard {
    [self.firstNameTextField resignFirstResponder];
    [self.lastNameTextField resignFirstResponder];
    [self.usernameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

@end
