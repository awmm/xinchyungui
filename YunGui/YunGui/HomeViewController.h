//
//  HomeViewController.h
//  YunGui
//
//  Created by wmm on 15/11/5.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRevealControllerProperty.h"
#import "Macro.h"
#import "AFNetworking.h"

@interface HomeViewController : UIViewController<IRevealControllerProperty,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@end
