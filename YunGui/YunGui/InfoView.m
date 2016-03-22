//
//  InfoView.m
//  YunGui
//
//  Created by Hanen 3G 01 on 15/11/17.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "InfoView.h"
#import "UIView+Extension.h"

#define widthScale  0.9

#define labelSpace 5.0f
//#define InfoLabelWidth (_infoView.width - (_array.count - 1) * labelSpace )/ _array.count
//#define InfoLabelWidth 60.0f
#define colorLabelWidth 15.0f
//#define wordLabelWidth InfoLabelWidth - colorLabelWidth
#define wordLabelWidth 40.0f
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0]

@interface InfoView ()
{
    //scrollView上的一些指示
    UILabel             *_categoryLabel;
    
    //饼状的图
    UIImageView         *_pieInfoView;
    
    //颜色代表的信息
    UIView              *_infoView;
    
    //颜色数组
    NSArray             *_colorArray;
        
    CGFloat               space;
    
    NSInteger            _count;
    CGFloat              _infoLabelWidth;
    CGFloat              _lastWordLabelHeight;
    CGFloat              _lineCount;
    CGRect               _lastLabelFrame;
   
}
@end

@implementation InfoView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _colorArray = @[[UIColor colorWithWhite:0.4 alpha:1],[UIColor colorWithWhite:0.7 alpha:1],[UIColor cyanColor],[UIColor brownColor],[UIColor blueColor],
                        [UIColor colorWithRed:0.4 green:0.8 blue:0.6 alpha:1],
                        [UIColor colorWithRed:0.6 green:0.4 blue:0.6 alpha:1],
                        [UIColor colorWithRed:0.2 green:0.6 blue:0.6 alpha:1],
                        [UIColor colorWithRed:0.8 green:0.1 blue:0.4 alpha:1],
                        [UIColor colorWithRed:0.5 green:0.3 blue:0.5 alpha:1],
                        [UIColor colorWithRed:0.7 green:0.5 blue:0.1 alpha:1],
                        [UIColor colorWithRed:0.5 green:0.1 blue:0.3 alpha:1],];
        _infoLabelWidth = 0;
        _lineCount = 1;
        self.backgroundColor = [UIColor whiteColor];
        
        _categoryLabel = [[UILabel alloc] init];
          [self addSubview:_categoryLabel];
     
        _pieInfoView = [[UIImageView alloc] init];
        
           [self addSubview:_pieInfoView];
        
        _infoView = [[UIView alloc] init];
          [self addSubview:_infoView];
        
        [self setNeedsDisplay];
        
        

    }
    return self;
}
//绘制饼状图 
- (void)drawRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(_pieInfoView.frame.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint centerPoint = CGPointMake(_pieInfoView.width / 2.0, _pieInfoView.width / 2.0f);
    CGFloat randNum = arc4random()%100;
    CGFloat startAngle = randNum / 100 * 2 * M_PI;

    for (int i = 0; i <_array.count; i ++) {
        //显示在图上的百分比信息
        
//        UILabel *percentLabel = [UILabel alloc] initWithFrame:<#(CGRect)#>
        CGFloat raduis = _pieInfoView.width / 2.0f;
        CGFloat percentAngle = [_array[i] floatValue] / 100 * 2 * M_PI;
        CGFloat endAngle = startAngle + percentAngle;
        
//        //弧度 的长度
//        CGFloat length = percentAngle * raduis /2.0f;
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:raduis startAngle:startAngle endAngle:endAngle clockwise:YES];
        [bezierPath addLineToPoint:centerPoint];
        
        CGContextAddPath(context, bezierPath.CGPath);
        UIColor *color = _colorArray[i];
        [color set];
        
        CGContextDrawPath(context, kCGPathFill);
        
        startAngle = endAngle;
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    _pieInfoView.image = image;
}
- (void)layoutSubviews
{
    
    
   
}
- (void)setArray:(NSArray *)array
{
    _array = array;
    _lastLabelFrame = CGRectMake(0, 5.0f, 0, 0 );
    if (self.width > 322) {
        space = 20;
    }else{
        space = 10;
    }
    
    _pieInfoView.frame = CGRectMake((self.width - widthScale * self.width) / 2.0f, _categoryLabel.maxY + space, widthScale * self.width, widthScale * self.width);
    
    _infoView.frame = CGRectMake(5, _pieInfoView.maxY + space, self.width - 2 * 5 , 30 * 3 - 2 * 7.5);
    
    _infoView.layer.borderWidth = 1.0f;
    _infoView.layer.borderColor = [UIColor colorWithWhite:0.4 alpha:1].CGColor;
    
    for (int i = 0; i < _array.count; i ++) {
        
        UILabel *colorLabel;
       
        colorLabel = [[UILabel alloc] init];
        colorLabel.backgroundColor = _colorArray[i];
        [_infoView addSubview:colorLabel];
        
        UILabel *wordlabel = [[UILabel alloc] init];
        wordlabel.font = [UIFont systemFontOfSize:12.0f];
        wordlabel.text = [NSString stringWithFormat:@"康师傅:%%111"];
        //        wordlabel.backgroundColor = [UIColor greenColor];
        CGFloat wordWidth = [wordlabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f]} context:nil].size.width;
        
        
        _infoLabelWidth = colorLabelWidth + wordWidth;
        if (CGRectGetMaxX(_lastLabelFrame) + 5 + wordWidth + colorLabelWidth <= _infoView.width) {
            colorLabel.frame = CGRectMake(CGRectGetMaxX(_lastLabelFrame) + 5, _lastLabelFrame.origin.y, colorLabelWidth, colorLabelWidth);
            wordlabel.frame = CGRectMake(colorLabel.maxX, colorLabel.y,wordWidth, 15);
        }else{
            colorLabel.frame = CGRectMake(5, CGRectGetMaxY(_lastLabelFrame) + 7.5, colorLabelWidth, colorLabelWidth);
            wordlabel.frame = CGRectMake(colorLabel.maxX, colorLabel.y,wordWidth, 15);
            _lineCount  = _lineCount + 1;
        }
        _lastLabelFrame = wordlabel.frame;

        _infoView.frame = CGRectMake(5, _pieInfoView.maxY + space, self.width - 10 , 30 * _lineCount  - 7.5f * 2);
        _count = i;
        
        
        [_infoView addSubview:wordlabel];
    }

}
- (void)setTitle:(NSString *)title
{
    _title = title;
    _categoryLabel.frame = CGRectMake(0, 10, self.width, 20);
    _categoryLabel.textAlignment = NSTextAlignmentCenter;
    _categoryLabel.text = _title;
    _categoryLabel.font = [UIFont systemFontOfSize:15.0f];
}
@end
