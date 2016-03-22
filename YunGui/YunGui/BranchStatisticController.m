//
//  BranchStatisticController.m
//  YunGui
//
//  Created by Hanen 3G 01 on 15/11/17.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "BranchStatisticController.h"
#import "SettingButton.h"
#import "UIView+Extension.h"
#import "InfoView.h"
#import "Macro.h"
#import "IRevealControllerProperty.h"

#define topHeight 40.0f //顶部的高度
#define labelWidth 100.0f //所属地区label宽度
#define TopBtnWidth (self.view.width - labelWidth) / 2 //除去label后按钮的平均宽度
#define btnSpace 29.0f //按钮间距离

@interface BranchStatisticController ()<IRevealControllerProperty,UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIView         *_topView;
    
    //所属地区label
    UILabel        *_AffiliationRegion;
    
    //城市选择
    SettingButton  *_cityChoice;
    //地区选择
    SettingButton  *_regionChoice;
    
    UIScrollView   *_scrollView;
    
    UIPageControl  *_pageController;
    
    UIView         *_infoView;
    
    NSArray        *_titleArray;
    
    //显示地区的tableView
    UITableView    *_tableView;
    
    //记录上次点击的按钮
    SettingButton  *_lastSeleted;
    
    //盖板
    UIView         *_coverView;

    
    UIPickerView     *_cityPickView;
    UIView          *_backView;
    UIButton        *_sureBtn;
    UIButton        *_cancleBtn;

}

@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSArray *selectedArray;
@end

@implementation BranchStatisticController

@synthesize revealController;

- (void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [ViewTool setNavigationBar:self.navigationController.navigationBar];
    _titleArray = @[@"竞争对手统计",@"评级统计",@"拜访统计",@"签约统计"];
    self.navigationItem.title = @"网点统计";
    self.view.backgroundColor = [UIColor whiteColor];
    [self getPickerData];
    [self creatUI];
}

#pragma mark-- 布局
- (void)creatUI
{
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, topHeight)];
    [self.view addSubview:_topView];
    
    //所属地区
    _AffiliationRegion = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, topHeight)];
    
    _AffiliationRegion.text = @"所属地区";
    _AffiliationRegion.textColor = [UIColor blackColor];
    _AffiliationRegion.font = [UIFont systemFontOfSize:15.0f];
    _AffiliationRegion.textAlignment = NSTextAlignmentCenter;
    
    [_topView addSubview:_AffiliationRegion];
    
    _cityChoice = [[SettingButton alloc] initWithFrame:CGRectMake(_AffiliationRegion.maxX , _AffiliationRegion.y + 5, TopBtnWidth - btnSpace, topHeight - 10)];
    _cityChoice.tag = 998;
    _lastSeleted = _cityChoice;
    _cityChoice.titleLabel.adjustsFontSizeToFitWidth = YES;

    [_cityChoice addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cityChoice setTitle:@"上海" forState:UIControlStateNormal];
    [_cityChoice setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _cityChoice.isSelected = NO;
    
//    _cityChoice.backgroundColor = [UIColor lightGrayColor];

    [_topView addSubview:_cityChoice];
    
    
    _regionChoice = [[SettingButton alloc] initWithFrame:CGRectMake( _cityChoice.maxX + btnSpace + 1, _cityChoice.y, _cityChoice.width, _cityChoice.height)];
    _regionChoice.tag = 997;
    _regionChoice.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_regionChoice addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_regionChoice setTitle:@"全部" forState:UIControlStateNormal];
    [_regionChoice setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    _regionChoice.backgroundColor = [UIColor lightGrayColor];
    _regionChoice.isSelected = NO;

    [_topView addSubview:_regionChoice];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topView.maxY , self.view.width, self.view.height - _topView.maxY)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.backgroundColor = [UIColor orangeColor];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i < 4; i++) {
        InfoView *info = [[InfoView alloc] initWithFrame:CGRectMake(self.view.width * i, 0, _scrollView.width, _scrollView.height)];
        info.title = _titleArray[i];
//        NSLog(@"==%@",NSStringFromCGRect(info.frame));
        info.array = @[@20,@10,@10,@10,@10,@10,@30];
        [_scrollView addSubview:info];
//        info.backgroundColor = [UIColor redColor];
     
    }
    CGFloat space;
    if (self.view.width > 322) {
        space = 50;
    }else{
        space = 25;
    }
    _pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.width / 2.0f - 40, self.view.height - space, 80, 20)];
    _pageController.numberOfPages = _titleArray.count;
    _pageController.selected = 0;
    _pageController.alpha = 0.7;
    _pageController.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageController.currentPageIndicatorTintColor = [UIColor cyanColor];
    [self.view addSubview:_pageController];
    

    _scrollView.contentSize = CGSizeMake(self.view.width * 4, 0);
    [self creatCityPickView];
//     [self creatTableView];
}
- (void)getPickerData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.provinceArray = [self.pickerDic allKeys];
    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
    
    if (self.selectedArray.count > 0) {
        self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
    }
    
    if (self.cityArray.count > 0) {
        self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
    }
    
}
- (void)creatCityPickView
{
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height, kScreenWidth, 30)];
    _backView.alpha = 0;
    _backView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
    
    _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 45, 5, 40, 20)];
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(sureChoice) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [_backView addSubview:_sureBtn];
    
    _cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 20)];
    _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_cancleBtn addTarget:self action:@selector(cancleChioce) forControlEvents:UIControlEventTouchUpInside];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [_backView addSubview:_cancleBtn];
    
    _cityPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.height + 40, kScreenWidth, 180)];
    _cityPickView.delegate = self;
    _cityPickView.dataSource = self;
    _cityPickView.alpha = 0;
    _cityPickView.backgroundColor = [UIColor whiteColor];
//    _cityPickView.layer.borderWidth = 1;
//    _cityPickView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //    _cityPickView.layer.cornerRadius = 5;
    
    
    //    [_pickView addSubview:_backView];
    //    [_pickView addSubview:_cityPickView];
    [self.view addSubview:_cityPickView];
    [self.view addSubview:_backView];
}

//- (void)creatTableView
//{
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(_cityChoice.x, _AffiliationRegion.maxY + 64, _cityChoice.width, 100) style:UITableViewStyleGrouped];
//    _tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _tableView.layer.borderWidth = 1.0f;
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    _tableView.alpha = 0;
//    _tableView.contentInset = UIEdgeInsetsMake(-35, 0, -37, 0);
//    [self.view addSubview:_tableView];
//}
#pragma mark -选择地区按钮
- (void)BtnClick:(SettingButton *)btn
{
    if (btn.isSelected == NO) {
        [_cityPickView reloadAllComponents];
        [UIView animateWithDuration:0.5 animations:^{
            _backView.alpha = 0.6;
            _cityPickView.alpha = 0.6;
            _backView.frame = CGRectMake(0, self.view.height - 220, kScreenWidth , 40);
            _cityPickView.frame = CGRectMake(0, self.view.height - 180, kScreenWidth , 180);
        }completion:^(BOOL finished) {
            _cityPickView.alpha = 1;
            _backView.alpha = 1;
        }];
        btn.isSelected = YES;
        _regionChoice.isSelected = YES;
        _cityChoice.isSelected = YES;
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            _backView.alpha = 0.4;
            _cityPickView.alpha = 0.4;
            _backView.frame = CGRectMake(0, self.view.height, kScreenWidth , 40);
            _cityPickView.frame = CGRectMake(0, self.view.height + 40, kScreenWidth , 180);
        }completion:^(BOOL finished) {
            _cityPickView.alpha = 0;
            _backView.alpha = 0;
        }];
        btn.isSelected = NO;
        _regionChoice.isSelected = NO;
        _cityChoice.isSelected = NO;
    }

//    if (_tableView.alpha == 0) {
//        [self addCoverView];
//    }
//    if (btn == _lastSeleted) {
//        if (btn.tag == 998) {
//            if (btn.isSelected == NO) {
//               
//                [_tableView reloadData];
//                [UIView animateWithDuration:0.25 animations:^{
//                   _tableView.frame = CGRectMake(btn.x, btn.maxY + 64, btn.width, 100);
//                } completion:^(BOOL finished) {
//                    _tableView.alpha = 1;
//                    
//                }];
//                btn.isSelected = YES;
//            }else{
//                [_tableView reloadData];
//                [UIView animateWithDuration:0.25 animations:^{
//                   _tableView.frame = CGRectMake(btn.x,btn.maxY + 64, btn.width, 0);
//                } completion:^(BOOL finished) {
//                    _tableView.alpha = 0;
//                    
//                }];
//                btn.isSelected = NO;
//                [self hideCoverView];
//            }
//        } else if (btn.tag == 997) {
//            if (btn.isSelected == NO) {
//                
//                [_tableView reloadData];
//                [UIView animateWithDuration:0.25 animations:^{
//                    _tableView.frame = CGRectMake(btn.x, btn.maxY + 64, btn.width, 100);
//                } completion:^(BOOL finished) {
//                    _tableView.alpha = 1;
//                    
//                }];
//                btn.isSelected = YES;
//            }else{
//                [_tableView reloadData];
//                [UIView animateWithDuration:0.25 animations:^{
//                    _tableView.frame = CGRectMake(btn.x,btn.maxY + 64, btn.width, 0);
//                } completion:^(BOOL finished) {
//                    _tableView.alpha = 0;
//                }];
//                btn.isSelected = NO;
//                [self hideCoverView];
//            }
//        }
//    }else{
////        _tableView.alpha = 0;
//        _lastSeleted.isSelected = NO;
//        
//        if (btn.tag == 998) {
//            [_tableView reloadData];
//            _tableView.alpha = 0;
//            if (btn.isSelected == NO) {
//                [UIView animateWithDuration:0.2 animations:^{
//                    _tableView.frame = CGRectMake(btn.x, btn.maxY + 64, btn.width, 100);
//                } completion:^(BOOL finished) {
//                    _tableView.alpha = 1;
//                }];
//                btn.isSelected = YES;
//            }else{
//                [_tableView reloadData];
//                [UIView animateWithDuration:0.2 animations:^{
//                    _tableView.alpha = 0;
//                    _tableView.frame = CGRectMake(btn.x, btn.maxY + 64, btn.width, 0);
//                }];
//                
//                btn.isSelected = NO;
//            }
//        } else if (btn.tag == 997) {
//            if (!_coverView) {
//                [self addCoverView];
//            }
//            [_tableView reloadData];
//            _tableView.alpha = 0;
//            if (btn.isSelected == NO) {
//                [UIView animateWithDuration:0.2 animations:^{
//                   _tableView.frame = CGRectMake(btn.x, btn.maxY + 64, btn.width, 100);
//                } completion:^(BOOL finished) {
//                    _tableView.alpha = 1;
//                }];
//                btn.isSelected = YES;
//            }else{
//                [_tableView reloadData];
//                [UIView animateWithDuration:0.2 animations:^{
//                    _tableView.alpha = 0;
//                    _tableView.frame = CGRectMake(btn.x, btn.maxY + 64, btn.width, 0);
//                }];
//                
//                btn.isSelected = NO;
//            }
//        }
//    }
//    NSLog(@"========%@",_lastSeleted.currentTitle);
//    _lastSeleted = btn;
}


- (void)sureChoice
{
    [self hidePickViewWithSureClick:YES];
}
//点击取消按钮
- (void)cancleChioce
{
    [self hidePickViewWithSureClick:NO];
}
- (void)hidePickViewWithSureClick:(BOOL)isSure
{        //isSure 点击确定
        if (isSure) {
            _cityChoice.isSelected = NO;
            [_cityChoice setTitle:[self.provinceArray objectAtIndex:[_cityPickView selectedRowInComponent:0]] forState:UIControlStateNormal];
            
            _regionChoice.isSelected = NO;
            [_regionChoice setTitle:[self.cityArray objectAtIndex:[_cityPickView selectedRowInComponent:1]] forState:UIControlStateNormal];
           
            [UIView animateWithDuration:0.5 animations:^{
                _backView.alpha = 0.4;
                _cityPickView.alpha = 0.4;
                _backView.frame = CGRectMake(0, self.view.height, kScreenWidth , 40);
                _cityPickView.frame = CGRectMake(0, self.view.height + 40, kScreenWidth , 180);
            }completion:^(BOOL finished) {
                _cityPickView.alpha = 0;
                _backView.alpha = 0;
            }];
        }else{
            _cityChoice.isSelected = NO;
            _regionChoice.isSelected = NO;
            
            [UIView animateWithDuration:0.5 animations:^{
                _backView.alpha = 0.4;
                _cityPickView.alpha = 0.4;
                _backView.frame = CGRectMake(0, self.view.height, kScreenWidth , 40);
                _cityPickView.frame = CGRectMake(0, self.view.height + 40, kScreenWidth , 180);
            }completion:^(BOOL finished) {
                _cityPickView.alpha = 0;
                _backView.alpha = 0;
            }];
        }
}
//
//- (void)addCoverView
//{
//    _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, _AffiliationRegion.maxY + 64, kScreenWidth , kScreenHeight - _AffiliationRegion.maxY + 64 )];
//    _coverView.backgroundColor = [UIColor brownColor];
//    _coverView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
//    [_coverView addGestureRecognizer:tap];
//    [self.view insertSubview:_coverView belowSubview:_tableView];
//}
//- (void)hideCoverView
//{
//    [_coverView removeFromSuperview];
//}
//- (void)handleTap
//{
//    
//    for(int i = 0; i < 2 ; i ++){
//        SettingButton *btn = [self.view viewWithTag:997 + i];
//        if (btn.x == _tableView.x ) {
//            _tableView.alpha = 0;
//            btn.isSelected = NO;
//            [_coverView removeFromSuperview];
//        }
//    }
//    SettingButton *btn1 = [_scrollView viewWithTag:1221];
//    btn1.isSelected = NO;
//    _tableView.alpha = 0;
//    [_coverView removeFromSuperview];
//}
//#pragma mark --tableview代理方法
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 10;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *staticString = @"staticString";
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:staticString];
//    cell.textLabel.text = @"China";
//    return cell;
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    for(int i = 0; i < 2 ; i ++){
//        SettingButton *btn = [self.view viewWithTag:997 + i];
//        if (btn.x == tableView.x) {
//            [btn setTitle:@"南京" forState:UIControlStateNormal];
//            tableView.alpha = 0;
//            btn.isSelected = NO;
//            [_coverView removeFromSuperview];
//        }
//    }
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 30.0f;
//}

#pragma mark -- pickView代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    }
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
        if (component == 0) {
            return [self.provinceArray objectAtIndex:row];
        } else if (component == 1) {
            return [self.cityArray objectAtIndex:row];
        } else {
            return [self.townArray objectAtIndex:row];
        }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
        if (component == 0) {
            return 110;
        } else if (component == 1) {
            return 100;
        } else {
            return 0;
        }
}
    //    return self.view.width / 3.0f;

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
            self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:row]];
            if (self.selectedArray.count > 0) {
                self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
            } else {
                self.cityArray = nil;
            }
//            if (self.cityArray.count > 0) {
//                self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
//            } else {
//                self.townArray = nil;
//            }
        }
        [pickerView selectedRowInComponent:1];
        [pickerView reloadComponent:1];

}


#pragma mark --scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat index = scrollView.contentOffset.x / self.view.width;
    _pageController.currentPage = index;
}

// 拉开左侧:点击.
- (void)sideLeftButton_selector:(id)sender {
    
    [self.revealController toggleSidebar:!self.revealController.sidebarShowing duration:kGHRevealSidebarDefaultAnimationDuration];
}
@end
