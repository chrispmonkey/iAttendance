//
//  AdminViewController.m
//  iAttendance
//
//  Created by Christopher L. Price on 3/7/15.
//  Copyright (c) 2015 Christopher L. Price. All rights reserved.
//

#import "AdminViewController.h"

@interface AdminViewController ()

@end

@implementation AdminViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    // Initialize location manager and set ourselves as the delegate
    //self.locationManager = [[CLLocationManager alloc] init];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        // user allowed
        NSLog(@"User is authorized!");
        
        // Create a NSUUID object
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"A77A1B68-49A7-4DBF-914C-760D07FBB87B"];
        
        // Initialize the Beacon Region
        self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                      major:1
                                                                      minor:1
                                                                 identifier:@"com.appcoda.testregion"];
    }else {
        [self.locationManager requestWhenInUseAuthorization];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled"
//                                                        message:@"To re-enable, please go to Settings and turn on Location Service for this app."
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
    }
    
//    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
//    if (locationAllowed==NO)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled"
//                                                        message:@"To re-enable, please go to Settings and turn on Location Service for this app."
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//    }
    
    
    
    // Cancel Button
    self.stopButton.buttonColor = [UIColor alizarinColor];
    self.stopButton.shadowColor = [UIColor pomegranateColor];
    self.stopButton.shadowHeight = 3.0f;
    self.stopButton.cornerRadius = 6.0f;
    self.stopButton.titleLabel.font = [UIFont boldFlatFontOfSize:30];
    [self.stopButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.stopButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    // Agree Button
    self.broadcastButton.buttonColor = [UIColor emerlandColor];
    self.broadcastButton.shadowColor = [UIColor nephritisColor];
    self.broadcastButton.shadowHeight = 3.0f;
    self.broadcastButton.cornerRadius = 6.0f;
    self.broadcastButton.titleLabel.font = [UIFont boldFlatFontOfSize:30];
    [self.broadcastButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.broadcastButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];


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

- (IBAction)broadcastButtonPressed:(id)sender {
    // Get the beacon data to advertise
    self.myBeaconData = [self.myBeaconRegion peripheralDataWithMeasuredPower:nil];
    
    // Start the peripheral manager
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil
                                                                   options:nil];
}

- (IBAction)stopButtonPressed:(id)sender {
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager*)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn)
    {
        // Bluetooth is on
        
        // Update our status label
        self.statusLabel.text = @"Broadcasting...";
        
        // Start broadcasting
        [self.peripheralManager startAdvertising:self.myBeaconData];
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff)
    {
        // Update our status label
        self.statusLabel.text = @"Stopped";
        
        // Bluetooth isn't on. Stop broadcasting
        [self.peripheralManager stopAdvertising];
    }
    else if (peripheral.state == CBPeripheralManagerStateUnsupported)
    {
        self.statusLabel.text = @"Unsupported";
    }
}

@end
