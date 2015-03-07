//
//  MenuViewController.m
//  iAttendance
//
//  Created by Christopher L. Price on 3/7/15.
//  Copyright (c) 2015 Christopher L. Price. All rights reserved.
//

#import "MenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+ECSlidingViewController.h"
#import <Parse/Parse.h>


@interface MenuViewController ()
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSArray *menuItemIcons;
@property (nonatomic, strong) UINavigationController *transitionsNavigationController;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // topViewController is the transitions navigation controller at this point.
    // It is initially set as a User Defined Runtime Attributes in storyboards.
    // We keep a reference to this instance so that we can go back to it without losing its state.
    self.transitionsNavigationController = (UINavigationController *)self.slidingViewController.topViewController;
    
    // Populate user information
    [self updateViewForUserInformation];
    
    
    // Round Profile Image
    // Get the Layer of any view
    CALayer * roundlayer = [self.userProfileImageView layer];
    [roundlayer setMasksToBounds:YES];
    [roundlayer setCornerRadius:self.userProfileImageView.frame.size.width / 2];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *defaultIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.menuTableView selectRowAtIndexPath:defaultIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    });

}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (NSArray *)menuItems {
    if (_menuItems) return _menuItems;
    
    _menuItems = @[@"Home", @"Profile", @"Settings"];
    
    return _menuItems;
}

- (NSArray *)menuItemIcons {
    if (_menuItemIcons) return _menuItemIcons;
    
    _menuItemIcons = @[@"sidebar-tellafriend.png", @"sidebar-unknown_measures.png", @"sidebar-settings.png"];
    
    return _menuItemIcons;
}

- (void) updateViewForUserInformation
{
    self.userProfileName.text = [PFUser currentUser].username;
    //self.userProfileImageView.image = [UIImage imageNamed:@"wood.jpg"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *menuItem = self.menuItems[indexPath.row];
    
    UILabel *menuItemText = (UILabel *)[cell.contentView viewWithTag:1];
    UIImageView *menuItemIcon = (UIImageView *)[cell.contentView viewWithTag:2];
    //UIImageView *menuItemIcon = (UIImageView *)[cell.contentView viewWithTag:2];//[UIImage imageNamed:@"menu_black.png"];
    
    [menuItemText setText:menuItem];
    menuItemIcon.image = [UIImage imageNamed:self.menuItemIcons[indexPath.row]];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    // Change the selected cell color to black with a transparency
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:0.5];
    cell.selectedBackgroundView = selectionColor;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *menuItem = self.menuItems[indexPath.row];
    
    // This undoes the Zoom Transition's scale because it affects the other transitions.
    // You normally wouldn't need to do anything like this, but we're changing transitions
    // dynamically so everything needs to start in a consistent state.
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    
    if ([menuItem isEqualToString:@"Home"]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
    }else if ([menuItem isEqualToString:@"Profile"]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileNavigationController"];
    }else if ([menuItem isEqualToString:@"Settings"]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsNavigationController"];
    }
    
    [self.slidingViewController resetTopViewAnimated:YES];
}

// FUIALERT VIEW DELEGATES
-(void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            NSLog(@"Shake Alert View Button Clicked");
            
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


@end
