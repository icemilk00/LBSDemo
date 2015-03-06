//
//  ViewController.h
//  LBSDemo
//
//  Created by hp on 15-3-5.
//  Copyright (c) 2015年 51mvbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LBSSearchController.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate, LBSSearchDelegate>

@property (strong, nonatomic) IBOutlet UIButton *locationButton;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *checkinLocation;

@property (strong, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *latitudeLabel;
@end

