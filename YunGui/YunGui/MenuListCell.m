//
//  MenuListCell.m
//  YunGui
//
//  Created by wmm on 15/11/6.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "MenuListCell.h"

@implementation MenuListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];

        self.imageView.frame = CGRectMake([UIView getWidth:30.0f], [UIView getHeight:10.0f], 20.0f, 20.0f);
//        self.imageView.contentMode = UIViewContentModeCenter;
//        self.imageView.backgroundColor = [UIColor blackColor];

        self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:([UIFont systemFontSize] * 1.2f)];
        self.textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        self.textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
        self.textLabel.textColor = [UIColor colorWithRed:(196.0f/255.0f) green:(204.0f/255.0f) blue:(218.0f/255.0f) alpha:1.0f];
        

        self.leftLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIView getWidth:3.0f], [UIView getHeight:40.0f])];
        self.leftLine.backgroundColor = YELLOWCOLOR;
        self.leftLine.hidden = YES;
        
        UIView *bottomLine = [ViewTool getLineViewWith:CGRectMake([UIView getWidth:30.0f], [UIView getHeight:40.0f]-1.0f, [UIScreen mainScreen].bounds.size.height, 1.0f) withBackgroudColor:[UIColor colorWithRed:(40.0f/255.0f) green:(47.0f/255.0f) blue:(61.0f/255.0f) alpha:1.0f]];

        [self.textLabel.superview addSubview:self.leftLine];
        [self.textLabel.superview addSubview:bottomLine];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if(selected){
        self.textLabel.textColor = YELLOWCOLOR;
        self.leftLine.hidden = NO;
        self.imageView.image = self.selectedImage;
    }else{
        self.textLabel.textColor = [UIColor whiteColor];
        self.leftLine.hidden = YES;
        self.imageView.image = self.defaultImage;
    }

    
    // Configure the view for the selected state
}

#pragma mark - property



#pragma mark - method


#pragma mark - UIView
- (void)layoutSubviews {
    [super layoutSubviews];

    self.imageView.frame = CGRectMake([UIView getWidth:30.0f], [UIView getHeight:10.0f], [UIView getWidth:20.0f], [UIView getWidth:20.0f]);
    self.textLabel.frame = CGRectMake([UIView getWidth:60.0f], [UIView getHeight:10.0f], self.width - [UIView getWidth:50.0f], [UIView getWidth:20.0f]);

}

#pragma mark - events

@end
