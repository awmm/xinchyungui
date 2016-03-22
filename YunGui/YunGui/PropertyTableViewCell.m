//
//  PropertyTableViewCell.m
//  YunGui
//
//  Created by HanenDev on 15/11/17.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "PropertyTableViewCell.h"
#import "UIView+Extension.h"
#define LHEIGHT 40.0f
#define FONT(font) [UIFont systemFontOfSize:font];


@implementation PropertyTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.zhangHuLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 5, 70, LHEIGHT)];
        self.zhangHuLabel.text=@"我的账户:";
        self.zhangHuLabel.font= FONT(16.0f)
        [self.contentView addSubview:self.zhangHuLabel];
        
        self.numLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.zhangHuLabel.maxX, 5, self.frame.size.width-40-20, LHEIGHT)];
        self.numLabel.backgroundColor=[UIColor lightGrayColor];
        self.numLabel.font=FONT(16.0f)
        [self.contentView addSubview:self.numLabel];
        
        self.bankLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.zhangHuLabel.maxX, self.numLabel.maxY, self.frame.size.width-40-20, LHEIGHT)];
        self.bankLabel.backgroundColor=[UIColor lightGrayColor];
        self.bankLabel.font=FONT(16.0f)
        [self.contentView addSubview:self.bankLabel];
        
        self.bankIDLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.zhangHuLabel.maxX, self.bankLabel.maxY, self.frame.size.width-40-20, LHEIGHT)];
        self.bankIDLabel.backgroundColor=[UIColor lightGrayColor];
        self.bankIDLabel.font=FONT(16.0f)
        [self.contentView addSubview:self.bankIDLabel];
        
        self.typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.zhangHuLabel.maxX, self.bankIDLabel.maxY, self.frame.size.width-40-20, LHEIGHT)];
        self.typeLabel.backgroundColor=[UIColor lightGrayColor];
        self.typeLabel.font=FONT(16.0f)
        [self.contentView addSubview:self.typeLabel];
        
        self.addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.zhangHuLabel.maxX, self.typeLabel.maxY, self.frame.size.width-40-20, 60)];
        self.addressLabel.backgroundColor=[UIColor lightGrayColor];
        self.addressLabel.font=FONT(16.0f)
        [self.contentView addSubview:self.addressLabel];

    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
