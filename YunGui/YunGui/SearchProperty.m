//
//  SearchProperty.m
//  YunGui
//
//  Created by Hanen 3G 01 on 15/11/17.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "SearchProperty.h"
#import "UIView+Extension.h"
#import "ShowPropertyCell.h"
#import "CreatePropertyViewController.h"

@interface SearchProperty ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView      *_tableView;
    
    //数据源数组
    NSMutableArray   *_dataArray;
}
@end

@implementation SearchProperty
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    //******************假数据
    _dataArray = [NSMutableArray arrayWithObjects:@{@"name":@"朗诗",@"region":@"江苏"}, nil];
    NSLog(@"假数据");
    //******************
  
    [self loadData];
    
    
   
}
//下载数据
- (void)loadData
{
    //若请求的数据 搜索为空则跳去创建物业页面
    if (_dataArray.count == 0) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"无当前搜索物业，是否创建新物业" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CreatePropertyViewController *creatProperty = [[CreatePropertyViewController alloc] init];
            [self.navigationController pushViewController:creatProperty animated:YES];
        }];
        [alertControl addAction:action];
        [self presentViewController:alertControl animated:YES completion:nil];
    }else{
        //
         [self creatTableView];
    }
   
}
//创建tableView
- (void)creatTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    [self.view addSubview:_tableView];
}

#pragma mark --UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShowPropertyCell *cell = [ShowPropertyCell cellWithTabelView:tableView];
    cell.arr = _dataArray[0];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(bringBackChioceProperty:)]) {
        [self.delegate bringBackChioceProperty:@"上海花园"];//_dataArray[indexpath.row]
    }
    [self.navigationController popViewControllerAnimated:YES];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}
@end
