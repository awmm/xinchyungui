//
//  ShowPropertyCell.m
//  YunGui
//
//  Created by Hanen 3G 01 on 15/11/17.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "ShowPropertyCell.h"
#import "UIView+Extension.h"

@interface ShowPropertyCell ()
{
    UILabel     *_propertyName;
    UILabel     *_province;
    UILabel     *_city;
    UILabel     *_county;
}
@end

@implementation ShowPropertyCell



+ (instancetype)cellWithTabelView:(UITableView *)tableView
{
    static NSString *propertyCell = @"propertyCell";
    ShowPropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:propertyCell];
    if(!cell){
        cell = [[ShowPropertyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:propertyCell];
        
        [cell addSubviews];
    }
    
    return cell;
}

- (void)addSubviews
{
    _propertyName = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.width, 30)];
   
    [self.contentView addSubview:_propertyName];
    
    _province = [[UILabel alloc] initWithFrame:CGRectMake(10, _propertyName.maxY + 10, self.width, self.height - _propertyName.maxY)];
   
    [self.contentView addSubview:_province];
    
    
}
- (void)setArr:(NSDictionary *)arr
{
     _arr = arr;
     _propertyName.text = [NSString stringWithFormat:@"物业名称:%@",arr[@"name"]];
     _province .text = [NSString stringWithFormat:@"所属地区:%@",arr[@"region"]];
}
@end
