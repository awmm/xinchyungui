//
//  PropertyDetailViewController.m
//  YunGui
//
//  Created by HanenDev on 15/11/13.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "PropertyDetailViewController.h"
#import "Macro.h"
#import "PropertyBankViewController.h"
#import "PropertyBaseViewController.h"
#import "EditPropertyViewController.h"

@interface PropertyDetailViewController ()

@end

@implementation PropertyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [ViewTool setNavigationBar:self.navigationController.navigationBar];
    self.title=@"物业详情";
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editBtnClick:)];
    
    [self createBottomBtn];
}
-(void)createBottomBtn
{
    UISegmentedControl *segment=[[UISegmentedControl alloc]initWithItems:@[@"基本信息",@"银行账户"]];
    segment.frame=CGRectMake(0, kScreenHeight-40, kScreenWidth, 40);
    segment.selectedSegmentIndex=0;
    segment.tintColor=[UIColor lightGrayColor];
    [segment addTarget:self action:@selector(segmentChangedClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    
    //跳转过来展示基本信息界面
    PropertyBaseViewController *baseVC=[[PropertyBaseViewController alloc]init];
    baseVC.view.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-40);
    [self addChildViewController:baseVC];
    [self.view addSubview:baseVC.view];

}
-(void)segmentChangedClick:(UISegmentedControl *)control
{
    if (control.selectedSegmentIndex==0)
    {
        //添加基本信息界面
        PropertyBaseViewController *baseVC=[[PropertyBaseViewController alloc]init];
        baseVC.view.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-40);
        [self addChildViewController:baseVC];
        [self.view addSubview:baseVC.view];
    }
    if (control.selectedSegmentIndex==1)
    {
        //添加银行账户界面
        PropertyBankViewController *bankVC=[[PropertyBankViewController alloc]init];
        bankVC.view.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-40);
        [self addChildViewController:bankVC];
        [self.view addSubview:bankVC.view];
    }
}

//编辑界面
-(void)editBtnClick:(UIButton *)btn
{
    EditPropertyViewController * vc=[[EditPropertyViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
