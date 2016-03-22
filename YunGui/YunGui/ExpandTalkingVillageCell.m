//
//  ExpandTalkingVillageCell.m
//  社区_
//
//  Created by Hanen 3G 01 on 15/11/12.
//  Copyright © 2015年 Hanen 3G 01. All rights reserved.
//

#import "ExpandTalkingVillageCell.h"
#import "Macro.h"
#define lwidth   kScreenWidth / 2

@implementation ExpandTalkingVillageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"MCell";
    ExpandTalkingVillageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[ExpandTalkingVillageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell addSubviews];
    }
    
    return cell;
}
- (void)addSubviews
{
   
    for (int i = 0 ; i <
         2; i ++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(lwidth * i, 0, lwidth, self.frame.size.height)];
        label.text = _array2[i];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:label];
    }
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 1)];
//        line.backgroundColor = [UIColor lightGrayColor];
//        [self.contentView addSubview:line];
}

- (void)setArray2:(NSMutableArray *)array2
{
    //!!!!!!!!!!!!!******
    _array2 = array2;

    for (int i = 0; i < self.contentView.subviews.count; i ++) {
        UIView *subView = self.contentView.subviews[i];
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subView;
            label.text = array2[i];
        }
    }
}

- (void)setCount:(NSInteger)count
{
    _count = count;
}

@end
