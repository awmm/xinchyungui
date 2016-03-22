//
//  VisitListCell.m
//  YunGui
//
//  Created by wmm on 15/11/14.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "VisitListCell.h"
#import "Macro.h"

#define LeftWidth [UIView getWidth:20.0f]
#define CellHeight [UIView getWidth:80.0f]

@implementation VisitListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        
        //选中单元格
//        UIView *bgView = [[UIView alloc] init];
//        bgView.backgroundColor = [UIColor colorWithRed:(20.0f/255.0f) green:(30.0f/255.0f) blue:(40.0f/255.0f) alpha:0.5f];
//        self.selectedBackgroundView = bgView;
        
        UIView *leftLine1 = [[UIView alloc] initWithFrame:CGRectMake(LeftWidth, 0.0f, [UIView getWidth:5.0f], [UIView getHeight:10.0f])];
        leftLine1.backgroundColor = [UIColor grayColor];
        
        UIImageView *quanImg = [[UIImageView alloc] initWithFrame:CGRectMake(LeftWidth, leftLine1.maxY+[UIView getHeight:1.0f], [UIView getWidth:5.0f], [UIView getWidth:5.0f])];
        quanImg.image = [UIImage imageNamed:@"RadioButton-Unselected.png"];

        UIView *leftLine2 = [[UIView alloc] initWithFrame:CGRectMake(LeftWidth, quanImg.maxY+[UIView getHeight:1.0f], [UIView getWidth:5.0f], CellHeight-quanImg.maxY-[UIView getHeight:1.0f])];
        leftLine2.backgroundColor = [UIColor grayColor];
        
        CGRect visitNumFrame = CGRectMake(leftLine2.maxX+[UIView getWidth:10.0f], leftLine1.maxY+[UIView getHeight:1.0f], kScreenWidth, [UIView getHeight:15.0f]);
        self.visitNum = [[UILabel alloc] initWithFrame:visitNumFrame];
        [ViewTool setLabelFont:self.visitNum];
        
        CGRect visitSubFrame = CGRectMake(visitNumFrame.origin.x, self.visitNum.maxY+[UIView getHeight:3.0f], kScreenWidth, [UIView getHeight:15.0f]);
        self.visitSub = [[UILabel alloc] initWithFrame:visitSubFrame];
        [ViewTool setLabelFont:self.visitSub];
        
        UIImageView *proImg = [[UIImageView alloc] initWithFrame:CGRectMake(visitNumFrame.origin.x, self.visitSub.maxY+[UIView getHeight:8.0f], [UIView getHeight:20.0f], [UIView getHeight:20.0f])];
        proImg.image = [UIImage imageNamed:@"user.png"];
        
        
        CGRect visitProFrame = CGRectMake(proImg.maxX+[UIView getWidth:10.0f],self.visitSub.maxY+[UIView getHeight:8.0f], kScreenWidth/2, [UIView getHeight:20.0f]);
        self.visitPro = [[UILabel alloc] initWithFrame:visitProFrame];
        [ViewTool setLabelFont:self.visitPro];
        
        CGRect visitDateFrame = CGRectMake(self.visitPro.maxX+[UIView getHeight:2.0f], self.visitSub.maxY+[UIView getHeight:8.0f], kScreenWidth-self.visitPro.maxX-[UIView getHeight:2.0f]-LeftWidth, [UIView getHeight:20.0f]);
        self.visitDate = [[UILabel alloc] initWithFrame:visitDateFrame];
        [ViewTool setLabelFont:self.visitDate];
        self.visitDate.textAlignment=NSTextAlignmentRight;
        
        [self.contentView addSubview:leftLine1];
        [self.contentView addSubview:quanImg];
        [self.contentView addSubview:leftLine2];
        
        [self.contentView addSubview:self.visitNum];
        [self.contentView addSubview:self.visitSub];
        [self.contentView addSubview:proImg];
        [self.contentView addSubview:self.visitPro];
        [self.contentView addSubview:self.visitDate];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
