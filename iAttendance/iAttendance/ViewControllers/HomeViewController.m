//
//  HomeViewController.m
//  iAttendance
//
//  Created by Christopher L. Price on 3/7/15.
//  Copyright (c) 2015 Christopher L. Price. All rights reserved.
//

#import "HomeViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MEDynamicTransition.h"
#import "METransitions.h"
#import "CSMLocationUpdateController.h"

#import <Parse/Parse.h>

#define kHorizontalPadding 20
#define kVerticalPadding 10

@interface HomeViewController ()
@property (nonatomic, strong) METransitions *transitions;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;

@property (nonatomic, strong) UILabel            *instructionLabel;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self buildToggleControl];
    [self.segmentedControl addTarget:self action:@selector(handleToggle:) forControlEvents:UIControlEventValueChanged];
    
    self.transitions.dynamicTransition.slidingViewController = self.slidingViewController;
}

- (void)buildToggleControl
{
//    self.instructionLabel = [UILabel new];
//    self.instructionLabel.textAlignment = NSTextAlignmentCenter;
//    self.instructionLabel.preferredMaxLayoutWidth = self.view.frame.size.width - 2*kHorizontalPadding;
//    self.instructionLabel.numberOfLines = 0;
//    self.instructionLabel.text = @"Select the mode you would like to use for this device:";
//    self.instructionLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addSubview:self.instructionLabel];
    
//    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"iBeacon",@"Region Monitoring"]];
//    self.segmentedControl.momentary = YES;
//    self.segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.segmentedControl addTarget:self action:@selector(handleToggle:) forControlEvents:UIControlEventValueChanged];
    //[self.view addSubview:self.segmentedControl];
    
//    // define auto layout constraints
//    NSDictionary *constraintMetrics = @{@"horizontalPadding" : @kHorizontalPadding,
//                                        @"verticalPadding" : @(5*kVerticalPadding),
//                                        @"verticalSpacing" : @(2*kVerticalPadding)};
//    NSDictionary *constraintViews = @{@"label" : self.instructionLabel,
//                                      @"segmentedControl" : self.segmentedControl,
//                                      @"topGuide" : self.topLayoutGuide};
//    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-horizontalPadding-[label]-horizontalPadding-|"
//                                                                      options:0
//                                                                      metrics:constraintMetrics
//                                                                        views:constraintViews]];
//    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-horizontalPadding-[segmentedControl]-horizontalPadding-|"
//                                                                      options:0
//                                                                      metrics:constraintMetrics
//                                                                        views:constraintViews]];
//    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topGuide]-verticalPadding-[label]-verticalSpacing-[segmentedControl(==60)]-(>=verticalPadding)-|"
//                                                                      options:0
//                                                                      metrics:constraintMetrics
//                                                                        views:constraintViews]];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Makes the menu appear smoothly by adding the appropriate gesture recognizers
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
    self.slidingViewController.customAnchoredGestures = @[];
    [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
    [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (METransitions *)transitions {
    if (_transitions) return _transitions;
    
    _transitions = [[METransitions alloc] init];
    
    return _transitions;
}

- (UIPanGestureRecognizer *)dynamicTransitionPanGesture {
    if (_dynamicTransitionPanGesture) return _dynamicTransitionPanGesture;
    
    _dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.transitions.dynamicTransition action:@selector(handlePanGesture:)];
    
    return _dynamicTransitionPanGesture;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        
        FUIAlertView * frustratedAlert =[[FUIAlertView alloc ] initWithTitle:@"Frustrated?"
                                                                     message:@"Would you like our help?"
                                                                    delegate:self
                                                           cancelButtonTitle:@"No"
                                                           otherButtonTitles: @"Yes", nil];
        frustratedAlert.tag = 100;
        frustratedAlert.titleLabel.textColor = [UIColor cloudsColor];
        frustratedAlert.titleLabel.font = [UIFont boldFlatFontOfSize:16];
        frustratedAlert.messageLabel.textColor = [UIColor cloudsColor];
        frustratedAlert.messageLabel.font = [UIFont flatFontOfSize:14];
        frustratedAlert.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
        frustratedAlert.alertContainer.backgroundColor = [UIColor midnightBlueColor];
        frustratedAlert.defaultButtonColor = [UIColor cloudsColor];
        frustratedAlert.defaultButtonShadowColor = [UIColor asbestosColor];
        frustratedAlert.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
        frustratedAlert.defaultButtonTitleColor = [UIColor asbestosColor];
        
        [frustratedAlert show];
    }
}

// FUIALERT VIEW DELEGATES
-(void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            NSLog(@"Shake Alert View Button Clicked");
            
            [PFUser logOut];
            PFUser *currentUser = [PFUser currentUser]; // this will now be nil
            
            // FOR TESTING PURPOSES
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            
            [self presentViewController:loginViewController animated:YES completion:nil];
        }
        
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

- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    
}

- (void)handleToggle:(id)sender {
    
    CSMLocationUpdateController *monitoringController;
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        
        // initiate iBeacon broadcasting mode
        monitoringController = [[CSMLocationUpdateController alloc] initWithLocationMode:ApplicationModePeripheral];
        
    } else {
        
        // initate peripheral iBeacon monitoring mode
        monitoringController = [[CSMLocationUpdateController alloc] initWithLocationMode:ApplicationModeRegionMonitoring];
    }
    
    // present update controller
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:monitoringController];
    [self presentViewController:navController animated:YES completion:NULL];
}
@end
