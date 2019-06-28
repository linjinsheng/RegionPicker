//
//  FSCityViewController.m
//  FSIPM
//
//  Created by nickwong on 16/5/23.
//  Copyright © 2016年 nickwong. All rights reserved.
//

#import "FSCityViewController.h"
#import "FSRegionTableViewCell.h"

@interface FSCityViewController ()<UITableViewDataSource,UITableViewDelegate,recevFinish>
{
    FS_Request *_request;
    UITableView *_cityTableView;         //省份列表
}

@property(nonatomic ,strong)NSMutableArray *cityArr;
@property(nonatomic,strong)NSString *selectedCity;    // 选中地级市
@property(nonatomic,strong)NSString *selectedCityId;  // 选中地级市

@end

@implementation FSCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools getColor:@"F7F7F7" isSingleColor:YES];
    
    _cityArr = [[NSMutableArray array]init];
    
    //添加地级市列表
    [self addCityTableView];
    
    [ProgressHUD show:@"正在加载"];
    
    //发送申请
    [[self getRequest] sendRequestWithUrl:getChildRegionList
                               parameters:[FSRequestDictionary
                                           get_ChildRegionList:[_selectedProvinceId intValue]
                                           supRegionName:_selectedProvince]
                              NetWorkType:getChildRegionListTag];
}

//添加省份列表
- (void)addCityTableView
{

    if (@available(iOS 11, *)){
        _cityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0 , kTopHeight, FSScreenWidth, FSScreenHeight - kTopHeight) style:UITableViewStylePlain];
    }else{
        _cityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, FSScreenWidth, FSScreenHeight) style:UITableViewStylePlain];
    }
    _cityTableView.rowHeight = 60;
    _cityTableView.delegate = self;
    _cityTableView.dataSource = self;
    [self.view addSubview:_cityTableView];
    _cityTableView.tableFooterView = [[UIView alloc]init];
}

- (void)requestDidSuccess:(NSData *)receiveData andNetWorkType:(NSInteger)netType
{
    [ProgressHUD dismiss];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if(receiveData.length == 0)
    {
        return;
    }
    FS_Jason *json = [[FS_Jason alloc]init];
    [_cityArr addObjectsFromArray:[json getArrayFromJason:receiveData withConnectType:getChildRegionListTag]];
    [_cityTableView reloadData];
}

#pragma mark -- 遵守UITableViewDelegate协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cityArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *flag = @"cell";
    FSRegionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:flag];
    if (!cell) {
        cell = [[FSRegionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
    }
    if (_cityArr.count) {
        cell.model = _cityArr[indexPath.row];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FSRegionModel *model = _cityArr[indexPath.row];
    _selectedCity = model.regionName;
    _selectedCityId = model.regionId;
    
    //返回搜索主页
    for (UIViewController *FSSearchSettingVC in self.navigationController.viewControllers)
    {
        if ([FSSearchSettingVC isKindOfClass:[FSSearchSettingViewController class]]) {
            [self.navigationController popToViewController:FSSearchSettingVC animated:YES];
        }
        
        if ([FSSearchSettingVC isKindOfClass:[FSDistrictViewController class]]) {
            [self.navigationController popToViewController:FSSearchSettingVC animated:YES];
        }
    }
    
    //发送通知
    [FSNotificationCenter postNotificationName:CityDidChangeNotification object:nil userInfo:@{@"city":_selectedCity,
                   @"cityId":_selectedCityId}];
}


#pragma mark --网络请求
- (FS_Request *)getRequest
{
    if (_request == nil) {
        _request = [[FS_Request alloc]init];
        _request.delegate = self;
    }
    return _request;
}

@end
