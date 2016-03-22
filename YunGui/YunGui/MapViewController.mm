//
//  MapViewController.m
//  YunGui
//
//  Created by wmm on 15/11/11.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "MapViewController.h"
#import "UIView+Extension.h"
#import "Macro.h"
#import "UIImage+Rotate.h"

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@implementation MapViewController

@synthesize revealController;


- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * str=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return str;
    }
    return nil ;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isKindOfClass:[BMKMapView class]]){
        
        return NO;
        
    }
    
    return YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [ViewTool setNavigationBar:self.navigationController.navigationBar];
    self.navigationItem.title = @"小区地图";
    self.navigationItem.leftBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithString:@"list.png" WithAction:@selector(sideLeftButton_selector:)];
    
    //适配iOS7
    if ([[[UIDevice currentDevice] systemVersion]doubleValue]>=7.0)
    {
        self.navigationController.navigationBar.translucent=NO;
    }
    //显示地图
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _mapView.mapType=BMKMapTypeStandard;
    _mapView.isSelectedAnnotationViewFront = YES;
    _mapView.scrollEnabled=YES;
    // 设置地图级别
    [_mapView setZoomLevel:16];
    self.view=_mapView;

    //调节初始地图坐标
    //_mapView.centerCoordinate = CLLocationCoordinate2DMake(39.9, 116.3);
    
    //初始化定位服务
    _locService=[[BMKLocationService alloc]init];
    
    //初始化检索对象
    _geoSearcher =[[BMKGeoCodeSearch alloc]init];
    
    //初始化poi检索
    _poiSearch=[[BMKPoiSearch alloc]init];
    //初始化路径检索
    _routeSearch=[[BMKRouteSearch alloc]init];
    
    
    [self creatUI];
    
}

-(void)creatUI
{
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    view.backgroundColor=[UIColor whiteColor];
    
    _keyTF=[[UITextField alloc]initWithFrame:CGRectMake(5, 2, kScreenWidth-40-10, 30-4)];
    //_keyTF.borderStyle=UITextBorderStyleLine;
    _keyTF.keyboardType=UIKeyboardTypeNamePhonePad;
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchBarIcon.png"]];
    _keyTF.leftView=imageView;
    _keyTF.placeholder=@"物业名称";
    _keyTF.leftViewMode=UITextFieldViewModeAlways;
    _keyTF.layer.borderWidth=1.0f;
    _keyTF.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _keyTF.layer.cornerRadius=15.0f;
    _keyTF.layer.masksToBounds=YES;
//    [_keyTF setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [_keyTF setValue:[UIFont boldSystemFontOfSize:12.0f] forKeyPath:@"_placeholderLabel.font"];
    [view addSubview:_keyTF];
    
    //搜索按钮
    UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(_keyTF.maxX, 2, 40, 30-4)];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:13.0f];
    btn.layer.borderWidth=1.0f;
    btn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    [self.view addSubview:view];
    
    UIButton * locationBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, view.maxY+5, 30, 30)];
    [locationBtn setTitle:@"定位" forState:UIControlStateNormal];
    locationBtn.backgroundColor=[UIColor whiteColor];
    [locationBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //[locationBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    locationBtn.titleLabel.font=[UIFont systemFontOfSize:13.0f];
    locationBtn.layer.borderWidth=1.0f;
    locationBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [locationBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(locationClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationBtn];
}

//设置代理
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate=self;
    _locService.delegate=self;
    _poiSearch.delegate=self;
    _routeSearch.delegate=self;
    _geoSearcher.delegate = self;
    
}
//代理不用时，置为nil
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate=nil;
    _locService.delegate=nil;
    _poiSearch.delegate=nil;
    _routeSearch.delegate=nil;
    _geoSearcher.delegate = nil;
    
    
//    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
//    [_mapView removeAnnotations:array];
}
//点击定位按钮
-(void)locationClick:(UIButton *)sender
{
    [_mapView setZoomLevel:16];
    _mapView.centerCoordinate=_locService.userLocation.location.coordinate;
//    NSLog(@"进入普通定位态");
//    [_locService startUserLocationService];
//    _mapView.showsUserLocation=NO;
//    _mapView.userTrackingMode=BMKUserTrackingModeNone;
//    _mapView.showsUserLocation=YES;
}

-(void)searchClick:(UIButton *)btn
{
//    BMKNearbySearchOption * option=[[BMKNearbySearchOption alloc]init];
//    option.pageIndex=0;
//    option.pageCapacity=10;
//    //option.location=_locService.userLocation.location.coordinate;
//    option.radius=1000;
//    option.location=_mapView.centerCoordinate;
//    NSLog(@"---------- lat %f,long %f",_locService.userLocation.location.coordinate.latitude,_locService.userLocation.location.coordinate.longitude);
//    //option.location=CLLocationCoordinate2DMake(31.957161, 118.921450);
//    option.keyword=_keyTF.text;
//    BOOL flag= [_poiSearch poiSearchNearBy:option];
//    if (flag)
//    {
//        NSLog(@"周边检索发送成功");
//    }
//    else
//    {
//        NSLog(@"周边检索发送失败");
//    }
    
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = 0;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city=self.cityStr;
    citySearchOption.keyword =_keyTF.text;
    BOOL flag = [_poiSearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
    
}
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    [_locService startUserLocationService];
    _mapView.showsUserLocation=NO;
    _mapView.userTrackingMode=BMKUserTrackingModeNone;
    _mapView.showsUserLocation=YES;
}

//在地图View将要启动定位时，会调用此函数
-(void)willStartLocatingUser
{
    NSLog(@"start locate");
}

//定位失败会调用此函数
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}
//用户位置更新，调用此函数
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    _mapView.centerCoordinate = userLocation.location.coordinate;
    [_mapView updateLocationData:userLocation];
    [_locService stopUserLocationService];//定位成功之后关闭定位
    
    latitude=userLocation.location.coordinate.latitude;//纬度
    longitude=userLocation.location.coordinate.longitude;//精度
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){latitude, longitude};
    BMKReverseGeoCodeOption *reverseGeoOption = [[
    BMKReverseGeoCodeOption alloc]init];
    reverseGeoOption.reverseGeoPoint = pt;
    BOOL flag = [_geoSearcher reverseGeoCode:reverseGeoOption];
    if(flag)
    {
      NSLog(@"反geo检索发送成功");
    }
    else
    {
      NSLog(@"反geo检索发送失败");
    }

}
#pragma mark -
#pragma mark --反地理编码

//返回反地理编码搜索结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
          //在此处理正常结果
        
//        BMKPointAnnotation *item=[[BMKPointAnnotation alloc]init];
//        item.coordinate=result.location;
//        item.title=result.address;
//        item.subtitle=result.businessCircle;
//        //[_mapView addAnnotation:item];
        
        self.cityStr=result.addressDetail.city;
        self.addrDetailStr=[NSString stringWithFormat:@"%@,%@,%@",result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber];
        NSLog(@"%@========",self.cityStr);
        NSLog(@"%@,%@,%@,%@,%@",result.addressDetail,result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber);
      }
      else {
          NSLog(@"抱歉，未找到结果");
      }
}

#pragma mark -
#pragma mark --地图 BMKMapViewDelegate
//设置标注生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
     NSLog(@"VIEW FOR ANNPTATION 1");
    
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
    }
   
    else if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xiaoQu";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorGreen;
        // 设置从天上掉下的效果
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    //annotationView.image=[UIImage imageNamed:@""];
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
        
    //自定义弹出来的泡泡View
    //设定popView的高度
    double popViewH = 50;
    if (annotation.subtitle == nil) {
        popViewH = 38;
    }
    UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 230, popViewH)];
    popView.backgroundColor = [UIColor whiteColor];
    [popView.layer setMasksToBounds:YES];
    [popView.layer setCornerRadius:3.0];
    popView.alpha = 0.9;
//        //设置弹出气泡图片
//        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
//        image.frame = CGRectMake(0, 160, 50, 60);
//        [popView addSubview:image];

    //自定义气泡的内容，添加子控件在popView上
    UILabel *titleName = [[UILabel alloc]initWithFrame:CGRectMake(8, 2, 160, 30)];
    titleName.text = annotation.title;
    titleName.tag=2222;
    titleName.numberOfLines = 0;
    titleName.backgroundColor = [UIColor clearColor];
    titleName.font = [UIFont systemFontOfSize:15];
    titleName.textColor = [UIColor blackColor];
    titleName.textAlignment = NSTextAlignmentLeft;
    [popView addSubview:titleName];
    
    UILabel *subName = [[UILabel alloc]initWithFrame:CGRectMake(8, 24, 180, 30)];
    subName.text = annotation.subtitle;
    subName.backgroundColor = [UIColor clearColor];
    subName.font = [UIFont systemFontOfSize:11];
    subName.textColor = [UIColor lightGrayColor];
    subName.textAlignment = NSTextAlignmentLeft;
    [popView addSubview:subName];
    
    if (annotation.subtitle != nil) {
        UIButton *searchBn = [[UIButton alloc]initWithFrame:CGRectMake(180, 0, 50, popViewH)];
        [searchBn setTitle:@"到这去" forState:UIControlStateNormal];
        searchBn.backgroundColor = [UIColor redColor];
        searchBn.titleLabel.numberOfLines = 0;
        [searchBn addTarget:self action:@selector(searchLine:) forControlEvents:UIControlEventTouchUpInside];
        [popView addSubview:searchBn];
    }
    
    BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
    pView.frame = CGRectMake(0, 0, 230, popViewH);
    ((BMKPinAnnotationView*)annotationView).paopaoView = nil;
    ((BMKPinAnnotationView*)annotationView).paopaoView = pView;
    
    return annotationView;
    }else{
        return nil;
    }
}
#pragma mark------- 跳转
//跳转到详细地图界面
-(void)searchLine:(UIButton *)btn
{
    label=[[btn superview] viewWithTag:2222];
    
    MapDetailViewController * vc=[[MapDetailViewController alloc]init];
    vc.cityStr=self.cityStr;
    vc.addrDetailStr=self.addrDetailStr;
    vc.districtStr=label.text;
    vc.delegate=self;
    vc.myLocation=(CLLocationCoordinate2D){latitude, longitude};
    NSLog(@"%f+++++---------",vc.myLocation.latitude);
    NSLog(@"%@,%@",vc.cityStr,vc.addrDetailStr);
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        location= result.location;
        NSLog(@"%f,%f",location.latitude,location.longitude);
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
#pragma mark----- 公交路线规划
- (void)addLineToMapViewControllerWithTransitRoute:(NSArray *)array withNum:(NSInteger)count
{
   
    NSArray* arr = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:arr];
    arr = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:arr];
    
    BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[array objectAtIndex:count];
    NSLog(@"%lu",(unsigned long)array.count);
    // 计算路线方案中的路段数目
    NSInteger size = [plan.steps count];
    int planPointCounts = 0;
    for (int i = 0; i < size; i++) {
        BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
        BMKVehicleInfo *verInfo =transitStep.vehicleInfo;
        NSLog(@"换乘:%@ 名称:%@ 站数:%d",transitStep.instruction,verInfo.title,verInfo.passStationNum);
        if(i==0){
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = plan.starting.location;
            item.title = @"起点";
            item.type = 0;
            [_mapView addAnnotation:item]; // 添加起点标注
            
        }else if(i==size-1){
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = plan.terminal.location;
            item.title = @"终点";
            item.type = 1;
            [_mapView addAnnotation:item]; // 添加终点标注
        }
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [_mapView addAnnotation:item];

            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
    }
    
    //轨迹点
    BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
    int i = 0;
    for (int j = 0; j < size; j++) {
        BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
        int k=0;
        for(k=0;k<transitStep.pointsCount;k++) {
            temppoints[i].x = transitStep.points[k].x;
            temppoints[i].y = transitStep.points[k].y;
            i++;
        }
        
    }
    // 通过points构建BMKPolyline
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
    [_mapView addOverlay:polyLine]; // 添加路线overlay
    delete []temppoints;
    [self mapViewFitPolyLine:polyLine];
    
}
#pragma mark----- 驾乘路线规划
-(void)drawLineWithDrivingRoute:(NSArray *)array
{
    NSArray* arr = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:arr];
    arr = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:arr];
    
//        BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
//        geoCodeSearchOption.city= self.cityStr;
//        geoCodeSearchOption.address =label.text;
//        BOOL flag1 = [_geoSearcher geoCode:geoCodeSearchOption];
//        if(flag1)
//        {
//            NSLog(@"geo检索发送成功");
//        }
//        else
//        {
//            NSLog(@"geo检索发送失败");
//        }
//    
//    
//    
//        BMKPlanNode *start=[[BMKPlanNode alloc]init];
//        //start.name=self.addrDetailStr;
//        start.pt=(CLLocationCoordinate2D){latitude, longitude};
//        NSLog(@"%f---------",start.pt.latitude);
//        start.cityName=self.cityStr;
//        BMKPlanNode *end=[[BMKPlanNode alloc]init];
//        end.name=label.text;
//        end.pt=location;
//        NSLog(@"%f---------",end.pt.latitude);
//        end.cityName=self.cityStr;
//        BMKDrivingRoutePlanOption *drivingOption=[[BMKDrivingRoutePlanOption alloc]init];
//        drivingOption.from=start;
//        drivingOption.to=end;
//        BOOL flag = [_routeSearch drivingSearch:drivingOption];
//        if(flag)
//        {
//            NSLog(@"car检索发送成功");
//        }
//        else
//        {
//            NSLog(@"car检索发送失败");
//        }
    
    
    
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[array objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* drivingStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加终点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = drivingStep.entrace.location;
            item.title = drivingStep.entraceInstruction;
            item.degree = drivingStep.direction * 30;
            item.type = 4;
            //[_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += drivingStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                //item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* drivingStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<drivingStep.pointsCount;k++) {
                temppoints[i].x = drivingStep.points[k].x;
                temppoints[i].y = drivingStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];

}

//当选中一个annotation views时，调用此接口
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
    
}
// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
        //
//        MapDetailViewController * vc=[[MapDetailViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
   
}
#pragma mark -
#pragma mark --poi搜索结果 BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清除屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *annotations = [NSMutableArray array];
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            //self.districtStr=poi.name;//搜索之后的确切的小区名称
            item.coordinate = poi.pt;
            item.title = poi.name;
            item.subtitle= poi.address;
            [annotations addObject:item];
        }
        [_mapView addAnnotations:annotations];
        [_mapView showAnnotations:annotations animated:YES];
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    }else if ( error == BMK_SEARCH_AMBIGUOUS_KEYWORD
              ){
        NSLog(@"检索词有岐义");
    }
    else if ( error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR
             ){
        NSLog(@"检索地址有岐义");
    }
    else {
        // 各种情况的判断。。。
    }
}

//设置关键点的标注
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
     NSLog(@"VIEW FOR ANNPTATION 2");
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;//是否弹出气泡
            }
            view.annotation = routeAnnotation;//起点
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;//终点
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;//公交
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;//地铁
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;//驾乘
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;//途经
        }
            break;
        default:
            break;
    }
    
    return view;
}
// 根据overlay生成对应的View 折线覆盖物
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];// 填充颜色
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}


// 拉开左侧:点击.
- (void)sideLeftButton_selector:(id)sender {
    
    NSLog(@"MapViewController...");
    [self.revealController toggleSidebar:!self.revealController.sidebarShowing duration:kGHRevealSidebarDefaultAnimationDuration];
}

@end
