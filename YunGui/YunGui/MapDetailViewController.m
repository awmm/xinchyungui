//
//  MapDetailViewController.m
//  YunGui
//
//  Created by HanenDev on 15/11/23.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "MapDetailViewController.h"
#import "UIView+Extension.h"
#import "Macro.h"
#import "MapLineCell.h"
#import "RouteLineViewController.h"
#import "SQButton.h"

#define REBTNWIDTH 60.0f
#define FONT(font) [UIFont systemFontOfSize:font]

@implementation MapDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"地图详情";
    
    //初始化检索对象
    _geoSearcher =[[BMKGeoCodeSearch alloc]init];
    //初始化路径检索
    _routeSearch=[[BMKRouteSearch alloc]init];
    
    [self createView];
    
    [self createTableView];
}
//设置代理
-(void)viewWillAppear:(BOOL)animated
{
    _routeSearch.delegate=self;
    _geoSearcher.delegate = self;

}
//代理不用时，置为nil
-(void)viewWillDisappear:(BOOL)animated
{
    _routeSearch.delegate=nil;
    _geoSearcher.delegate = nil;

}
-(void)createView
{
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 40, 90)];
    imageView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:imageView];
    
    _myLabel=[[UILabel alloc]initWithFrame:CGRectMake(imageView.maxX+10, 10, kScreenWidth-imageView.maxX-REBTNWIDTH, 30)];
    _myLabel.text=@"我的位置";
    [self.view addSubview:_myLabel];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(imageView.maxX, _myLabel.maxY+30/2, kScreenWidth-imageView.maxX-REBTNWIDTH, 1)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    _addrLabel=[[UILabel alloc]initWithFrame:CGRectMake(imageView.maxX+10, _myLabel.maxY+30, kScreenWidth-imageView.maxX-REBTNWIDTH, 30)];
    _addrLabel.text=self.districtStr;
    [self.view addSubview:_addrLabel];
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.city= self.cityStr;
    geoCodeSearchOption.address = _addrLabel.text;
    BOOL flag = [_geoSearcher geoCode:geoCodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
    
    SQButton *changeBtn=[[SQButton alloc]initWithFrame:CGRectMake(_myLabel.maxX, _myLabel.maxY, REBTNWIDTH, 40)];
    [changeBtn setTitle:@"转换" forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(addrChangedClick:) forControlEvents:UIControlEventTouchUpInside];
    changeBtn.isSelected=NO;
    [self.view addSubview:changeBtn];
    
    NSArray * titleArray=@[@"公交",@"驾车",@"详情"];
    for (int i=0; i<titleArray.count; i++)
    {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/3.0f*i, _addrLabel.maxY+5, kScreenWidth/3.0f, 40)];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.backgroundColor=[UIColor lightGrayColor];
        btn.tag=1000+i;
        [btn addTarget:self action:@selector(searchLine:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    
}
-(void)searchLine:(UIButton *)sender
{
    if (sender.tag-1000==0)
    {
        [self.view addSubview:_busTableView];
        
        BMKPlanNode *startNode=[[BMKPlanNode alloc]init];
        startNode.name=self.addrDetailStr;
        BMKPlanNode *endNode=[[BMKPlanNode alloc]init];
        endNode.name=_addrLabel.text;
        NSLog(@"%@",endNode.name);
        BMKTransitRoutePlanOption *transitOption=[[BMKTransitRoutePlanOption alloc]init];
        transitOption.city=self.cityStr;
        NSLog(@"%@+++++++++",transitOption.city);
        transitOption.from=startNode;
        transitOption.to=endNode;
        BOOL flag=[_routeSearch transitSearch:transitOption];
        if(flag)
        {
            NSLog(@"bus检索发送成功");
        }
        else
        {
            NSLog(@"bus检索发送失败");
        }

    }
    if (sender.tag-1000==1)
    {
        [self.view addSubview:_carTableView];
        
        BMKPlanNode *start=[[BMKPlanNode alloc]init];
        //start.name=self.addrDetailStr;
        start.pt=self.myLocation;
        //start.cityName=self.cityStr;
        BMKPlanNode *end=[[BMKPlanNode alloc]init];
        //end.name=_addrLabel.text;
        end.pt=location;
        //end.cityName=self.cityStr;
        BMKDrivingRoutePlanOption *drivingOption=[[BMKDrivingRoutePlanOption alloc]init];
        drivingOption.from=start;
        drivingOption.to=end;
        BOOL flag = [_routeSearch drivingSearch:drivingOption];
        if(flag)
        {
            NSLog(@"car检索发送成功");
        }
        else
        {
            NSLog(@"car检索发送失败");
        }

//        [self performSelector:@selector(delayClick) withObject:nil afterDelay:0.5];
        
    }
    if(sender.tag-1000==2)
    {
        NSLog(@"详情");
    }
    
}
-(void)addrChangedClick:(SQButton *)btn
{
    if (btn.isSelected==NO)
    {
        _myLabel.text=self.districtStr;
        _addrLabel.text=@"我的位置";
        btn.isSelected=YES;
    }else
    {
        _myLabel.text=@"我的位置";
        _addrLabel.text=self.districtStr;
        btn.isSelected=NO;
    }
    
}
//-(void)delayClick
//{
//    if ([self.delegate respondsToSelector:@selector(drawLineWithDrivingRoute:)]) {
//        [self.delegate drawLineWithDrivingRoute:self.searchCarArr];
//    }
//    [self.navigationController popViewControllerAnimated:YES];
//}
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        location= result.location;
        NSLog(@"%f,%f",location.latitude,location.longitude);
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

-(void)createTableView
{
    UIButton *button=[self.view viewWithTag:1000];
    
    _busTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, button.maxY, kScreenWidth, kScreenHeight-button.maxY)];
    _busTableView.delegate=self;
    _busTableView.dataSource=self;
    //[self.view addSubview:_busTableView];
    
    _carTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, button.maxY, kScreenWidth, kScreenHeight-button.maxY)];
    _carTableView.delegate=self;
    _carTableView.dataSource=self;
    
    
}

- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    
    //NSMutableArray *lineArr = [[NSMutableArray alloc]init];
    self.searchBusArr=result.routes;
    if (error == BMK_SEARCH_NO_ERROR) {
        
    }else if ( error == BMK_SEARCH_AMBIGUOUS_KEYWORD
              ){
        NSLog(@"检索词有岐义");
    }
    else if ( error == BMK_SEARCH_NOT_SUPPORT_BUS_2CITY
             ){
        NSLog(@"不支持跨城市公交");
    }

    [_busTableView reloadData];
}
-(void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    self.searchCarArr=result.routes;
    
    BMKDrivingRouteLine *plan=(BMKDrivingRouteLine *)[result.routes objectAtIndex:0];
    NSLog(@"  时间：%2d %2d:%2d:%2d 长度: %d米",
          plan.duration.dates,
          plan.duration.hours,
          plan.duration.minutes,
          plan.duration.seconds,
          plan.distance);
    // 计算路线方案中的路段数目
    int size = (int)[plan.steps count];
    NSLog(@"%@",plan.steps);
    for (int i = 0; i < size; i++) {
        BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
        //NSLog(@"%@ %@",transitStep.instruction,infos.title);
        NSLog(@"%@     %@    %@     ",
              transitStep.entrace.title,
              transitStep.exit.title,
              transitStep.instruction);
        }

    
    NSLog(@"%lu",(unsigned long)result.routes.count);
    NSLog(@"起点poi列表数组%@",result.suggestAddrResult.startPoiList);
    NSLog(@"终点poi列表数组%@",result.suggestAddrResult.endPoiList);
    if(error==BMK_SEARCH_NO_ERROR)
    {
    }else if ( error == BMK_SEARCH_AMBIGUOUS_KEYWORD
              ){
        NSLog(@"检索词有岐义");
    }
    else if ( error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR
             ){
        NSLog(@"检索地址有岐义");
    }else if (error==BMK_SEARCH_RESULT_NOT_FOUND){
        NSLog(@"没有找到检索结果");
    }else if (error==BMK_SEARCH_KEY_ERROR){
        NSLog(@"key错误");
    }
 
    [_carTableView reloadData];
}

#pragma mark
#pragma -----代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==_busTableView){
        return self.searchBusArr.count;
    }
    else if (tableView==_carTableView)
    {
        return self.searchCarArr.count;
    }
    else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    MapLineCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell=[[MapLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (tableView==_busTableView)
    {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[self.searchBusArr objectAtIndex:indexPath.row];
        NSLog(@"  时间：%2d %2d:%2d:%2d 长度: %d米",
              plan.duration.dates,
              plan.duration.hours,
              plan.duration.minutes,
              plan.duration.seconds,
              plan.distance);
        // 计算路线方案中的路段数目
        int size = (int)[plan.steps count];
        NSLog(@"%@",plan.steps);
        NSString *vehicleName = @"";
        
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            BMKVehicleInfo *infos = transitStep.vehicleInfo;
            //NSLog(@"%@ %@",transitStep.instruction,infos.title);
            NSLog(@"%@     %@    %@    %@    ",
                  transitStep.entrace.title,
                  transitStep.exit.title,
                  transitStep.instruction,
                  (transitStep.stepType == BMK_BUSLINE ? @"公交路段" : (transitStep.stepType == BMK_SUBWAY ? @"地铁路段" : @"步行路段"))
                  );
            if (transitStep.stepType==BMK_WAKLING)
            {
                NSLog(@"%@++++++++++++",transitStep.instruction);
            }
            //判断是否有线路名称
            if (infos) {
                if ([vehicleName isEqualToString:@""]) {
                    vehicleName = [NSString stringWithFormat:@"%@",infos.title];
                    
                }
                else{
                    vehicleName = [NSString stringWithFormat:@"%@ - %@",vehicleName,infos.title];
                }
            }
        }
        
        cell.titleLabel.text=vehicleName;
        cell.titleLabel.font=FONT(15.0f);
        
        cell.timeLabel.text= [NSString stringWithFormat:@"%d分钟",(plan.duration.hours*60+plan.duration.minutes)];
        cell.timeLabel.font=FONT(13.0f);
        cell.walkLabel.text=[NSString stringWithFormat:@"%.2f公里",plan.distance/1000.0f];
        cell.walkLabel.font=FONT(13.0f);
        return cell;

    }
    if (tableView==_carTableView)
    {
        BMKDrivingRouteLine *plan=(BMKDrivingRouteLine *)[self.searchCarArr objectAtIndex:indexPath.row];
        NSLog(@"  时间：%2d %2d:%2d:%2d 长度: %d米",
              plan.duration.dates,
              plan.duration.hours,
              plan.duration.minutes,
              plan.duration.seconds,
              plan.distance);
        int size = (int)[plan.steps count];
        
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            //NSLog(@"%@ %@",transitStep.instruction,infos.title);
            NSLog(@"%@",
                  transitStep.instruction);
        }
        cell.titleLabel.text=@"驾车方案";
        cell.titleLabel.font=FONT(15.0f);
        cell.timeLabel.text=[NSString stringWithFormat:@"%d分钟",(plan.duration.hours*60+plan.duration.minutes)];
        cell.timeLabel.font=FONT(13.0f);
        cell.walkLabel.text=[NSString stringWithFormat:@"%.2f公里",plan.distance/1000.0f];
        cell.walkLabel.font=FONT(13.0f);
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if ([self.delegate respondsToSelector:@selector(addLineToMapViewControllerWithTransitRoute:withNum:)]) {
//        [self.delegate addLineToMapViewControllerWithTransitRoute:self.searchBusArr withNum:indexPath.row ];
//    }
//    [self.navigationController popViewControllerAnimated:YES];
    
    if (tableView==_busTableView)
    {
         //BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[self.searchBusArr objectAtIndex:indexPath.row];
        RouteLineViewController *routeVC=[[RouteLineViewController alloc]init];
        BMKTransitRouteLine* plan=self.searchBusArr[indexPath.row];
        NSLog(@"%@",plan.steps);
        routeVC.routeArray=plan.steps;
        [self.navigationController pushViewController:routeVC animated:YES];
    }
    if (tableView==_carTableView)
    {
        BMKDrivingRouteLine *plan=(BMKDrivingRouteLine *)[self.searchCarArr objectAtIndex:indexPath.row];
        RouteLineViewController *routeVC=[[RouteLineViewController alloc]init];
        NSLog(@"%@",plan.steps);
        routeVC.routeArray=plan.steps;
        [self.navigationController pushViewController:routeVC animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
