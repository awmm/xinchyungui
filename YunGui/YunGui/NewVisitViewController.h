//
//  NewVisitViewController.h
//  YunGui
//
//  Created by wmm on 15/11/14.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@protocol UIViewPassValueDelegate

- (void)passValue:(NSString *)value;

@end

@interface NewVisitViewController : UIViewController<UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIViewPassValueDelegate,UIScrollViewDelegate>

@end
