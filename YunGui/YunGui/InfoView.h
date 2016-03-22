//
//  InfoView.h
//  YunGui
//
//  Created by Hanen 3G 01 on 15/11/17.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoView : UIView

//数据数组 传入一张饼状图的百分比数字0～100 可以用字典 包含百分比和其对应的文字情况
@property(nonatomic,copy)NSArray *array;

@property (nonatomic, strong) NSString  * title;


@end
