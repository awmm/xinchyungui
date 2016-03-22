//
//  Macro.h
//  YunGui
//
//  相关宏定义，url等
//  Created by wmm on 15/11/9.
//  Copyright © 2015年 hanen. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define IsIOS6OrLower ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0)

//获得当前屏幕宽高点数（非像素）
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

//颜色:UIColorFromRGB(0xf1f1f1)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//黄色
#define YELLOWCOLOR UIColorFromRGB(0xfdc500)

#define HEAD_URL @"http://test.yun-gui.com/app"


//http://test.yun-gui.com/app?app_key=yeguan&timestamp=2015-11-24%2019:10:00&sign=D4ECE7A93EA8FAD3F407BEDC451791CF&method=app.user.login&name=zhaoy&password=111111

//登录。
//#define LAND_URL @""HEAD_URL"salesLogin"
//#define LAND_URL @""HEAD_URL"permissionControllerForMobile.do?method=login"

#endif
