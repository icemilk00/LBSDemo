//
//  LBSSearchController.m
//  LBSDemo
//
//  Created by hp on 15-3-6.
//  Copyright (c) 2015年 51mvbox. All rights reserved.
//

#import "LBSSearchController.h"
#import "JSONKit.h"
#import "LBSSearchTableViewCell.h"
#import "SearchLastTableViewCell.h"

#import <CommonCrypto/CommonDigest.h>

#define APPKEY @"39942929"
#define APPSECRET  @"64d8ee3dc8344c2c86008d2028694e88"

#define GET_LBS_URL_BASE_STRING @"http://api.dianping.com/v1/business/find_businesses?"

#define GET_LBS_URL_STRING @"http://api.dianping.com/v1/business/find_businesses?appkey=39942929&sign=1C6F5A7145D686B5504F76AAE3B584D5316ADE3F&latitude=%f&longitude=%f&sort=1&limit=20&offset_type=1&out_offset_type=1&platform=2"

#define GET_LBS_BY_KEYWORD_URL_STRING @"http://api.dianping.com/v1/business/find_businesses?appkey=39942929&sign=BC04E62C8B10D81F9B06ABEF8CDBED03AFAEFB1D&keyword=西贝&latitude=%f&longitude=%f&sort=1&limit=20&offset_type=1&out_offset_type=1&platform=2"

@interface LBSSearchController ()

@end

@implementation LBSSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _isSearch = NO;
    [self dataInit];
    [self getLBSNearLocation];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = YES;   //设置焦点在searchBar上时，tableview是否有灰层覆盖，这里设置有
    // Make sure the that the search bar is visible within the navigation bar.
    [self.searchController.searchBar sizeToFit];
    
    // Include the search controller's search bar within the table's header view.
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.delegate = self;
    
    self.definesPresentationContext = YES;
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]
                                 initWithTitle:@"离开"
                                 style:UIBarButtonItemStylePlain
                                 target:self
                                 action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
}

-(void)backAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)dataInit
{
    self.datasourceArray = [[NSMutableArray alloc] initWithObjects:@"不提示位置", nil];
    self.searchDataArray = [[NSMutableArray alloc] initWithObjects:@"不提示位置", nil];
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}

-(void)keywordRequestFinished:(ASIHTTPRequest *)request
{

    [_searchDataArray removeObjectsInRange:NSMakeRange(1, _searchDataArray.count - 1)];
    NSLog(@"_searchDataArray = %@", _searchDataArray);
    
    NSString *resultStr = [request responseString];
    NSDictionary *dic = [resultStr objectFromJSONString];
    NSLog(@"dic = %@", dic);
    
    if ([[dic objectForKey:@"status"] isEqualToString:@"OK"] && [[dic objectForKey:@"count"] integerValue] > 0) {
        
        [self makeDatasource:dic toArray:_datasourceArray];
    }
    
    [_searchDataArray addObject:@"找不到位置"];
    
    [_searchResultTableView reloadData];
    
    
}

-(void)keywordRequestFailed:(ASIHTTPRequest *)request
{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"searchBarSearchButtonClicked");
    _isSearch = YES;
    
    CGFloat searchBarEndPointY = self.searchController.searchBar.frame.origin.y + self.searchController.searchBar.frame.size.height;
    self.searchResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, searchBarEndPointY, self.view.frame.size.width, self.searchController.view.frame.size.height - searchBarEndPointY)];
    _searchResultTableView.delegate = self;
    _searchResultTableView.dataSource = self;
    [self.searchController.view addSubview:_searchResultTableView];
    
    NSString *baseUrlStr = @"http://api.dianping.com/v1/business/find_businesses?keyword=%@&latitude=%f&longitude=%f&sort=1&limit=20&offset_type=1&out_offset_type=1&platform=2";
    NSString* urlString = [[self class] serializeURL:[NSString stringWithFormat:baseUrlStr, self.searchController.searchBar.text, _currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude] params:nil];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    
//    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[[NSString stringWithFormat:GET_LBS_BY_KEYWORD_URL_STRING, 40.035698, 116.410196] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    request.delegate = self;
    [request setDidFinishSelector:@selector(keywordRequestFinished:)];
    [request setDidFailSelector:@selector(keywordRequestFailed:)];
    [request startAsynchronous];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _isSearch = NO;
    [_searchResultTableView removeFromSuperview];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _isSearch == YES ? [_searchDataArray count]:[_datasourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (indexPath.row <= 1) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"defautlCell"];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defautlCell"];
        }
        
        cell.textLabel.text =  _isSearch == YES ? [_searchDataArray objectAtIndex:indexPath.row]:[_datasourceArray objectAtIndex:indexPath.row];
    }
    else
    {
        if (_isSearch == YES && indexPath.row == [_searchDataArray count] - 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"LastCell"];
            
            if(cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchLastTableViewCell" owner:self options:nil] lastObject];
            }
            
            ((SearchLastTableViewCell *)cell).noteLabel.text = @"没有找到你的位置？";
            ((SearchLastTableViewCell *)cell).makeLabel.text = [NSString stringWithFormat:@"创建新的位置：%@", self.searchController.searchBar.text];
            
            return cell;

        }
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"LBSCell"];
        
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LBSSearchTableViewCell" owner:self options:nil] lastObject];
        }
        
        NSString *branch_name = [[_isSearch == YES ? _searchDataArray:_datasourceArray objectAtIndex:indexPath.row] objectForKey:@"branch_name"];
        if (![branch_name isEqualToString:@""]) {
           ((LBSSearchTableViewCell *)cell).nameLabel.text = [NSString stringWithFormat:@"%@(%@)",[[_isSearch == YES ? _searchDataArray:_datasourceArray objectAtIndex:indexPath.row] objectForKey:@"name"], branch_name] ;
        }
        else
        {
            ((LBSSearchTableViewCell *)cell).nameLabel.text = [[_isSearch == YES ? _searchDataArray:_datasourceArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        }
        
        ((LBSSearchTableViewCell *)cell).addressLabel.text = [[_isSearch == YES ? _searchDataArray:_datasourceArray objectAtIndex:indexPath.row] objectForKey:@"address"];
        
    }
    // Configure the cell...
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_isSearch) {
        
        if (indexPath.row == _searchDataArray.count - 1) {
            //跳转到新建位置页面
            MakeLocationViewController *makeLocationViewController = [[MakeLocationViewController alloc] init];
            makeLocationViewController.makeLocationDelegate = self;
            makeLocationViewController.locationName = self.searchController.searchBar.text;
            [self.navigationController pushViewController:makeLocationViewController animated:YES];
            return;
        }
        
    }
    
    NSString * selectLBSStr = nil;
    if(indexPath.row <= 1)
    {
        selectLBSStr = [_isSearch == YES ? self.searchResultTableView : self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        
    }
    else
    {
        selectLBSStr = [NSString stringWithFormat:@"%@ · %@", _currentCity, ((LBSSearchTableViewCell *)[_isSearch == YES ? self.searchResultTableView : self.tableView cellForRowAtIndexPath:indexPath]).nameLabel.text];
    }
    
    if (self.lbsDelegate && [self.lbsDelegate respondsToSelector:@selector(changeLocation:)]) {
        [self.lbsDelegate changeLocation:selectLBSStr];
    }
   
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)makeLocationFinished:(NSString *)locationStr
{
    
    if (self.lbsDelegate && [self.lbsDelegate respondsToSelector:@selector(changeLocation:)]) {
        [self.lbsDelegate changeLocation:[NSString stringWithFormat:@"%@ · %@", _currentCity, locationStr]];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


-(void)getLBSNearLocation
{
//    self.lbsRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:GET_LBS_URL_STRING, _currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude]]];
    NSString *baseUrlStr = @"http://api.dianping.com/v1/business/find_businesses?latitude=%f&longitude=%f&sort=1&limit=20&offset_type=1&out_offset_type=1&platform=2";
    NSString* urlString = [[self class] serializeURL:[NSString stringWithFormat:baseUrlStr, _currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude] params:nil];
    self.lbsRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    _lbsRequest.delegate = self;
    [_lbsRequest setDidFinishSelector:@selector(lbsRequestFinished:)];
    [_lbsRequest setDidFailSelector:@selector(lbsRequestFailed:)];
    [_lbsRequest startAsynchronous];
}

-(void)lbsRequestFinished:(ASIHTTPRequest *)request
{
    NSString *resultStr = [request responseString];
    NSDictionary *dic = [resultStr objectFromJSONString];
    
    NSLog(@"dic = %@", dic);
    
    if ([[dic objectForKey:@"status"] isEqualToString:@"OK"] && [[dic objectForKey:@"count"] integerValue] > 0) {
        
        [self makeDatasource:dic toArray:_datasourceArray];
        
    }
    [self.tableView reloadData];
    
    
}

-(void)makeDatasource:(NSDictionary *)dic toArray:(NSMutableArray *)toArray
{
    NSMutableArray *tempDataArray = [[NSMutableArray alloc] init];
    NSArray *businessArray = [dic objectForKey:@"businesses"];
    
    self.currentCity = [[businessArray objectAtIndex:0] objectForKey:@"city"];
    [toArray addObject:_currentCity];
    
    for (id result in businessArray) {
        
        //name 这里是因为目前为测试数据，所以返回的name字段后都带有"(这是一条测试商户数据，仅用于测试开发，开发完成后请申请正式数据...)",这里把这个括号内的去掉，正式数据的话这里需要修改。
        NSString *name = [[[result objectForKey:@"name"] componentsSeparatedByString:@"("] objectAtIndex:0];
        NSString *branch_name = [result objectForKey:@"branch_name"];
        NSString *address = [result objectForKey:@"address"];
        
        NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name",
                                 branch_name, @"branch_name",
                                 address, @"address",nil];
        [tempDataArray addObject:tempDic];
    }
    
    NSLog(@"tempDataArray = %@", tempDataArray);
    [toArray addObjectsFromArray:tempDataArray];

}

-(void)lbsRequestFailed:(ASIHTTPRequest *)request
{
    
}

#pragma mark -- 计算签名的方法 --
+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params
{
    NSURL* parsedURL = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:[self parseQueryString:[parsedURL query]]];
    if (params) {
        [paramsDic setValuesForKeysWithDictionary:params];
    }
    
    NSMutableString *signString = [NSMutableString stringWithString:APPKEY];
    NSMutableString *paramsString = [NSMutableString stringWithFormat:@"appkey=%@", APPKEY];
    NSArray *sortedKeys = [[paramsDic allKeys] sortedArrayUsingSelector: @selector(compare:)];
    for (NSString *key in sortedKeys) {
        [signString appendFormat:@"%@%@", key, [paramsDic objectForKey:key]];
        [paramsString appendFormat:@"&%@=%@", key, [paramsDic objectForKey:key]];
    }
    [signString appendString:APPSECRET];
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    NSData *stringBytes = [signString dataUsingEncoding: NSUTF8StringEncoding];
    if (CC_SHA1([stringBytes bytes], [stringBytes length], digest)) {
        /* SHA-1 hash has been calculated and stored in 'digest'. */
        NSMutableString *digestString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
        for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
            unsigned char aChar = digest[i];
            [digestString appendFormat:@"%02X", aChar];
        }
        [paramsString appendFormat:@"&sign=%@", [digestString uppercaseString]];
        return [NSString stringWithFormat:@"%@://%@%@?%@", [parsedURL scheme], [parsedURL host], [parsedURL path], [paramsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    } else {
        return nil;
    }
}

+ (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        if ([elements count] <= 1) {
            return nil;
        }
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
