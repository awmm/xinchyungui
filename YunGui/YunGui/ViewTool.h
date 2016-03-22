/*!
 Here , We Become Master!
  @header ViewTool.h
  @abstract 项目名字：移动营销

 
 
  @author Created by Hanen 3G 01 on 16/2/24.
  @version 1.00 16/2/24 Creation
  Copyright © 2016年 Hanen 3G 01. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ViewTool : NSObject


+ (void)setNavigationBar:(UINavigationBar *)navigationBar;

+ (void)setLabelFont:(UILabel *)label;

+ (UIBarButtonItem *)getBarButtonItemWithTarget:(id)target WithAction:(SEL)action
;
+ (UIBarButtonItem *)getBarButtonItemWithTarget:(id)target WithString:(NSString *)string WithAction:(SEL)action
;
+ (UIButton *)getAddButtonWithTarget:(id)target WithString:(NSString *)string WithAction:(SEL)action;




//获取一条线
+ (UIView *)getLineViewWith:(CGRect)frame withBackgroudColor:(UIColor *)color;
//获取label
+ (UILabel *)getLabelWith:(CGRect)frame WithTitle:(NSString *)title WithFontSize:(CGFloat)fontSize WithTitleColor:(UIColor *)color WithTextAlignment:(NSTextAlignment )textAlignment;
//label 的文字 是属性文字
+ (UILabel *)getLabelWithFrame:(CGRect)frame WithAttrbuteString:(NSAttributedString *)attrbuteTitle;

+ (UIImage *)getImageFromColor:(UIColor *)color WithRect:(CGRect)rect;
@end
