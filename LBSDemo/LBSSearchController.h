//
//  LBSSearchController.h
//  LBSDemo
//
//  Created by hp on 15-3-6.
//  Copyright (c) 2015年 51mvbox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIHTTPRequest.h"

@protocol LBSSearchDelegate <NSObject>

-(void)changeLocation:(NSString *)locationStr;

@end

@interface LBSSearchController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate,UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, strong) ASIHTTPRequest *lbsRequest;

@property (nonatomic, strong) NSMutableArray *datasourceArray;
@property (nonatomic, strong) NSString *currentCity;

@property (nonatomic, assign) id <LBSSearchDelegate> lbsDelegate;
@end
