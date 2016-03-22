//
//  selectButton.h
//  YunGui
//
//  Created by HanenDev on 15/11/13.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface selectButton : UIButton
@property(nonatomic,strong)UILabel *btnLabel;
@property(nonatomic,strong)UIImageView *btnImage;

@property(nonatomic,assign)BOOL isOpen;
@end
