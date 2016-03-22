//
//  SubListViewController.h
//  YunGui
//
//  Created by wmm on 15/11/16.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewVisitViewController.h"

@interface SubListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, retain) NSObject<UIViewPassValueDelegate> * delegate;

@end
