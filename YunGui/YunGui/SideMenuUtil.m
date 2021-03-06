//
//  SideMenuUtil.m
//  StoryboardSideMenu
//
//  Created by zyl910 on 13-6-8.
//  Copyright (c) 2013年 zyl910. All rights reserved.
//

#import "SideMenuUtil.h"

@implementation SideMenuUtil

#pragma mark - property



#pragma mark - method

// 设置revealController属性.
+ (id)setRevealControllerProperty:(id)obj revealController:(GHRevealViewController*)revealController {
	id rt = nil;
	BOOL isOK = NO;
	do {
		if (nil==obj) break;
		
		// IRevealControllerProperty.
		if ([obj conformsToProtocol:@protocol(IRevealControllerProperty)]) {
			((id<IRevealControllerProperty>)obj).revealController = revealController;
			isOK |= YES;
		}
		
		// UINavigationController.
		if ([obj isKindOfClass:UINavigationController.class]) {
			UINavigationController* nc = obj;
			isOK |= nil!=[self setRevealControllerProperty:nc.topViewController revealController:revealController];
			isOK |= nil!=[self setRevealControllerProperty:nc.visibleViewController revealController:revealController];
			for (id p in nc.viewControllers) {
				isOK |= nil!=[self setRevealControllerProperty:p revealController:revealController];
			}
		}
	} while (0);
	if (isOK) rt = revealController;
	return rt;
}

// 添加导航手势.
+ (BOOL)addNavigationGesture:(UINavigationController*)navigationController revealController:(GHRevealViewController*)revealController {
	BOOL rt = NO;
	do {
		if (nil==navigationController) break;
		if (nil==revealController) break;
		
		UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:revealController action:@selector(dragContentView:)];
		panGesture.cancelsTouchesInView = YES;
		[navigationController.navigationBar addGestureRecognizer:panGesture];
//        [navigationController.view addGestureRecognizer:panGesture];
	} while (0);
	return rt;
}

// 添加页面导航手势.
+ (BOOL)addViewGesture:(UIViewController*)viewController revealController:(GHRevealViewController*)revealController {
    BOOL rt = NO;
    do {
        if (nil==viewController) break;
        if (nil==revealController) break;
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:revealController action:@selector(dragContentView:)];
        panGesture.cancelsTouchesInView = YES;
        [viewController.view addGestureRecognizer:panGesture];
    } while (0);
    return rt;
}

@end
