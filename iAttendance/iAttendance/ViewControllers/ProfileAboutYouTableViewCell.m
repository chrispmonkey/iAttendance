//
//  ProfileAboutYouTableViewCell.m
//  Spotter
//
//  Created by Christopher L. Price on 3/2/15.
//  Copyright (c) 2015 Christopher L. Price. All rights reserved.
//

#import "ProfileAboutYouTableViewCell.h"
#import <Parse/Parse.h>

@implementation ProfileAboutYouTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self updateViewForUserInformation];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) updateViewForUserInformation
{
    
    //PFObject *object = [PFObject ob]@"firstName";
    
    PFQuery *query = [PFUser query];
    
    [query whereKey:@"username" equalTo:[PFUser currentUser].username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu objects.", (unsigned long)objects.count);
            // Do something with the found objects
            
            for (PFObject *object in objects) {
                //[object objectForKey:@"firstName"];
                
                self.joinedDateLabel.text = [NSString stringWithFormat:@"%@", [object objectForKey:@"type"]];
                NSLog(@"%@", object.objectId);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
    //self.userQuickDetailLabel.text = [NSString stringWithFormat:@"%@ %@, %@",[PFUser currentUser].[@"firstName"], [PFUser currentUser].[@"firstName"], [PFUser currentUser].[@"firstName"];
    //self.userProfileImageView.image = [UIImage imageNamed:@"wood.jpg"];
}

@end
