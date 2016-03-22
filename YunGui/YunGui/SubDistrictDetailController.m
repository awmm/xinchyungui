//
//  SubDistrictDetailController.m
//  YunGui
//
//  Created by Hanen 3G 01 on 15/11/13.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "SubDistrictDetailController.h"
#import "UIView+Extension.h"


#define labelHeight  50.0f

@interface SubDistrictDetailController ()
{
    NSArray       *_titleArray;
    
    UIScrollView  *_scrollView;
    
    UILabel       *_lastLabel;
}


@end

@implementation SubDistrictDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [ViewTool setNavigationBar:self.navigationController.navigationBar];
    self.navigationItem.title = @"小区详情";
    _titleArray = @[@"小区名称:",@"所属地区:",@"地址:",@"小区类型:",@"物业公司:",@"当前户数:",@"交付时间:",@"负责人:",@"等级:",@"竞争对手:"];
    
    [self creatUI];
}
//自定义的leftBarButton
- (UIBarButtonItem *)changeBarButtonWithImageName:(NSString *)imageName
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return barItem;
}
- (void)creatUI
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i < _titleArray.count;i ++) {
        CGFloat width = [_titleArray[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, labelHeight) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName : [UIColor blackColor]} context:nil].size.width;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 64 + labelHeight * i, width, labelHeight)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15.0f];
        label.text = _titleArray[i];
        [_scrollView addSubview:label];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, labelHeight * i + 64, self.view.frame.size.width - 75, labelHeight)];
        contentLabel.tag = 333 + i;
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.text = @"额额额额额额额";
        contentLabel.font = [UIFont systemFontOfSize:15.0f];
//        contentLabel.backgroundColor = [UIColor brownColor];
         [_scrollView addSubview:contentLabel];
        
        if (i == _titleArray.count - 1) {
            _lastLabel = contentLabel;
        }  
    }
    
    
    _scrollView.contentSize = CGSizeMake(0, _lastLabel.maxY);
}
//给contentLabel赋值 利用tag



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
