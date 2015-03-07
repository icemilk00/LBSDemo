//
//  MakeLocationViewController.h
//  LBSDemo
//
//  Created by hp on 15/3/7.
//  Copyright (c) 2015年 51mvbox. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MakeLocationDelegate <NSObject>

-(void)makeLocationFinished:(NSString *)locationStr;

@end

@interface MakeLocationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *makeLocationTableView;
@property (nonatomic, strong) NSString *locationName;

@property (nonatomic, assign) id <MakeLocationDelegate> makeLocationDelegate;
@end
