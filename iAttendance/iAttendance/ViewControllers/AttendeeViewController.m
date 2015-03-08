//
//  AttendeeViewController.m
//  iAttendance
//
//  Created by Christopher L. Price on 3/7/15.
//  Copyright (c) 2015 Christopher L. Price. All rights reserved.
//

#import "AttendeeViewController.h"
#import <Parse/Parse.h>

@import CoreLocation;

@interface AttendeeViewController () <CLLocationManagerDelegate>

@property BOOL enabled;
@property NSUUID *uuid;
@property NSNumber *major;
@property NSNumber *minor;
@property BOOL notifyOnEntry;
@property BOOL notifyOnExit;
@property BOOL notifyOnDisplay;

@end

@implementation AttendeeViewController
bool touchIDAlertVisible;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Initialize location manager and set ourselves as the delegate
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:[NSUUID UUID] identifier:@"A77A1B68-49A7-4DBF-914C-760D07FBB87B"];
    region = [self.locationManager.monitoredRegions member:region];
    if(region)
    {
        self.enabled = YES;
        self.uuid = region.proximityUUID;
        self.major = region.major;
        //self.majorTextField.text = [self.major stringValue];
        self.minor = region.minor;
        //self.minorTextField.text = [self.minor stringValue];
        self.notifyOnEntry = region.notifyOnEntry;
        self.notifyOnExit = region.notifyOnExit;
        self.notifyOnDisplay = region.notifyEntryStateOnDisplay;
    }
    else
    {
        // Default settings.
        self.enabled = NO;
        
        self.uuid = [[NSUUID alloc]initWithUUIDString:@"A77A1B68-49A7-4DBF-914C-760D07FBB87B"];
        self.major = self.minor = nil;
        self.notifyOnEntry = self.notifyOnExit = YES;
        self.notifyOnDisplay = NO;
    }
    
   
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {//kCLAuthorizationStatusAuthorizedWhenInUse
        // user allowed
        NSLog(@"User is authorized!");
        
        
        // Create a NSUUID with the same UUID as the broadcasting beacon
        //NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"A77A1B68-49A7-4DBF-914C-760D07FBB87B"];
        
        // Setup a new region with that UUID and same identifier as the broadcasting beacon
        self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid
                                                                      major:1 minor:1
                                                                 identifier:@"com.appcoda.testregion"];
        
        // Tell location manager to start monitoring for the beacon region
        [self.locationManager startMonitoringForRegion:self.myBeaconRegion];
         
        NSLog(@"monitored regions: %@", self.locationManager.monitoredRegions);
        
        // Check if beacon monitoring is available for this device
        if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Monitoring not available" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]; [alert show]; return;
        }
    }else {
        [self.locationManager requestWhenInUseAuthorization];

    }
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    if (locationAllowed==NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled"
                                                        message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];


}

-(void)viewWillAppear:(BOOL)animated{
    touchIDAlertVisible = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    NSLog(@"Failed for region");
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"Did change Authorization Status to %d", status);
    
    
    // Create a NSUUID with the same UUID as the broadcasting beacon
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"A77A1B68-49A7-4DBF-914C-760D07FBB87B"];
    
    // Setup a new region with that UUID and same identifier as the broadcasting beacon
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                  major:1 minor:1
                                                             identifier:@"com.appcoda.testregion"];
    
    // Tell location manager to start monitoring for the beacon region
    [self.locationManager startMonitoringForRegion:self.myBeaconRegion];
    
    NSLog(@"monitored regions: %@", self.locationManager.monitoredRegions);
    
    // Check if beacon monitoring is available for this device
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Monitoring not available" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]; [alert show]; return;
    }
    
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"ERROR!!! %@", error);
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion *)region
{
    // We entered a region, now start looking for our target beacons!
    self.statusLabel.text = @"Finding beacons.";
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion *)region
{
    // Exited the region
    self.statusLabel.text = @"None found.";
    [self.locationManager stopRangingBeaconsInRegion:self.myBeaconRegion];
}

-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    // Beacon found!
    NSLog(@"Location Manager Did Range Beacons in Region Called!");
    
    
    CLBeacon *foundBeacon = [beacons firstObject];
    
    NSLog(@"UUID of Found Beacon %@", foundBeacon.proximityUUID.UUIDString);
    NSLog(@"UUID of My Beacon %@", self.uuid.UUIDString);

    
    if ([foundBeacon.proximityUUID.UUIDString isEqualToString:self.uuid.UUIDString]) {
        [manager stopMonitoringVisits];
        [manager stopMonitoringForRegion:self.myBeaconRegion];
        self.statusLabel.text = [NSString stringWithFormat:@"Beacon found! %@", foundBeacon.proximityUUID];
        NSLog(@"Beacon found! %@", foundBeacon.proximityUUID);

        if(touchIDAlertVisible == false){
            touchIDAlertVisible = true;
            [self checkInUsingTouchID];
        }
    }
    //NSLog(@"Beacon found! %@", foundBeacon.proximityUUID);
    // You can retrieve the beacon data from its properties
    //NSString *uuid = foundBeacon.proximityUUID.UUIDString;
    //NSString *major = [NSString stringWithFormat:@"%@", foundBeacon.major];
    //NSString *minor = [NSString stringWithFormat:@"%@", foundBeacon.minor];
}

// Login using TouchID
- (void)checkInUsingTouchID
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
                                    // Ask user for the object ID (AKA Event Code)
                                    PFQuery *eventRowQuery = [PFQuery queryWithClassName:@"Event"];
                                    [eventRowQuery whereKey:@"uuid" equalTo:self.uuid.UUIDString];
                                    NSMutableArray* events = [eventRowQuery findObjects];
                                    
                                    NSString *objectId = ((PFObject*)events[0]).objectId;
                                    
                                    
                                    
                                    // Create a pointer to an object of class Point with id dlkj83d
                                    PFObject *eventCheckin = [PFObject objectWithoutDataWithClassName:@"Event" objectId:objectId];
                                    
                                    // Increment the current value of the attendance key by 1
                                    [eventCheckin incrementKey:@"attendance"];
                                    [eventCheckin addObject:[[PFUser currentUser] username] forKey:@"attendees"];
                                    // Save
                                    [eventCheckin save];
                                    
                                    [self dismissViewControllerAnimated:YES completion:nil];
                                    //[self dismissViewControllerAnimated:YES completion:nil];
                                } else {
                                    // Authenticate failed
                                    [self.locationManager startMonitoringForRegion:self.myBeaconRegion];
                                    NSLog(@"Login Failed");
                                    
                                }
                            }];
    } else {
        // Could not evaluate policy; check authError
    }
}

- (void)alertView:(FUIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
}

- (void)alertView:(FUIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
