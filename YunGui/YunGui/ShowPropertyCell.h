//
//  ShowPropertyCell.h
//  YunGui
//
//  Created by Hanen 3G 01 on 15/11/17.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowPropertyCell : UITableViewCell

@property (nonatomic, strong) NSDictionary * arr;
+ (instancetype)cellWithTabelView:(UITableView *)tableView;
@end
