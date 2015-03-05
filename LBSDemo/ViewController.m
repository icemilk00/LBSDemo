//
//  ViewController.m
//  LBSDemo
//
//  Created by hp on 15-3-5.
//  Copyright (c) 2015年 51mvbox. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 200;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    self.checkinLocation = newLocation;
    //do something else
    NSLog(@"didUpdateToLocation %f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    self.longitudeLabel.text = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    self.latitudeLabel.text = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
}


- (IBAction) setupLocationManager {
    
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog( @"Starting CLLocationManager" );
        [self.locationManager startUpdatingLocation];
        
    } else {
        NSLog( @"Cannot Starting CLLocationManager" );
        /*self.locationManager.delegate = self;
         self.locationManager.distanceFilter = 200;
         locationManager.desiredAccuracy = kCLLocationAccuracyBest;
         [self.locationManager startUpdatingLocation];*/
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
