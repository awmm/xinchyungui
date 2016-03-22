//
//  ViewTool.m
//  移动营销
//
//  Created by Hanen 3G 01 on 16/2/24.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "ViewTool.h"
#import "UIView+ViewFrame.h"

@implementation ViewTool

+ (void)setNavigationBar:(UINavigationBar *)navigationBar{
    [navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]];
    [navigationBar setTintColor:[UIColor whiteColor]];
    [navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
}

+ (void)setLabelFont:(UILabel *)label{
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIView getFontWithSize:16.0f];
    label.font = [UIFont fontWithName:@"Helvetica" size:17.0];
}

//UIBarButtonItem
+ (UIBarButtonItem *)getBarButtonItemWithTarget:(id)target WithAction:(SEL)action
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIView getWidth:20], [UIView getWidth:20])];
    [btn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (UIBarButtonItem *)getBarButtonItemWithTarget:(id)target WithString:(NSString *)string WithAction:(SEL)action{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIView getWidth:20], [UIView getWidth:20])];
    [btn setBackgroundImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

//UIButton
+ (UIButton *)getAddButtonWithTarget:(id)target WithString:(NSString *)string WithAction:(SEL)action{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-[UIView getWidth:70], kScreenHeight - [UIView getWidth:70], [UIView getWidth:50], [UIView getWidth:50])];
    [btn setBackgroundImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+(UIView *)getLineViewWith:(CGRect)frame withBackgroudColor:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

//UILabel
+ (UILabel *)getLabelWith:(CGRect)frame WithTitle:(NSString *)title WithFontSize:(CGFloat)fontSize WithTitleColor:(UIColor *)color WithTextAlignment:(NSTextAlignment )textAlignment
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.textColor = color;
    label.textAlignment = textAlignment;
    label.font = [UIView getFontWithSize:fontSize];
//    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}

+ (UILabel *)getLabelWithFrame:(CGRect)frame WithAttrbuteString:(NSMutableAttributedString *)attrbuteTitle
{
    UILabel *attrbuteLabel = [[UILabel alloc] initWithFrame:frame];
    attrbuteLabel.attributedText = attrbuteTitle;
    return attrbuteLabel;
}

+ (UIImage *)getImageFromColor:(UIColor *)color WithRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
