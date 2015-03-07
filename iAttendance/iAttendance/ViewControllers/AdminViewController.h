//
//  AdminViewController.h
//  iAttendance
//
//  Created by Christopher L. Price on 3/7/15.
//  Copyright (c) 2015 Christopher L. Price. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "FlatUIKit.h"

@interface AdminViewController : UIViewController<CBPeripheralManagerDelegate>
@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
@property (strong, nonatomic) NSDictionary *myBeaconData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet FUIButton *broadcastButton;

@property (weak, nonatomic) IBOutlet FUIButton *stopButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)broadcastButtonPressed:(id)sender;
- (IBAction)stopButtonPressed:(id)sender;

@end
