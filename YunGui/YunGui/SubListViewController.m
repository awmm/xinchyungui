//
//  SubListViewController.m
//  YunGui
//
//  Created by wmm on 15/11/16.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "SubListViewController.h"
#import "Macro.h"

@interface SubListViewController ()

@end

@implementation SubListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *subTableView=[[UITableView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    subTableView.delegate=self;
    subTableView.dataSource=self;
    [self.view addSubview:subTableView];
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

#pragma mark - 数据源方法
#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath是一个对象，记录了组和行信息

    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text=@"朗诗小区";
//    cell.detailTextLabel.text=contact.phoneNumber;
    return cell;
}

#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.delegate passValue:cell.textLabel.text];
    NSLog(@"%@",cell.textLabel.text);
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    
}

@end
