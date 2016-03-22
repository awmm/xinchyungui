//
//  selectButton.m
//  YunGui
//
//  Created by HanenDev on 15/11/13.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "selectButton.h"
#import "UIView+Extension.h"

@implementation selectButton
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        
        _btnLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-20, 30)];
        //_btnLabel.backgroundColor=[UIColor brownColor];
        _btnLabel.textAlignment=NSTextAlignmentLeft;
        _btnLabel.font=[UIFont systemFontOfSize:15.0f];
        [self addSubview:_btnLabel];
        
        _btnImage=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-20, 0, 20, 30)];
        //_btnImage.backgroundColor=[UIColor lightGrayColor];
        [self addSubview:_btnImage];
        
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0f;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(_btnLabel.maxX , 0, 1, self.height)];
        view.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:view];
        
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
