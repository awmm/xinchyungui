//
//  SegmentView.m
//  YunGui
//
//  Created by Hanen 3G 01 on 15/11/12.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "SegmentView.h"
#define DefaultCurrentBtnColor [UIColor whiteColor]


@interface SegmentView ()
{
    NSInteger   _btnCount;
    
    UIView     *_indicatorView; // 指示视图(滑动视图)
    
    UIButton   *_currentBtn;
    
    BOOL        _isSelectedBegan; // 是否设置了selectedBegan
    
    NSInteger   _currentIndex;
    
    CGFloat     _btnWidth;
    
    CGFloat     _btnHeight;
}

@property (nonatomic, strong)NSMutableArray *btnArray;


@end
@implementation SegmentView

- (instancetype)initWithFrame:(CGRect)frame withTitlesArray:(NSArray *)titles
{
    if (self = [super initWithFrame:frame]) {
//        self.layer.cornerRadius  = frame.size.height / 10;
//        self.layer.cornerRadius = 0;
        self.backgroundColor = [UIColor orangeColor];
//        self.layer.masksToBounds = YES;
        self.titles = titles;
        _btnCount = titles.count;
        
        [self creatView];
    }
    return self;
}
//lazyLoad
- (NSMutableArray *)btnArray
{
    if (_btnArray == nil) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}
- (void)setIndicatorViewColor:(UIColor *)indicatorViewColor
{
    _indicatorViewColor = indicatorViewColor;
    _indicatorView.backgroundColor = _indicatorViewColor;
    
}
- (void)creatView
{
    _btnWidth = self.frame.size.width / _btnCount;
    _btnHeight = self.frame.size.height;
    
    _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _btnWidth, _btnHeight)];
    _indicatorView.backgroundColor = [UIColor whiteColor];
    _indicatorView.alpha = 0.7;
    _indicatorView.layer.cornerRadius = self.layer.cornerRadius;
    _indicatorView.layer.masksToBounds = YES;
    [self addSubview:_indicatorView];
    
    // 创建各个按钮
    for (int i = 0; i < _btnCount; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(_btnWidth * i, 0, _btnWidth, _btnHeight);
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
         
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = self.layer.cornerRadius;
        
        btn.tag = 987548 + i;
        [self addSubview:btn];
        
        [self.btnArray addObject:btn]; // 加入数组
        
        
    }
    
}
#pragma mark --seg时间处理
//#pragma mark 事件拦截，当点击区域在指示视图的范围内时就直接把事件交给self处理，按钮就接收不到事件了
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint p = [self convertPoint:point toView:_indicatorView];
    if ([_indicatorView pointInside:p withEvent:event]) {
        return self;
    } else {
        return [super hitTest:point withEvent:event];
    }
}
//按钮点击
- (void)btnClicked:(UIButton *)btn
{
    [self selectedBegan];
    _currentIndex = btn.tag - 987548;
    _indicatorView.frame = CGRectMake(_btnWidth * _currentIndex, 0, _btnWidth, _btnHeight);
    [UIView animateWithDuration:.5 animations:^{
//        _indicatorView.frame = CGRectMake(_btnWidth * _currentIndex, 0, _btnWidth, _btnHeight);
    } completion:^(BOOL finished) {
        [self selectedEnd];
        if ([_delegate respondsToSelector:@selector(segmentView:didSelectIndex:)]) {
            [_delegate segmentView:self didSelectIndex:_currentIndex];
        }
    }];
    
}

//seg的触摸
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self selectedBegan];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPoint previousTouch = [touch previousLocationInView:self];
    
    //移动距离
    CGFloat diffMove = point.x - previousTouch.x;
    
    //限制指示图移动范围
    CGRect frame = _indicatorView.frame;
    if (frame.origin.x + diffMove >= 0 && frame.origin.x + diffMove <= (_btnCount - 1)*_btnWidth ) {
        frame.origin =  CGPointMake(frame.origin.x + diffMove, 0);
    }
    
    _indicatorView.frame = frame;
}
//手势结束判断改滑到哪个button上
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint center = _indicatorView.center;
    NSInteger index = center.x / _btnWidth;
    [UIView animateWithDuration:.25 animations:^{
        _indicatorView.frame = CGRectMake(_btnWidth * index, 0, _btnWidth, _btnHeight);
    } completion:^(BOOL finished) {
        [self selectedEnd];
        if ([_delegate respondsToSelector:@selector(segmentView:didScrollIndex:)]) {
            [_delegate segmentView:self didScrollIndex:index];
        }
    }];
    
    
}
/** 选开始的设置，指示视图变暗，字体颜色改变 */
- (void)selectedBegan
{
    if (_isSelectedBegan) return;
    
    _isSelectedBegan = YES;
    
    _indicatorView.alpha = 0.5f;
    
}


/** 选开始的设置 */
- (void)selectedEnd
{
    if (!_isSelectedBegan) return;
    
    _isSelectedBegan = NO;
    
    _indicatorView.alpha = 1.0f;
    
    // 如果没有设置background，就为默认颜色
    UIColor *color = self.backgroundColor ? self.backgroundColor : DefaultCurrentBtnColor;
    [_currentBtn setTitleColor:color forState:UIControlStateNormal];
}

@end
