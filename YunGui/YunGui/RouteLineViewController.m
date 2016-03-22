//
//  RouteLineViewController.m
//  YunGui
//
//  Created by HanenDev on 15/12/2.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "RouteLineViewController.h"
#import "Macro.h"
#import "UIView+Extension.h"

#define  ROUND 8.0f
@interface RouteLineViewController ()
{
    UITableView * _tableView;
}
@end

@implementation RouteLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"详细路线";
    
    [self createView];
}
-(void)createView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
    //imageView.image=[UIImage imageNamed:@""];
    imageView.backgroundColor= [UIColor redColor];
    [headerView addSubview:imageView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(imageView.maxX+10, 5, kScreenWidth-imageView.maxX, 40)];
    label.text=@"起点";
    [headerView addSubview:label];
    _tableView.tableHeaderView=headerView;
    
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    UIImageView *picView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
    //picView.image=[UIImage imageNamed:@""];
    picView.backgroundColor= [UIColor blueColor];
    [footerView addSubview:picView];
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(picView.maxX+10, 5, kScreenWidth-imageView.maxX, 40)];
    lab.text=@"终点";
    [footerView addSubview:lab];
    
    _tableView.tableFooterView=footerView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.routeArray.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *content=[self.routeArray[indexPath.row] instruction];
    CGFloat height=[self getHeightByString:content withFont:[UIFont systemFontOfSize:15.0f]];
    
    return height+20.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIView * view=[[UIView alloc]init];
        view.tag=1000;
        view.backgroundColor=[UIColor greenColor];
        [cell addSubview:view];
        
        UILabel *label=[[UILabel alloc]init];
        label.tag=2000;
        [cell addSubview:label];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UILabel *label=[cell viewWithTag:2000];
    NSString *content=[self.routeArray[indexPath.row] instruction];
    label.text=content;
    label.numberOfLines=0;
    label.font=[UIFont systemFontOfSize:15.0f];
    CGFloat height=[self getHeightByString:content withFont:[UIFont systemFontOfSize:15.0f]];
    label.frame=CGRectMake(50+10, 10, kScreenWidth-70, height);
    
    UIView *view=[cell viewWithTag:1000];
    view.frame=CGRectMake(label.x/2, label.centerY, ROUND, ROUND);
    view.layer.cornerRadius=ROUND/2.0f;
    view.layer.masksToBounds=YES;
    
//    cell.textLabel.text=[[self.routeArray objectAtIndex:indexPath.row] instruction];
//    cell.textLabel.numberOfLines=0;
    
    return cell;
}

-(CGFloat)getHeightByString:(NSString*)string   withFont:(UIFont*)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(kScreenWidth-50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return size.height ;
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
