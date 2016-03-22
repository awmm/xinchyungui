//
//  ManagerVillageCell.m
//  社区_
//
//  Created by Hanen 3G 01 on 15/11/11.
//  Copyright © 2015年 Hanen 3G 01. All rights reserved.
//

#import "ManagerVillageCell.h"
#import "Macro.h"

#define LWidth    kScreenWidth / 4

@implementation ManagerVillageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"MVCell";
    ManagerVillageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[ManagerVillageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
       
        [cell addSubviews];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

- (void)addSubviews
{
//    NSArray *arr = [NSArray array];
//    int num = arc4random()%2;
//    if (num == 0 ) {
//        arr = @[@"浪诗物业",@"南京",@"小明",@"德玛西亚"];
//    }else if (num == 1){
//        arr = @[@"浪诗物业",@"德玛西亚"];
//    }
//

//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 1)];
//    line.backgroundColor = [UIColor blackColor];
//    [self.contentView addSubview:line];
    
    for (int i = 0 ; i <
         4; i ++) {
       
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LWidth * i, 0, LWidth, self.frame.size.height)];
        label.text = _array1[i];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:label];
    }
    
}
- (void)setArray1:(NSMutableArray *)array1
{
    //!!!!!!!!!!!!!******
    _array1 = array1;

    for (int i = 0; i < self.array1.count; i ++) {
        UIView *subView = self.contentView.subviews[i];
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subView;
            label.text = array1[i];
        }
    }
}

- (void)setCount:(NSInteger)count
{
    _count = count;
}
@end
