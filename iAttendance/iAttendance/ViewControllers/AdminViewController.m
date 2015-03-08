//
//  AdminViewController.m
//  iAttendance
//
//  Created by Christopher L. Price on 3/7/15.
//  Copyright (c) 2015 Christopher L. Price. All rights reserved.
//

#import "AdminViewController.h"
#import <Parse/Parse.h>

@interface AdminViewController ()
@property NSUUID *uuid;
@end

NSDate *startingTime;
NSDate *minutesSinceStart;

@implementation AdminViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    // Initialize location manager and set ourselves as the delegate
    //self.locationManager = [[CLLocationManager alloc] init];
    if (![CLLocationManager isRangingAvailable]) {
        NSLog(@"Range is not available");
    }
    
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        // user allowed
        NSLog(@"User is authorized!");
        
        // Create a NSUUID object
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"A77A1B68-49A7-4DBF-914C-760D07FBB87B"];
        
        self.uuid = uuid;
        
        // Initialize the Beacon Region
        self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                      major:1
                                                                      minor:1
                                                                 identifier:@"com.appcoda.testregion"];
        
        if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
            NSLog(@"Beacon Range is not available");
        }
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
    [self startEvent];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startEvent
{
    // Check to make sure the event is up
    
    // If the class exists and exists
    
    PFQuery *eventRowQuery = [PFQuery queryWithClassName:@"Event"];
    [eventRowQuery whereKey:@"uuid" equalTo:self.uuid.UUIDString];
    
    [eventRowQuery findObjectsInBackgroundWithBlock:^(NSArray *events, NSError *error) {
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"dd-MM-yyyy";
        
        NSString *todaysDateString = [format stringFromDate:[NSDate new]];
        NSString *eventDateString;
        
        for(PFObject* event in events){
            eventDateString = [format stringFromDate:event.createdAt];
            
            if( [todaysDateString isEqualToString:eventDateString]){
                [self startAttendanceTimer:event.objectId];
            }
            
        }
    }];

    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) updateViewForUserInformation:(NSTimer *) theTimer{
    NSString *objID = [[theTimer userInfo] objectForKey:@"objID"];
    PFQuery *eventQuery = [PFQuery queryWithClassName:@"Event"];
    [eventQuery whereKey:@"objectId" equalTo:objID ];
    
    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu events.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                self.attendanceCountLabel.text = [NSString stringWithFormat:@"%@", [object valueForKey:@"attendance"]];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    //self.userProfileImageView.image = [UIImage imageNamed:@"wood.jpg"];
}

- (void)startAttendanceTimer:(NSString *)objectID{
    // calls the updateLabel method every 0.1 seconds
//    self.attendanceRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:10.00 target:self selector:@selector(updateViewForUserInformation:) withObject:objectID repeats:YES];
//    SEL foo = @selector(updateViewForUserInformation:);
//    self.attendanceRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:foo userInfo:objectID repeats:YES];
    

    NSDictionary *bullshit;
    bullshit = [NSDictionary dictionaryWithObjectsAndKeys:objectID,@"objID",nil];
    
    [NSTimer scheduledTimerWithTimeInterval:10.0
                                     target:self
                                   selector:@selector(updateViewForUserInformation:)
                                   userInfo:bullshit
                                    repeats:YES];
    startingTime = [NSDate date]; //store in object
}

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
    [self.attendanceRefreshTimer invalidate];
    [self.peripheralManager stopAdvertising];
    //self.peripheralManager.state = CBPeripheralManagerStatePoweredOff;
    self.statusLabel.text = @"Stopped";
   // [self peripheralManagerDidUpdateState:self.peripheralManager];
    
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
