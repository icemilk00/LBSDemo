//
//  ViewController.h
//  LBSDemo
//
//  Created by hp on 15-3-5.
//  Copyright (c) 2015年 51mvbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *checkinLocation;

@end

