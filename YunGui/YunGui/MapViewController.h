//
//  MapViewController.h
//  YunGui
//
//  Created by wmm on 15/11/11.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRevealControllerProperty.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import "MapDetailViewController.h"

@interface MapViewController : UIViewController<IRevealControllerProperty,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKRouteSearchDelegate,BMKGeoCodeSearchDelegate,MapDetailDelegate,UIGestureRecognizerDelegate>
{
    BMKMapView *_mapView;//地图
    BMKLocationService* _locService;//定位
    BMKPoiSearch * _poiSearch;//检索
    BMKGeoCodeSearch * _geoSearcher;//地理编码
    BMKRouteSearch * _routeSearch;//路线规划
    
    CLLocationDegrees latitude;//纬度
    CLLocationDegrees longitude;//经度
    
    CLLocationCoordinate2D location;
    UILabel *label;
}
@property(nonatomic,strong)UITextField *keyTF;

@property(nonatomic,copy)NSString * cityStr;//定位之后的城市
@property(nonatomic,copy)NSString *addrDetailStr;//定位之后的详细地址
@property(nonatomic,copy)NSString *districtStr;//搜索之后的小区名称



- (void)sideLeftButton_selector:(id)sender;

@end
