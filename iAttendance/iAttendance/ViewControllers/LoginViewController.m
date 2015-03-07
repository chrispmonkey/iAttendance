//
//  LoginViewController.m
//  iAttendance
//
//  Created by Christopher L. Price on 3/7/15.
//  Copyright (c) 2015 Christopher L. Price. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

UITextField *activeField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.// Code to make the view not resize for the status bar
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    
    // Changes the corner radius of the views behind the textFields
    self.usernameView.layer.cornerRadius = 6.0f;
    self.passwordView.layer.cornerRadius = 6.0f;
    
    // FLAT UIKIT BUTTON CUSTOMIZATIONS
    // SignIn Button
    self.signInButton.buttonColor = [UIColor concreteColor];
    self.signInButton.shadowColor = [UIColor asbestosColor];
    self.signInButton.shadowHeight = 3.0f;
    self.signInButton.cornerRadius = 6.0f;
    //self.signInButton.titleLabel.font = [UIFont boldFlatFontOfSize:30];
    [self.signInButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.signInButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    // SignUp Button
    self.signUpButton.buttonColor = [UIColor wetAsphaltColor];
    self.signUpButton.shadowColor = [UIColor colorFromHexCode:@"283848"];
    self.signUpButton.shadowHeight = 3.0f;
    self.signUpButton.cornerRadius = 6.0f;
    //self.signUpButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:30];
    [self.signUpButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.signUpButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    if ([self.usernameTextField respondsToSelector:@selector(setAttributedPlaceholder:)] && [self.passwordTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor whiteColor];
        self.usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
        //self.emailTextBox.textColor = [UIColor whiteColor];
        self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
        //self.passwordTextBox.textColor = [UIColor whiteColor];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    
//    UIGraphicsBeginImageContext(self.view.frame.size);
//    
//    [[UIImage imageNamed:@"background.jpg"] drawInRect:self.view.frame];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [self registerForKeyboardNotifications];
    
    [self checkBluetooth];
    
    // Possibly Used to access the specific value in the plist for using TouchID
//    NSString *path = [[NSBundle mainBundle] pathForResource: @"Root" ofType: @"plist"];
//    NSMutableDictionary *dictplist =[[NSMutableDictionary alloc] initWithContentsOfFile:path];
    //    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    //    testObject[@"foo"] = @"bar";
    //    [testObject saveInBackground];
    
    // TouchID Login SetUp Condition
    //    if (<#condition#>) {
    //        <#statements#>
    //        [self login];
    //    }
    
    //[self login];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)checkBluetooth
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self checkIfShouldLoadPrivacyPolicy];
}

- (void)checkIfShouldLoadPrivacyPolicy
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *privacyPolicyView = [storyboard instantiateViewControllerWithIdentifier:@"PrivacyPolicyViewController"];
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"userAgreedToPrivacyPolicy"]) {
        NSLog(@"User has not agreed to privacy policy");
        
        [self presentViewController:privacyPolicyView animated:YES completion:nil];
    } else {
        // user agreed to privacy policy
        NSLog(@"User agreed to privacy policy");
    }
    
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

// Login using TouchID
- (void)login
{
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myReasonString = @"Login to Spotter using TouchID";
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    // User authenticated successfully, use last logged in user
                                    // TODO: Add settings to enable or disable this
                                    
                                    NSLog(@"Login Successful");
                                    
                                    // TODO: Attempt login using the Parse database
                                    
                                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
                                    //[self dismissViewControllerAnimated:YES completion:nil];
                                } else {
                                    // Authenticate failed
                                    NSLog(@"Login Failed");
                                    
                                }
                            }];
    } else {
        // Could not evaluate policy; check authError
    }
}

- (IBAction)privacyPolicyButtonPressed:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"userAgreedToPrivacyPolicy"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *privacyPolicyView = [storyboard instantiateViewControllerWithIdentifier:@"PrivacyPolicyViewController"];
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"userAgreedToPrivacyPolicy"]) {
        NSLog(@"User has not agreed to privacy policy");
        
        [self presentViewController:privacyPolicyView animated:YES completion:nil];
    } else {
        // user agreed to privacy policy
        NSLog(@"User agreed to privacy policy");
    }
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==self.usernameTextField){
        [self.passwordTextField becomeFirstResponder];
    }else if (textField == self.passwordTextField)
    {
        [textField resignFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
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

-(void)dismissKeyboard {
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

// FUIALERT VIEW DELEGATES
-(void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        NSLog(@"Login Alert View Button Clicked");
        
        // FOR TESTING PURPOSES
        //[self dismissViewControllerAnimated:YES completion:nil];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *homeNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
        
        [self presentViewController:homeNavigationController animated:YES completion:nil];
    }
    else{
        
    }
}

- (void)alertView:(FUIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
}

- (void)alertView:(FUIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
}


- (IBAction)signInButtonPressed:(id)sender {
    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            NSLog(@"User successfully logged in!");
                                            
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                            
//                                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                                            UIViewController *homeNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
//                                            
//                                            [self presentViewController:homeNavigationController animated:YES completion:nil];
                                            
                                            
                                        } else {
                                            // The login failed. Check error to see why.
                                            NSString *errorString = [error userInfo][@"error"];
                                            // Show the errorString somewhere and let the user try again.
                                            FUIAlertView * loginAlert =[[FUIAlertView alloc ] initWithTitle:@"An Error Occured"
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

- (IBAction)signUpButtonPressed:(id)sender {
    

}
@end
