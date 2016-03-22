//
//  SettingButton.m
//  YunGui
//
//  Created by Hanen 3G 01 on 15/11/16.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "SettingButton.h"
#import "UIView+Extension.h"

@implementation SettingButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0f;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.titleLabel.maxX , 0, 1, self.height)];
        view.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:view];
    }
    return self;
}
#pragma mark - 设置按钮内部图片和文字的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat W = 15 ;
    CGFloat H = contentRect.size.height;
    
    return CGRectMake(self.titleLabel.maxX , 0, W, H);
    
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat W = contentRect.size.width - 15;
    CGFloat H = contentRect.size.height;
    return CGRectMake(0, 0, W, H);
    
}
@end
