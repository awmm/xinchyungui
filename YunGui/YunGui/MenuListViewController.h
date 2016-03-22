//
//  MenuListViewController.h
//  YunGui
//
//  Created by wmm on 15/11/5.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRevealControllerProperty.h"
#import "MenuListCell.h"
#import "HWCloudsdk.h"

@interface MenuListViewController : UIViewController<IRevealControllerProperty, UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic) NSInteger roleId;
@end
