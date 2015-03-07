//
//  MakeLocationViewController.m
//  LBSDemo
//
//  Created by hp on 15/3/7.
//  Copyright (c) 2015年 51mvbox. All rights reserved.
//

#import "MakeLocationViewController.h"
#import "MakeLocationTableViewCell.h"

@interface MakeLocationViewController ()
{
    NSArray *_categoryArray;
    NSArray *_placeHolderArray;
}
@end

@implementation MakeLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self dataInit];
    
    self.makeLocationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height) style:UITableViewStyleGrouped];
    _makeLocationTableView.delegate = self;
    _makeLocationTableView.dataSource = self;
    [self.view addSubview:_makeLocationTableView];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]
                                 initWithTitle:@"完成"
                                 style:UIBarButtonItemStylePlain
                                 target:self
                                 action:@selector(makeFinishAction)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

-(void)makeFinishAction
{
    if (self.makeLocationDelegate && [self.makeLocationDelegate respondsToSelector:@selector(makeLocationFinished:)]) {
        
        [self.makeLocationDelegate makeLocationFinished:((MakeLocationTableViewCell *)[_makeLocationTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).contentField.text];
    }
}

-(void)dataInit
{
    _categoryArray = [[NSArray alloc] initWithObjects:@"位置名称", @"选择地区", @"详细地址", @"所属分类", @"联系电话", nil];
    _placeHolderArray = [[NSArray alloc] initWithObjects:@"位置名称", @"选择地区", @"街道门牌地址", @"选填", @"商家联系电话，选填", nil];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_categoryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MakeLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MakeLocationCell"];
    
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MakeLocationTableViewCell" owner:self options:nil] lastObject];
    }
    
    cell.categoryLabel.text = [_categoryArray objectAtIndex:indexPath.row];
    cell.contentField.placeholder = [_placeHolderArray objectAtIndex:indexPath.row];
    switch (indexPath.row) {
        case 0:
            cell.contentField.text = _locationName;
            break;
            
        default:
            break;
    }
    
    return cell;
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

@end
