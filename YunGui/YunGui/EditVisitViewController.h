//
//  EditVisitViewController.h
//  YunGui
//
//  Created by wmm on 15/11/14.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "NewVisitViewController.h"

@interface EditVisitViewController : UIViewController<UITextViewDelegate>

@property(nonatomic, retain) NSObject<UIViewPassValueDelegate> * delegate;

@end
