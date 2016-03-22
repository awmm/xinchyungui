//
//  PropertyBankViewController.m
//  YunGui
//
//  Created by HanenDev on 15/11/16.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "PropertyBankViewController.h"
#import "Macro.h"
#import "PropertyBankCell.h"

@interface PropertyBankViewController ()

@end

@implementation PropertyBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self createTableView];
}
-(void)createTableView
{
    UITableView * tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-40-64) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    [tableView registerClass:[PropertyBankCell class] forCellReuseIdentifier:@"bankCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row %2 ==0)
    {
        return 40;
    }
    return 35*5+20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2 == 0)
    {
        static NSString * identifier=@"cell";
        UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text=@"MON 07/11";
        cell.detailTextLabel.text=@"09:30";
        return cell;
    }
    
    PropertyBankCell *cell=[tableView dequeueReusableCellWithIdentifier:@"bankCell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithRed:(20.0f/255.0f) green:(30.0f/255.0f) blue:(40.0f/255.0f) alpha:0.1f];
    
    cell.numLabel.text=@"编号:";
    cell.bankLabel.text=@"开户银行:";
    cell.bankIDLabel.text=@"银行账户:";
    cell.typeLabel.text=@"账户类型:";
    cell.addressLabel.text=@"开户银行详细地址:";
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
