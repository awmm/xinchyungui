//
//  ManagerVillageCell.h
//  社区_
//
//  Created by Hanen 3G 01 on 15/11/11.
//  Copyright © 2015年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ManagerModel;

@interface ManagerVillageCell : UITableViewCell

@property (nonatomic, strong) ManagerModel * model;

@property (nonatomic, strong) NSMutableArray * array1;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, assign) NSInteger count;

@end
