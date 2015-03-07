//
//  AppDelegate.h
//  iAttendance
//
//  Created by Christopher L. Price on 3/7/15.
//  Copyright (c) 2015 Christopher L. Price. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

typedef NS_ENUM(NSUInteger, ApplicationMode) {
    ApplicationModePeripheral = 0,
    ApplicationModeRegionMonitoring
};

#define kUniqueRegionIdentifier @"iBeacon Demo"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSUUID *myUUID;

@property (nonatomic, assign) ApplicationMode applicationMode;

+ (AppDelegate*)appDelegate;

@end

