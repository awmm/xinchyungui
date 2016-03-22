//
//  NewDistrictController.m
//  YunGui
//
//  Created by Hanen 3G 01 on 15/11/13.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "NewDistrictController.h"
#import "UIView+Extension.h"
#import "BranchStatisticController.h"
#import "SettingButton.h"
#import "SearchProperty.h"
#import "Macro.h"


#define labelHeight  50.0f
#define TextFieldHeight 30.0f

#define space 5.0f

@interface NewDistrictController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,SearchPropertyDelegate>
{
    NSArray          *_titleArray;
    
    //整体放在一个scrollView上
    UIScrollView     *_scrollView;
    
    UILabel          *_lastLabel;
    
    UITableView      *_tableView;
    
    //记录第一个选择点击穿件tableView的位置 根据btn的位置来
    SettingButton    *_getBtn;
    
    //
    SettingButton    *_lastClickBtn;
    
  
    
    //盖板1
    UIView           *_coverView;
    //盖板2
    UIView           *_coverVie;
    
    //小区类型的选择
    UITableView     *_SubDistrictChoice;
    
    UITableView     *_responsibleChoice;
    
    UITableView     *_gradeChoice;
    
    UIPickerView     *_cityPickView;
    UIView          *_backView;
    UIButton        *_sureBtn;
    UIButton        *_cancleBtn;
    
    BOOL             _isDistrct;
}
//data
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSArray *selectedArray;
@end

@implementation NewDistrictController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [ViewTool setNavigationBar:self.navigationController.navigationBar];
    self.navigationItem.title = @"创建小区";
    self.view.backgroundColor = [UIColor whiteColor];
    _titleArray = @[@"小区名称:",@"所属地区:",@"地址:",@"小区类型:",@"物业公司:",@"当前户数:",@"总户数:",@"交付时间:",@"负责人:",@"等级:",@"竞争对手:"];
    _isDistrct = NO;
    UIButton *subMitte = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [subMitte setTitle:@"提交" forState:UIControlStateNormal];
    [subMitte setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [subMitte addTarget:self action:@selector(subMitInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:subMitte],negativeSpacer];
    
    [self getPickerData];
    [self creatScrollView];
    [self creatUI];
}
- (void)creatScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.view addSubview:_scrollView];
}

//创建视图
- (void)creatUI
{
    for (int i = 0; i < _titleArray.count;i ++) {
        CGFloat width = [_titleArray[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, labelHeight) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName : [UIColor blackColor]} context:nil].size.width;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 64 + labelHeight * i, width, labelHeight)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15.0f];
        label.text = _titleArray[i];
        [_scrollView addSubview:label];
        
        if (i == 0 || i == 2 ||i == 5 || i == 6 || i == 7 ) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(75, label.y + 10 , 150, TextFieldHeight)];
            textField.borderStyle = UITextBorderStyleLine;
            textField.layer.borderWidth = .5;
            textField.tag = 1300 + i;
            textField.delegate = self;
            textField.returnKeyType = UIReturnKeyDone;
            [_scrollView addSubview:textField];
        }
        
        if (i == _titleArray.count - 1) {
            _lastLabel = label;
        }
        //所属地区
        if (i == 1) {
            NSArray *arr = @[@"按钮1",@"按钮2",@"按钮3"];
            CGFloat btnWidth = (self.view.size.width - 3 * space - 75 - 30) / 3;
            for (int i = 0; i < 3; i ++) {
                SettingButton *btn = [[SettingButton alloc] initWithFrame:CGRectMake(75 + (btnWidth + space) * i, label.y + 10, btnWidth, TextFieldHeight)];
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn.titleLabel.adjustsFontSizeToFitWidth = YES;
//                btn.backgroundColor = [UIColor lightGrayColor];
                btn.isSelected = NO;
                btn.tag = 1200 + i;
                [btn setTitle:arr[i] forState:UIControlStateNormal];
                 [_scrollView addSubview:btn];
                if (i == 0) {
                    _getBtn = btn;
                    _lastClickBtn = btn;
                    _lastClickBtn.isSelected = NO;
                }
            }
           
//            [self creatTableViewWith:_getBtn];
//            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(_getBtn.x, _getBtn.maxY, _getBtn.width, 70) style:UITableViewStyleGrouped];
//            NSLog(@"%@",NSStringFromCGRect(_getBtn.frame));
//            _tableView.delegate = self;
//            _tableView.dataSource = self;
//            _tableView.alpha = 0;
//            _tableView.contentInset = UIEdgeInsetsMake(- _getBtn.height - 5, 0, - _getBtn.height - 6, 0);
            
//            _tableView.backgroundColor = [UIColor orangeColor];
        }
        //小区类型
        if(i == 3){
            SettingButton * btn = [[SettingButton alloc] initWithFrame:CGRectMake(75, label.y + 10, 150, TextFieldHeight)];
            btn.titleLabel.text = @"小区/封闭";
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.adjustsFontSizeToFitWidth = YES;
//            btn.backgroundColor = [UIColor lightGrayColor];
            btn.isSelected = NO;
            btn.tag = 1221;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:btn];
            
//            _SubDistrictChoice = [[UITableView alloc] initWithFrame:CGRectMake(btn.x, btn.maxY, btn.width, 80) style:UITableViewStyleGrouped];
//      
//            _SubDistrictChoice.delegate = self;
//            _SubDistrictChoice.dataSource = self;
//            _SubDistrictChoice.alpha = 0;
//            _SubDistrictChoice.contentInset = UIEdgeInsetsMake(- btn.height - 5, 0, - btn.height - 5, 0);
//            
//            _SubDistrictChoice.backgroundColor = [UIColor orangeColor];
          
        }
        //搜索物业
        if (i == 4) {
            UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(75, label.y + 10, 150, TextFieldHeight)];
            searchField.placeholder = @"搜索物业";
            searchField.delegate = self;
            searchField.tag = 1222;
            searchField.borderStyle = UITextBorderStyleLine;
            searchField.returnKeyType = UIReturnKeySearch;
            searchField.layer.cornerRadius = 15.0f;
            searchField.layer.borderWidth = 1;
            searchField.layer.masksToBounds = YES;
            [_scrollView addSubview:searchField];
        }
        
//        [_scrollView addSubview:_SubDistrictChoice];
        
        //先添加小区类型的button 避免先创建的_tabeView被盖住了
//        [_scrollView addSubview:_tableView];
        
        //负责人
        if (i == 8) {
            SettingButton * btn = [[SettingButton alloc] initWithFrame:CGRectMake(75, label.y + 10, 150, TextFieldHeight)];
            btn.titleLabel.text = @"请选择负责人";
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

//            btn.backgroundColor = [UIColor lightGrayColor];
            btn.isSelected = NO;
            btn.tag = 1233;
            [btn addTarget:self action:@selector(handleDistrictBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:btn];
            
            _responsibleChoice = [[UITableView alloc] initWithFrame:CGRectMake(btn.x, btn.maxY, btn.width, 80) style:UITableViewStylePlain];
            
            _responsibleChoice.delegate = self;
            _responsibleChoice.dataSource = self;
            _responsibleChoice.alpha = 0;
//            _responsibleChoice.contentInset = UIEdgeInsetsMake(- btn.height - 5, 0, - btn.height - 5, 0);
            
            _responsibleChoice.backgroundColor = [UIColor orangeColor];
            
        }
        //等级
        if (i == 9) {
            SettingButton * btn = [[SettingButton alloc] initWithFrame:CGRectMake(75, label.y + 10, 150, TextFieldHeight)];
            btn.titleLabel.text = @"选择等级";
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

//            btn.backgroundColor = [UIColor lightGrayColor];
            btn.isSelected = NO;
            btn.tag = 1234;
            [btn addTarget:self action:@selector(handleDistrictBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:btn];
            
            _gradeChoice = [[UITableView alloc] initWithFrame:CGRectMake(btn.x, btn.maxY, btn.width, 80) style:UITableViewStylePlain];
            
            _gradeChoice.delegate = self;
            _gradeChoice.dataSource = self;
            _gradeChoice.alpha = 0;
//            _gradeChoice.contentInset = UIEdgeInsetsMake(- btn.height - 5, 0, - btn.height - 5, 0);
            
            _gradeChoice.backgroundColor = [UIColor orangeColor];
            [_scrollView addSubview:_gradeChoice];
            [_scrollView addSubview:_responsibleChoice];
        }
    }
    
    _scrollView.contentSize = CGSizeMake(0, _lastLabel.maxY + 20);
    
     [self creatCityPickView];
   
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

#pragma mark - get data 从plist文件读出省市
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
#pragma mark -- 省市级联的pickView 确定 取消按钮点击
//点击确定按钮选择省市
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
{
    if(!_isDistrct){
        //isSure 点击确定
        if (isSure) {
            SettingButton *provinceBtn = [_scrollView viewWithTag:1200];
            provinceBtn.isSelected = NO;
            [provinceBtn setTitle:[self.provinceArray objectAtIndex:[_cityPickView selectedRowInComponent:0]] forState:UIControlStateNormal];
            
            SettingButton *cityBtn = [_scrollView viewWithTag:1201];
            cityBtn.isSelected = NO;
            [cityBtn setTitle:[self.cityArray objectAtIndex:[_cityPickView selectedRowInComponent:1]] forState:UIControlStateNormal];
            SettingButton *townBtn = [_scrollView viewWithTag:1202];
            townBtn.isSelected = NO;
            [townBtn setTitle:[self.townArray objectAtIndex:[_cityPickView selectedRowInComponent:2]] forState:UIControlStateNormal];
            
            
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
            SettingButton *provinceBtn = [_scrollView viewWithTag:1200];
            provinceBtn.isSelected = NO;
            SettingButton *cityBtn = [_scrollView viewWithTag:1201];
            cityBtn.isSelected = NO;
            SettingButton *townBtn = [_scrollView viewWithTag:1202];
            townBtn.isSelected = NO;
            
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
    }else{
        if (isSure) {
            SettingButton *distractBtn = [_scrollView viewWithTag:1221];
            distractBtn.isSelected = NO;
            [distractBtn setTitle:@"小区" forState:UIControlStateNormal];
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
            SettingButton *distractBtn = [_scrollView viewWithTag:1221];
            distractBtn.isSelected = NO;
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
}

//点击所属地区的按钮
- (void)btnClick:(SettingButton *)btn
{
    if (btn.tag == 1221) {
        _isDistrct = YES;
    }else{
        _isDistrct = NO;
    }
    if(_cityPickView.y > self.view.height - 180){
        for (int i =0 ; i < 3; i ++) {
            SettingButton *setBtn = [_scrollView viewWithTag:1200 + i];
            setBtn.isSelected = NO;
        }
        SettingButton *findSuDistractbtn = [_scrollView viewWithTag:1221];
        findSuDistractbtn.isSelected = NO;
    }else{
        for (int i =0 ; i < 3; i ++) {
            SettingButton *setBtn = [_scrollView viewWithTag:1200 + i];
            setBtn.isSelected = YES;
        }
        SettingButton *findSuDistractbtn = [_scrollView viewWithTag:1221];
        findSuDistractbtn.isSelected = YES;
    }
    
        if (btn.isSelected == NO) {
            [_cityPickView reloadAllComponents];
            [UIView animateWithDuration:0.5 animations:^{
                _backView.alpha = 0.4;
                _cityPickView.alpha = 0.4;
                _backView.frame = CGRectMake(0, self.view.height - 220, kScreenWidth , 40);
                _cityPickView.frame = CGRectMake(0, self.view.height - 180, kScreenWidth , 180);
            }completion:^(BOOL finished) {
                _cityPickView.alpha = 1;
                _backView.alpha = 1;
            }];
            btn.isSelected = YES;
            for (int i =0 ; i < 3; i ++) {
                SettingButton *setBtn = [_scrollView viewWithTag:1200 + i];
                setBtn.isSelected = YES;
            }
        }else{
            [_cityPickView reloadAllComponents];

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
            for (int i =0 ; i < 3; i ++) {
                SettingButton *setBtn = [_scrollView viewWithTag:1200 + i];
                setBtn.isSelected = NO;
            }
        }
    
    
//  //点击按钮之前取消textfield编辑
//    [self makeTextFieldEditingUnEnable];
//    
//    if (_tableView.alpha == 0) {
//        [self addCoverViewWithFrame:CGRectMake(0, btn.maxY, self.view.width, self.view.height - btn.maxY) belowView:_tableView isSubDistrict:NO];
//    }
//    
//    if (_lastClickBtn == btn) {
//        if (btn.tag - 1200 ==0) {
//            NSLog(@"0");
//            if (btn.isSelected == NO) {
//                [_tableView reloadData];
//                [UIView animateWithDuration:0.25 animations:^{
//                   _tableView.frame = CGRectMake(btn.x, btn.maxY, btn.width, 80);
//                } completion:^(BOOL finished) {
//                    _tableView.alpha = 1;
//                
//                }];
//                btn.isSelected = YES;
//            }else{
//                [_tableView reloadData];
//                [UIView animateWithDuration:0.25 animations:^{
//                      _tableView.frame = CGRectMake(btn.x, btn.maxY, btn.width, 0);
//                } completion:^(BOOL finished) {
//                    _tableView.alpha = 0;
//                  
//                }];
//                 btn.isSelected = NO;
//                [_coverView removeFromSuperview];
//                [self makeTextFieldEditingEnable];
//               
//            }
//        } else if (btn.tag - 1200 ==1) {
//       
//            if (btn.isSelected == NO) {
//                [_tableView reloadData];
//                [UIView animateWithDuration:0.25 animations:^{
//                     _tableView.frame = CGRectMake(btn.x, btn.maxY, btn.width, 80);
//                } completion:^(BOOL finished) {
//                    _tableView.alpha = 1;
//                   
//                }];
//               
//                btn.isSelected = YES;
//            }else{
//              [_tableView reloadData];
//                [UIView animateWithDuration:0.25 animations:^{
//                    _tableView.frame = CGRectMake(btn.x, btn.maxY, btn.width, 0);
//                } completion:^(BOOL finished) {
//                    _tableView.alpha = 0;
//                    
//                }];
//                [_coverView removeFromSuperview];
//                [self makeTextFieldEditingEnable];
//                btn.isSelected = NO;
//            }
//        }else if (btn.tag - 1200 ==2) {
//          [_tableView reloadData];
//            if (btn.isSelected == NO) {
//                [UIView animateWithDuration:0.25 animations:^{
//                     _tableView.frame = CGRectMake(btn.x, btn.maxY, btn.width, 80);
//                } completion:^(BOOL finished) {
//                    _tableView.alpha = 1;
//                   
//                }];
//               
//                btn.isSelected = YES;
//            }else{
//                [_tableView reloadData];
//                [UIView animateWithDuration:0.25 animations:^{
//                   _tableView.frame = CGRectMake(btn.x, btn.maxY, btn.width, 0);
//                } completion:^(BOOL finished) {
//                    _tableView.alpha = 0;
//                    
//                }];
//                [_coverView removeFromSuperview];
//                [self makeTextFieldEditingEnable];
//                btn.isSelected = NO;
//                
//            }
//        }
//    }else{
//        _tableView.alpha = 0;
//        _lastClickBtn.isSelected = NO;
//        
//        if (btn.tag - 1200 ==0) {
//           
//            [_tableView reloadData];
//            if (btn.isSelected == NO) {
//                [UIView animateWithDuration:0.25 animations:^{
//                    _tableView.frame = CGRectMake(btn.x, btn.maxY, btn.width, 80);
//                } completion:^(BOOL finished) {
//                    _tableView.alpha = 1;
//               
//                }];
//                btn.isSelected = YES;
//            }else{
//                [_tableView reloadData];
//                [UIView animateWithDuration:0.25 animations:^{
//                    _tableView.alpha = 0;
//                    _tableView.frame = CGRectMake(btn.x, btn.maxY, btn.width, 0);
//                }];
//                
//                btn.isSelected = NO;
//            }
//        } else if (btn.tag - 1200 ==1) {
//          [_tableView reloadData];
//            _tableView.alpha = 0;
//            if (btn.isSelected == NO) {
//                [UIView animateWithDuration:0.25 animations:^{
//                     _tableView.frame = CGRectMake(btn.x, btn.maxY, btn.width, 80);
//                } completion:^(BOOL finished) {
//                    _tableView.alpha = 1;
//                  
//                }];
//                btn.isSelected = YES;
//            }else{
//                [_tableView reloadData];
//                [UIView animateWithDuration:0.25 animations:^{
//                    _tableView.alpha = 0;
//                    _tableView.frame = CGRectMake(btn.x, btn.maxY, btn.width, 0);
//                }];
//             
//                btn.isSelected = NO;
//            }
//        }else if (btn.tag - 1200 ==2) {
//        [_tableView reloadData];
//            
//            if (btn.isSelected == NO) {
//                [UIView animateWithDuration:0.25 animations:^{
//                 _tableView.frame = CGRectMake(btn.x, btn.maxY, btn.width, 80);
//                } completion:^(BOOL finished) {
//                    _tableView.alpha = 1;
//                    
//                }];
//                btn.isSelected = YES;
//            }else{
//                [_tableView reloadData];
//                [UIView animateWithDuration:0.25 animations:^{
//                    _tableView.alpha = 0;
//                    _tableView.frame = CGRectMake(btn.x, btn.maxY, btn.width, 80);
//                }];
//               
//                btn.isSelected = NO;
//            }
//        }
//    }
//    NSLog(@"========%@",_lastClickBtn.currentTitle);
//    _lastClickBtn = btn;
//    
//   
    
}

//#pragma mark -创建tableView
//- (void)creatTableViewWith:(SettingButton *)btn
//{
//    
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(btn.x, btn.maxY, btn.width, 70) style:UITableViewStyleGrouped];
//    NSLog(@"%@",NSStringFromCGRect(btn.frame));
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    _tableView.alpha = 0;
//    _tableView.contentInset = UIEdgeInsetsMake(- btn.height - 5, 0, - btn.height - 6, 0);
//    _tableView.backgroundColor = [UIColor orangeColor];
//    [_scrollView addSubview:_tableView];
//}
#pragma mark --添加一个盖板
//- (void)addCoverViewWithFrame:(CGRect)rect belowView:(UIView *)view isSubDistrict:(BOOL) isSubDistrct
//{
//    if (isSubDistrct) {
//    _coverVie = [[UIView alloc] initWithFrame:rect];
//    _coverVie.backgroundColor = [UIColor brownColor];
//    _coverVie.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
//    [_coverVie addGestureRecognizer:tap];
//    [_scrollView insertSubview:_coverVie belowSubview:view];
//
//    }else{
//          _coverView = [[UIView alloc] initWithFrame:rect];
//          _coverView.backgroundColor = [UIColor brownColor];
//          _coverView.userInteractionEnabled = YES;
//          UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
//          [_coverView addGestureRecognizer:tap];
//          [_scrollView insertSubview:_coverView belowSubview:view];
//    }
//    
//}
#pragma mark -- pickView代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (!_isDistrct) {
        return 3;
    }else{
        return 1;
    }
}
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (!_isDistrct) {
        if (component == 0) {
            return self.provinceArray.count;
        } else if (component == 1) {
            return self.cityArray.count;
        } else {
            return self.townArray.count;
        }
    }else{//小区类型的
        return 5;
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(!_isDistrct){
        if (component == 0) {
            return [self.provinceArray objectAtIndex:row];
        } else if (component == 1) {
            return [self.cityArray objectAtIndex:row];
        } else {
            return [self.townArray objectAtIndex:row];
        }
    }else{
        return @"小小区";
    }
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (!_isDistrct) {
        if (component == 0) {
            return 110;
        } else if (component == 1) {
            return 100;
        } else {
            return 110;
        }
    }else{
        return self.view.width;
    }
   
//    return self.view.width / 3.0f;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (!_isDistrct) {
        if (component == 0) {
            self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:row]];
            if (self.selectedArray.count > 0) {
                self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
            } else {
                self.cityArray = nil;
            }
            if (self.cityArray.count > 0) {
                self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
            } else {
                self.townArray = nil;
            }
        }
        [pickerView selectedRowInComponent:1];
        [pickerView reloadComponent:1];
        [pickerView selectedRowInComponent:2];
        
        if (component == 1) {
            if (self.selectedArray.count > 0 && self.cityArray.count > 0) {
                self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:row]];
            } else {
                self.townArray = nil;
            }
            [pickerView selectRow:1 inComponent:2 animated:YES];
        }
        
        [pickerView reloadComponent:2];
    }else{
        //.........
    }
    
}
#pragma mark --tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *Id = @"Id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    cell.backgroundColor = [UIColor colorWithWhite:0.5 alpha:.8];
    cell.textLabel.text = @"南京";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (tableView == _tableView) {
//        //将选中的数据源放入btn文字
//        for(int i = 0; i < 3 ; i ++){
//            SettingButton *btn = [_scrollView viewWithTag:1200 + i];
//            if (btn.x == tableView.x) {
//                [btn setTitle:@"南京" forState:UIControlStateNormal];
//                tableView.alpha = 0;
//                btn.isSelected = NO;
//                [_coverView removeFromSuperview];
//                
//                //点击完之后让textField可编辑
//                [self makeTextFieldEditingEnable];
//                
//            }
//        }
//    }else
//    if (tableView == _SubDistrictChoice){
//        SettingButton *btn = (SettingButton *)[_scrollView viewWithTag:1221];
//        [btn setTitle:@"小区" forState:UIControlStateNormal];
//        _SubDistrictChoice.alpha = 0;
//        [_coverVie removeFromSuperview];
//        btn.isSelected = NO;
//    }else
        if(tableView == _responsibleChoice){
        SettingButton *btn = (SettingButton *)[_scrollView viewWithTag:1233];
        [btn setTitle:@"小明" forState:UIControlStateNormal];
        _responsibleChoice.alpha = 0;
        btn.isSelected = NO;
    }else if(tableView == _gradeChoice){
        SettingButton *btn = (SettingButton *)[_scrollView viewWithTag:1234];
        [btn setTitle:@"等级很高" forState:UIControlStateNormal];
        _gradeChoice.alpha = 0;
        btn.isSelected = NO;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20.0f;
}

#pragma mark -处理小区类型 || 负责人 || 等级 的点击
- (void)handleDistrictBtn:(SettingButton *)btn
{
//    [self addCoverViewWithFrame:CGRectMake(0, btn.maxY, self.view.width, self.view.height - btn.maxY) belowView:_SubDistrictChoice];
    UITableView *tableV;
    if (btn.tag == 1233) {//请选择负责人
        NSLog(@"负责人");
        if (_gradeChoice.alpha != 0) {
            _gradeChoice.alpha = 0;
            SettingButton *btn = [_scrollView viewWithTag:1234];
            btn.isSelected = NO;
        }
        tableV = _responsibleChoice;
        
    }else if(btn.tag == 1234){//请选择等级
        
        if (_responsibleChoice.alpha != 0) {
            _responsibleChoice.alpha = 0;
            SettingButton *btn = [_scrollView viewWithTag:1233];
            btn.isSelected = NO;
        }
        tableV = _gradeChoice;
    }
//    }else if (btn.tag == 1221){//请选择小区类型
//        tableV = _SubDistrictChoice;
//        if(tableV.alpha != 0){
//          [self addCoverViewWithFrame:CGRectMake(0, btn.maxY, self.view.width, self.view.height - btn.maxY) belowView:_SubDistrictChoice isSubDistrict:YES];
//        }
//    }
    if (btn.isSelected == NO) {
        [UIView animateWithDuration:0.25 animations:^{
            tableV.alpha = 0.5;
        } completion:^(BOOL finished) {
             tableV.alpha = 1;
            tableV.frame = CGRectMake(btn.x, btn.maxY, btn.width, 80);
        }];
        btn.isSelected = YES;
       
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            tableV.alpha = 0.5;
        } completion:^(BOOL finished) {
             tableV.alpha = 0 ;
        }];
        [_coverVie removeFromSuperview];
         btn.isSelected = NO;
    }
 }

#pragma mark -处理盖板的轻按事件
//处理盖板的轻按事件
//- (void)handleTap
//{
//   
//        for(int i = 0; i < 3 ; i ++){
//            SettingButton *btn = [_scrollView viewWithTag:1200 + i];
//            if (btn.x == _tableView.x ) {
//                _tableView.alpha = 0;
//                btn.isSelected = NO;
//                [_coverView removeFromSuperview];
//                
//                //点击完之后让textField可编辑
//                [self makeTextFieldEditingEnable];
//                
//            }
//        }
//    
//        SettingButton *btn1 = [_scrollView viewWithTag:1221];
//        btn1.isSelected = NO;
//        _SubDistrictChoice.alpha = 0;
//        [_coverVie removeFromSuperview];
//   
//}

#pragma mark－－textField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];

    //根据text搜索 请求数据
    //展示界面
    if (textField.tag == 1222) {
        SearchProperty *searchControl = [[SearchProperty alloc] init];
        searchControl.inputText = textField.text;
        searchControl.delegate = self;
        [self.navigationController pushViewController:searchControl animated:YES];
    }
    return YES;
}
#pragma mark--searchPropertyDelegate 返回搜索物业结果 到搜索框
- (void)bringBackChioceProperty:(NSString *)propertyName
{
    UITextField *field = [_scrollView viewWithTag:1222];
    field.text = propertyName;
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
   
}

#pragma mark --点击提交
- (void)subMitInfo
{
    BranchStatisticController *branchController = [[BranchStatisticController alloc] init];
    [self.navigationController pushViewController:branchController animated:YES];
}
//#pragma mark －－textField可编辑 ｜｜ 不可编辑
//- (void)makeTextFieldEditingUnEnable
//{
//    for(UIView * vie in _scrollView.subviews){
//        if ([vie isKindOfClass:[UITextField class]] || [vie isKindOfClass:[UISearchBar class]]) {
//            UITextField *field = (UITextField *)vie;
//            field.enabled = NO;
//        }
//    }
//}
//- (void)makeTextFieldEditingEnable
//{
//    for(UIView * vie in _scrollView.subviews){
//        if ([vie isKindOfClass:[UITextField class]] || [vie isKindOfClass:[UISearchBar class]]) {
//            UITextField *field = (UITextField *)vie;
//            field.enabled = YES;
//        }
//    }
//}
@end
