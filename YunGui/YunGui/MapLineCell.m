//
//  MapLineCell.m
//  YunGui
//
//  Created by HanenDev on 15/12/2.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "MapLineCell.h"
#import "UIView+Extension.h"
#import "Macro.h"
#define WIDTH self.frame.size.width

@implementation MapLineCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, WIDTH-20, 30)];
        [self.contentView addSubview:self.titleLabel];
        
        self.timeImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.titleLabel.maxY, 30, 30)];
        self.timeImage.backgroundColor=[UIColor purpleColor];
        [self.contentView addSubview:self.timeImage];
        
        self.timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.timeImage.maxX+10, self.titleLabel.maxY, 120, 30)];
        [self.contentView addSubview:self.timeLabel];
        
        self.walkImage=[[UIImageView alloc]initWithFrame:CGRectMake(self.timeLabel.maxX, self.titleLabel.maxY, 30, 30)];
        [self.contentView addSubview:self.walkImage];
        self.walkImage.backgroundColor=[UIColor purpleColor];

        self.walkLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.walkImage.maxX+10, self.titleLabel.maxY, 120, 30)];
        [self.contentView addSubview:self.walkLabel];
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
