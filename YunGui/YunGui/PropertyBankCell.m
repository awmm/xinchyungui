//
//  PropertyBankCell.m
//  YunGui
//
//  Created by HanenDev on 15/11/17.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "PropertyBankCell.h"
#import "UIView+Extension.h"

#define CELLWIDTH self.frame.size.width
#define LHEIGHT 35.0f

@implementation PropertyBankCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _numLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 5, CELLWIDTH-20, LHEIGHT)];
        [self.contentView addSubview:_numLabel];
        
        _bankLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, _numLabel.maxY, CELLWIDTH-20, LHEIGHT)];
        [self.contentView addSubview:_bankLabel];
        
        _bankIDLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, _bankLabel.maxY, CELLWIDTH-20, LHEIGHT)];
        [self.contentView addSubview:_bankIDLabel];
        
        _typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, _bankIDLabel.maxY, CELLWIDTH-20, LHEIGHT)];
        [self.contentView addSubview:_typeLabel];
        
        _addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, _typeLabel.maxY, CELLWIDTH-20, LHEIGHT)];
        [self.contentView addSubview:_addressLabel];
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
