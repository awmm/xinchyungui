//
//  PropertyViewController.m
//  YunGui
//
//  Created by wmm on 15/11/10.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "PropertyViewController.h"
#import "CreatePropertyViewController.h"
#import "PropertyDetailViewController.h"
#import "SideMenuUtil.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width


@implementation PropertyViewController

@synthesize revealController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SideMenuUtil addViewGesture:self revealController:revealController];
    [ViewTool setNavigationBar:self.navigationController.navigationBar];
    self.navigationItem.title = @"物业管理";
    self.navigationItem.leftBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithString:@"list.png" WithAction:@selector(sideLeftButton_selector:)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"edit.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goToCreateProperty:)];
    //创建头部视图
    [self createView];
    
    [self createTableView];
}
//创建头部视图
-(void)createView
{
    UISearchBar * searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 40)];
    searchBar.placeholder=@"物业名称/城市/创建人";
    searchBar.delegate=self;
    
    [self.view addSubview:searchBar];
    
    NSArray * labArray=@[@"物业名称",@"城市",@"创建人",@"更新时间"];
    for (int i=0; i<4; i ++)
    {
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/4*i, 64+40, WIDTH/4, 40)];
        label.text=labArray[i];
        label.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
    
    UIView * lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 64+40+39, WIDTH, 1)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
}
//创建表
-(void)createTableView
{
    UITableView * tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+40+40, WIDTH, self.view.frame.size.height-40-40-64) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    
}
//跳到创建物业界面
-(void)goToCreateProperty:(UIButton *)btn
{
    CreatePropertyViewController * propertyVC=[[CreatePropertyViewController alloc]init];
    [self.navigationController pushViewController:propertyVC animated:NO];
}


#pragma mark---协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        for (int i=0; i<4; i ++)
        {
            UILabel * lab=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/4*i, 5, WIDTH/4, 34)];
            lab.tag=i+100;
            lab.textAlignment=NSTextAlignmentCenter;
            [cell addSubview:lab];
        }
      cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (indexPath.row %2 == 1)
        {
            cell.backgroundColor = [UIColor colorWithRed:(20.0f/255.0f) green:(30.0f/255.0f) blue:(40.0f/255.0f) alpha:0.1f];
        }
    }
    
    
    UILabel *propertyLabel=[cell viewWithTag:100];
    propertyLabel.text=@"朗诗物业";
    
    UILabel *cityLabel=[cell viewWithTag:101];
    cityLabel.text=@"上海朗诗";
    
    UILabel *nameLabel=[cell viewWithTag:102];
    nameLabel.text=@"小明";
    
    UILabel *timeLabel=[cell viewWithTag:103];
    timeLabel.text=@"2015.11.11";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PropertyDetailViewController * vc=[[PropertyDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 拉开左侧:点击.
- (void)sideLeftButton_selector:(id)sender {
    
    NSLog(@"PropertyViewController...");
    [self.revealController toggleSidebar:!self.revealController.sidebarShowing duration:kGHRevealSidebarDefaultAnimationDuration];
}
@end
