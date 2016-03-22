//
//  PropertyBaseViewController.m
//  YunGui
//
//  Created by HanenDev on 15/11/16.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "PropertyBaseViewController.h"
#import "Macro.h"
#import "PropertyTableViewCell.h"

@interface PropertyBaseViewController ()

@end

@implementation PropertyBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self createTableView];
    
}
-(void)createTableView
{
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-40-64) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    [tableView registerClass:[PropertyTableViewCell class] forCellReuseIdentifier:@"cellID"];
}
#pragma mark
#pragma mark-----协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row==8 ? 230:40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text=[NSString stringWithFormat:@"物业名称:%@",@"朗诗物业"];
            break;
        case 1:
            cell.textLabel.text=[NSString stringWithFormat:@"所属地区:%@",@"上海市"];
            break;
        case 2:
            cell.textLabel.text=[NSString stringWithFormat:@"街路:%@",@"南京路"];
            break;
        case 3:
            cell.textLabel.text=[NSString stringWithFormat:@"详细地址:%@",@"101号"];
            break;
        case 4:
            cell.textLabel.text=[NSString stringWithFormat:@"电话:%@",@"123456"];
            break;
        case 5:
            cell.textLabel.text=[NSString stringWithFormat:@"经度:%@",@"114.123"];
            break;
        case 6:
            cell.textLabel.text=[NSString stringWithFormat:@"纬度:%@",@"333"];
            break;
        case 7:
            cell.textLabel.text=[NSString stringWithFormat:@"标签:%@",@"公司企业"];
            break;
        case 8:
        {
            PropertyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellID"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.numLabel.text=[NSString stringWithFormat:@"编号:%@",@"11111111111"];
            cell.bankLabel.text=[NSString stringWithFormat:@"开户银行:%@",@"11111111111"];
            cell.bankIDLabel.text=[NSString stringWithFormat:@"银行账户:%@",@"112233445566778899"];
            cell.typeLabel.text=[NSString stringWithFormat:@"账户类型:%@",@"11111111111"];
            cell.addressLabel.text=[NSString stringWithFormat:@"开户银行详细地址:%@",@"南京市湖南路工商银行支行"];
            cell.addressLabel.numberOfLines=0;
            return cell;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}


@end
