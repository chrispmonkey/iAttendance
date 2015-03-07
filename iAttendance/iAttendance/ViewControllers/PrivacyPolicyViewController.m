//
//  PrivacyPolicyViewController.m
//  iAttendance
//
//  Created by Christopher L. Price on 3/7/15.
//  Copyright (c) 2015 Christopher L. Price. All rights reserved.
//

#import "PrivacyPolicyViewController.h"

@interface PrivacyPolicyViewController ()

@end

@implementation PrivacyPolicyViewController

NSDate *startingTime;
NSDate *minutesSinceStart;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // FLAT UIKIT BUTTON CUSTOMIZATIONS
    // Cancel Button
    self.cancelButton.buttonColor = [UIColor alizarinColor];
    self.cancelButton.shadowColor = [UIColor pomegranateColor];
    self.cancelButton.shadowHeight = 3.0f;
    self.cancelButton.cornerRadius = 6.0f;
    self.cancelButton.titleLabel.font = [UIFont boldFlatFontOfSize:30];
    [self.cancelButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    // Agree Button
    self.agreeButton.buttonColor = [UIColor emerlandColor];
    self.agreeButton.shadowColor = [UIColor nephritisColor];
    self.agreeButton.shadowHeight = 3.0f;
    self.agreeButton.cornerRadius = 6.0f;
    self.agreeButton.titleLabel.font = [UIFont boldFlatFontOfSize:30];
    [self.agreeButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.agreeButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(stopScrolling)];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(stopScrolling)];
    
    [self.view addGestureRecognizer:swipe];
    [self.view addGestureRecognizer:tap];
    
    [self startScrollTimer];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)startScrollTimer
{
    // calls the updateLabel method every 0.1 seconds
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(updateScroll) userInfo:nil repeats:YES];
    startingTime = [NSDate date]; //store in object
}

-(void)updateScroll
{
    NSTimeInterval minutesSinceStart = [ [NSDate date] timeIntervalSinceDate:startingTime]/60;
    //NSTimeInterval *minutesSinceStart timeIntervalSinceDate:startingTime];//(NSDate.date.timeIntervalSinceNow - startingTime) / 60.0;
    
    if (self.privacyPolicyTextView.contentOffset.y >= self.privacyPolicyTextView.contentSize.height - self.privacyPolicyTextView.frame.size.height)
    {
        NSLog(@"At the end of the privacy policy");
        [self.scrollTimer invalidate];
    }
    self.privacyPolicyTextView.contentOffset = CGPointMake(0, minutesSinceStart * self.privacyPolicyTextView.contentSize.height);
}

- (void)stopScrolling
{
    [self.scrollTimer invalidate];
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

- (IBAction)cancelButtonPressed:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"userAgreedToPrivacyPolicy"];
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    FUIAlertView * privacyPolicyAlert =[[FUIAlertView alloc ] initWithTitle:@"Sorry 😢"
                                                                    message:@"In order to use this app you must accept the Privacy Policy"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
    privacyPolicyAlert.tag = 100;
    privacyPolicyAlert.titleLabel.textColor = [UIColor cloudsColor];
    privacyPolicyAlert.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    privacyPolicyAlert.messageLabel.textColor = [UIColor cloudsColor];
    privacyPolicyAlert.messageLabel.font = [UIFont flatFontOfSize:14];
    privacyPolicyAlert.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    privacyPolicyAlert.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    privacyPolicyAlert.defaultButtonColor = [UIColor cloudsColor];
    privacyPolicyAlert.defaultButtonShadowColor = [UIColor asbestosColor];
    privacyPolicyAlert.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    privacyPolicyAlert.defaultButtonTitleColor = [UIColor asbestosColor];
    
    [privacyPolicyAlert show];
    
}

- (IBAction)agreeButtonPressed:(id)sender {
    
    // Mark Privacy Policy as viewed
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"userAgreedToPrivacyPolicy"];
    
    // Dismiss view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
