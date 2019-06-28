//
//  FSProvinceViewController.m
//  FSIPM
//
//  Created by nickwong on 16/5/23.
//  Copyright © 2016年 nickwong. All rights reserved.
//

#import "FSProvinceViewController.h"
#import "FSRegionTableViewCell.h"

@interface FSProvinceViewController ()<UITableViewDataSource,UITableViewDelegate,recevFinish>
{
    FS_Request *_request;
    UITableView *_provinceTableView;         //省份列表
}

@property(nonatomic ,strong)NSMutableArray *provinceArr;
@property(nonatomic,strong)NSString *selectedProvince;  // 选中省份
@property(nonatomic,strong)NSString *selectedProvinceId;  // 选中地级市

@end

@implementation FSProvinceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools getColor:@"F7F7F7" isSingleColor:YES];
    _provinceArr = [[NSMutableArray array]init];
    
    //添加省份列表
    [self addProvinceTableView];
    
    [ProgressHUD show:@"正在加载"];
    
    [[self getRequest] sendRequestWithUrl:getChildRegionList
                                   parameters:[FSRequestDictionary
                                               get_ChildRegionList:1
                                               supRegionName:@"中国"]
                                  NetWorkType:getChildRegionListTag];
    
}

//添加省份列表
- (void)addProvinceTableView
{

    if (@available(iOS 11, *)){
        _provinceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0 , kTopHeight, FSScreenWidth, FSScreenHeight - kTopHeight) style:UITableViewStylePlain];
    }else{
        _provinceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, FSScreenWidth, FSScreenHeight) style:UITableViewStylePlain];
    }
    _provinceTableView.rowHeight = 60;
    _provinceTableView.delegate = self;
    _provinceTableView.dataSource = self;
    [self.view addSubview:_provinceTableView];
    _provinceTableView.tableFooterView = [[UIView alloc]init];
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
    [_provinceArr addObjectsFromArray:[json getArrayFromJason:receiveData withConnectType:getChildRegionListTag]];
    [_provinceTableView reloadData];
}

#pragma mark -- 遵守UITableViewDelegate协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _provinceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *flag = @"cell";
    FSRegionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:flag];
    if (!cell) {
        cell = [[FSRegionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
    }
    if (_provinceArr.count) {
        cell.model = _provinceArr[indexPath.row];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FSRegionModel *model = _provinceArr[indexPath.row];
    _selectedProvince = model.regionName;
    _selectedProvinceId = model.regionId;
    
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
    [FSNotificationCenter postNotificationName:ProvinceDidChangeNotification object:nil userInfo:@{@"province":_selectedProvince,
        @"provinceId":_selectedProvinceId}];
    
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
