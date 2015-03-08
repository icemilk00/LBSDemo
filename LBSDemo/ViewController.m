//
//  ViewController.m
//  LBSDemo
//
//  Created by hp on 15-3-5.
//  Copyright (c) 2015年 51mvbox. All rights reserved.
//

#import "ViewController.h"

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
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >=__IPHONE_8_0
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
#endif

}


#pragma mark -- CLLocationManagerDelegate --
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    NSLog(@"didUpdateToLocation and newlocation = %f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    
    self.checkinLocation = newLocation;

    //116.410193  40.035770
    self.longitudeLabel.text = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    self.latitudeLabel.text = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    
    LBSSearchController *searchController = [[LBSSearchController alloc] init];
    searchController.lbsDelegate = self;
    searchController.currentLocation = newLocation;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchController];
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
    //如果用模拟器会走到这里，为了方便测试，这里经纬度写死以供程序继续跑下去
    LBSSearchController *searchController = [[LBSSearchController alloc] init];
    searchController.lbsDelegate = self;
    searchController.currentLocation = [[CLLocation alloc] initWithLatitude:40.035770 longitude:116.410193];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchController];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark -- LBSSearchDelegate --
-(void)changeLocation:(NSString *)locationStr
{
    [self.locationButton setTitle:locationStr forState:UIControlStateNormal];
}

#pragma mark -- 获取位置按钮 Action --
- (IBAction)setupLocationManager {
    
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog( @"Starting CLLocationManager" );
        [self.locationManager startUpdatingLocation];
        
    } else {
        NSLog( @"Cannot Starting CLLocationManager" );
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

