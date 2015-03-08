//
//  ProfileViewController.m
//  iAttendance
//
//  Created by Christopher L. Price on 3/7/15.
//  Copyright (c) 2015 Christopher L. Price. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MEDynamicTransition.h"
#import "METransitions.h"

#import <Parse/Parse.h>

#import "ProfileUserDetailsTableViewCell.h"
#import "ProfileAboutYouTableViewCell.h"

@interface ProfileViewController ()
@property (nonatomic, strong) METransitions *transitions;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.profileTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.profileTableView.contentInset = UIEdgeInsetsMake(40.0f, 0.0f, 150.0f, 0.0f);

    
    self.transitions.dynamicTransition.slidingViewController = self.slidingViewController;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // There is not a camera on this device, so don't show the camera button.
        NSLog(@"There is not a camera on this device");
        self.changeProfileImageButton.hidden = YES;
    }
    [self updateViewForUserInformation];
    // Round Profile Image
    // Get the Layer of any view
    CALayer * l = [self.profileImageView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:self.profileImageView.frame.size.width / 2];

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

- (void) updateViewForUserInformation
{
    //    self.currentUserNameLabel.text = [PFUser currentUser].username;
    //self.userProfileImageView.image = [UIImage imageNamed:@"wood.jpg"];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.transitions.all.count;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id cell;
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                ProfileUserDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileUserDetailsCell"];
                if (!cell) {
                    cell = [[ProfileUserDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileUserDetailsCell"];
                    cell.userQuickDetailLabel.text = @"";
                }
                // configure cell
                return cell;
            }
            else if (indexPath.row == 1) {
                ProfileAboutYouTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileAboutYouCell"];
                if (!cell) {
                    cell = [[ProfileAboutYouTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileAboutYouCell"];
                }
                // configure cell
                return cell;
            }
            break;
        case 1:
            //            if (indexPath.row == 0) {
            //                ProfileAboutYouTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileAboutYouCell"];
            //                if (!cell) {
            //                    cell = [[ProfileAboutYouTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileAboutYouCell"];
            //                }
            //                // configure cell
            //                return cell;
            //            }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.profileTableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(indexPath.section == 0 && indexPath.row == 1) {
//        return 80.0;
//    }else if(indexPath.section == 0 && indexPath.row == 2) {
//        return 100.0;
//    }if(indexPath.section == 0 && indexPath.row == 3) {
//        return 350.0;
//    }
//    // "Else"
//    return 100;
//}


// FUIALERT VIEW DELEGATES
-(void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            NSLog(@"");
            
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


- (IBAction)eventsButtonPressed:(id)sender {
    
}

- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (IBAction)changeProfileImageButtonPressed:(id)sender {
    UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
    
    imagePickController=[[UIImagePickerController alloc]init];
    imagePickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickController.delegate=self;
    imagePickController.allowsEditing=TRUE;
    [self presentViewController:imagePickController animated:YES completion:nil];

}



#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.largeProfileImageView.image = selectedImage;
    self.profileImageView.image = selectedImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
