//
//  SegmentView.h
//  YunGui
//
//  Created by Hanen 3G 01 on 15/11/12.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SegmentView;
@protocol SegViewDelegate <NSObject>

- (void)segmentView:(SegmentView *)segment didSelectIndex:(NSInteger)index;

- (void)segmentView:(SegmentView *)segment didScrollIndex:(NSInteger)index;
@end



@interface SegmentView : UIView

- (instancetype)initWithFrame:(CGRect)frame withTitlesArray:(NSArray *)titles;

@property (nonatomic, assign)int selectIndex;

@property (nonatomic, strong) NSArray *titles;


//默认选中的
@property (nonatomic, assign) NSInteger firstIndex;

//指示器的颜色
@property (nonatomic, strong) UIColor *indicatorViewColor;

//代理
@property (nonatomic, strong)id <SegViewDelegate>delegate;

@end

