//
//  CustomIASKControllerViewController.h
//  iAttendance
//
//  Created by Dan on 3/7/15.
//  Copyright (c) 2015 Christopher L. Price. All rights reserved.
//

#import "IASKAppSettingsViewController.h"
#import <UIKit/UIKit.h>
@interface CustomIASKControllerViewController : IASKAppSettingsViewController <IASKSettingsDelegate>{
    
}

@property (strong, nonatomic) IBOutlet UITableView *settingsTableView;
@end
