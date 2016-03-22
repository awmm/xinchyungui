//
//  ExpandTalkingVillageCell.h
//  社区_
//
//  Created by Hanen 3G 01 on 15/11/12.
//  Copyright © 2015年 Hanen 3G 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpandTalkingVillageCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray * array2;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, assign) NSInteger count;

@end
