//
//  CreatePropertyViewController.m
//  YunGui
//
//  Created by HanenDev on 15/11/12.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "CreatePropertyViewController.h"
#import "selectButton.h"
#import "UIView+Extension.h"
#import "Macro.h"

#define TFWIDTH 200.0f
#define TFX 90.0f

@interface CreatePropertyViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

{
    NSArray      *_labelArray;
    UIScrollView * scrollView;
    selectButton *_getBtn;
    selectButton *_lastClickBtn;
    UITableView  *_tableView;
    
    UIScrollView * btnScroll;
    UIScrollView * btn1Scroll;
    
    UIPickerView     *_cityPickView;
    UIView          *_backView;
    UIButton        *_sureBtn;
    UIButton        *_cancleBtn;
}
@property(nonatomic,strong)UITextField *propertyTF;
@property(nonatomic,strong)UITextField *detailTF;
@property(nonatomic,strong)UITextField *nameTF;
@property(nonatomic,strong)UITextField *telTF;
@property(nonatomic,strong)UITextField *bankIDTF;
@property(nonatomic,strong)UITextField *houseHolderTF;
@property(nonatomic,strong)UITextField *tabTF;
@property(nonatomic,strong)UITextView *addressTF;
@property(nonatomic,strong)selectButton *zhangHuBtn;
@property(nonatomic,strong)selectButton *bankBtn;

@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSArray *selectedArray;
@end

@implementation CreatePropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=[UIColor whiteColor];
    [ViewTool setNavigationBar:self.navigationController.navigationBar];
    self.title=@"创建物业";

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(referClick:)];
    //创建界面
    [self createView];
    [self getPickerData];
    
}

-(void)createView
{
    
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
    scrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:scrollView];
    
    
    _labelArray=@[@"物业名称:",@"所属地区:",@"详细地址:",@"物业联系人:",@"电话:",@"标签:",@"账户类型:",@"所属银行:",@"银行账号:",@"银行户名:",@"开户银行详细地址:"];
    for ( int i=0; i<_labelArray.count; i++)
    {
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(5, (40+10)*i, 80, 40)];
        label.text=_labelArray[i];
        label.font=[UIFont systemFontOfSize:15];
        label.numberOfLines=0;
        [scrollView addSubview:label];
    }
    //物业名称
    _propertyTF=[[UITextField alloc]initWithFrame:CGRectMake(TFX, 5, 200, 30)];
    _propertyTF.borderStyle=UITextBorderStyleLine;
    _propertyTF.delegate=self;
    [scrollView addSubview:_propertyTF];
    
    //所属地区
    for (int i=0; i<3; i++)
    {
        selectButton *btn=[[selectButton alloc]initWithFrame:CGRectMake(TFX+(70+5)*i, _propertyTF.maxY+20, 70, 30)];
        btn.tag=1234+i;
        [btn addTarget:self action:@selector(areaSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.isOpen=NO;
        [scrollView addSubview:btn];
        if (i==0)
        {
            _getBtn=btn;
            _lastClickBtn=btn;
        }
    }
    
    [self creatCityPickView];

    
//    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(_getBtn.x, _getBtn.maxY, _getBtn.width, 80) style:UITableViewStylePlain];
//    _tableView.delegate=self;
//    _tableView.dataSource=self;
//    _tableView.alpha=0;
//    //_tableView.backgroundColor = [UIColor redColor];
//    [scrollView addSubview:_tableView];
    
    //详细地址
    _detailTF=[[UITextField alloc]initWithFrame:CGRectMake(TFX, _propertyTF.maxY+20+30+20, TFWIDTH, 30)];
    _detailTF.borderStyle=UITextBorderStyleLine;
    [scrollView addSubview:_detailTF];
    
    //物业联系人
    _nameTF=[[UITextField alloc]initWithFrame:CGRectMake(TFX, _detailTF.maxY+20, TFWIDTH, 30)];
    _nameTF.borderStyle=UITextBorderStyleLine;
    [scrollView addSubview:_nameTF];
    
    //电话
    _telTF=[[UITextField alloc]initWithFrame:CGRectMake(TFX, _nameTF.maxY+20, TFWIDTH, 30)];
    _telTF.borderStyle=UITextBorderStyleLine;
    [scrollView addSubview:_telTF];
    
    //标签
    _tabTF=[[UITextField alloc]initWithFrame:CGRectMake(TFX, _telTF.maxY+20, TFWIDTH, 30)];
    _tabTF.borderStyle=UITextBorderStyleLine;
    [scrollView addSubview:_tabTF];
    
    //账户类型
    _zhangHuBtn=[[selectButton alloc]initWithFrame:CGRectMake(TFX, _tabTF.maxY+20, TFWIDTH, 30)];
    //_zhangHuBtn.backgroundColor=[UIColor grayColor];
    _zhangHuBtn.btnLabel.text=@"对公账户";
    [_zhangHuBtn addTarget:self action:@selector(zhBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _zhangHuBtn.isOpen=NO;
    [scrollView addSubview:_zhangHuBtn];
    
    //所属银行
    _bankBtn=[[selectButton alloc]initWithFrame:CGRectMake(TFX, _zhangHuBtn.maxY+20, TFWIDTH, 30)];
    //_bankBtn.backgroundColor=[UIColor grayColor];
    _bankBtn.btnLabel.text=@"中国银行";
    [_bankBtn addTarget:self action:@selector(bankBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _bankBtn.isOpen=NO;
    [scrollView addSubview:_bankBtn];
    
    //银行账号
    _bankIDTF=[[UITextField alloc]initWithFrame:CGRectMake(TFX, _bankBtn.maxY+20, TFWIDTH, 30)];
    _bankIDTF.borderStyle=UITextBorderStyleLine;
    [scrollView addSubview:_bankIDTF];
    
    //银行户名
    _houseHolderTF=[[UITextField alloc]initWithFrame:CGRectMake(TFX, _bankIDTF.maxY+20, TFWIDTH, 30)];
    _houseHolderTF.borderStyle=UITextBorderStyleLine;
    [scrollView addSubview:_houseHolderTF];
    
    //开户银行详细地址
    _addressTF=[[UITextView alloc]initWithFrame:CGRectMake(TFX, _houseHolderTF.maxY+20, TFWIDTH, 50)];
    _addressTF.layer.borderColor = [UIColor grayColor].CGColor;
    _addressTF.layer.borderWidth =1.0;
    [scrollView addSubview:_addressTF];
    
    scrollView.contentSize=CGSizeMake(self.view.width,_addressTF.maxY);
    
    [self drawZhanghuView];//账户类型
    [self drawBankView];//所属银行
    
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

- (void)creatCityPickView
{
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height, kScreenWidth, 30)];
    _backView.alpha = 0;
    _backView.backgroundColor = [UIColor blackColor];
    
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
    _cityPickView.backgroundColor = [UIColor brownColor];
    _cityPickView.layer.borderWidth = 1;
    _cityPickView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //    _cityPickView.layer.cornerRadius = 5;
    
    
    //    [_pickView addSubview:_backView];
    //    [_pickView addSubview:_cityPickView];
    [self.view addSubview:_cityPickView];
    [self.view addSubview:_backView];
}
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
        //isSure 点击确定
        if (isSure) {
            selectButton *provinceBtn = [scrollView viewWithTag:1234];
            provinceBtn.isOpen = NO;
            //[provinceBtn setTitle:[self.provinceArray objectAtIndex:[_cityPickView selectedRowInComponent:0]] forState:UIControlStateNormal];
            provinceBtn.btnLabel.text=[self.provinceArray objectAtIndex:[_cityPickView selectedRowInComponent:0]];
            
            selectButton *cityBtn = [scrollView viewWithTag:1235];
            cityBtn.isOpen = NO;
            //[cityBtn setTitle:[self.cityArray objectAtIndex:[_cityPickView selectedRowInComponent:1]] forState:UIControlStateNormal];
            cityBtn.btnLabel.text=[self.cityArray objectAtIndex:[_cityPickView selectedRowInComponent:1]];
            
            selectButton *townBtn = [scrollView viewWithTag:1236];
            townBtn.isOpen = NO;
            //[townBtn setTitle:[self.townArray objectAtIndex:[_cityPickView selectedRowInComponent:2]] forState:UIControlStateNormal];
            townBtn.btnLabel.text=[self.townArray objectAtIndex:[_cityPickView selectedRowInComponent:2]];
            
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
            selectButton *provinceBtn = [scrollView viewWithTag:1234];
            provinceBtn.isOpen = NO;
            selectButton *cityBtn = [scrollView viewWithTag:1235];
            cityBtn.isOpen = NO;
            selectButton *townBtn = [scrollView viewWithTag:1236];
            townBtn.isOpen = NO;
            
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

//地区选择
-(void)areaSelectClick:(selectButton *)btn
{
    if (btn.isOpen == NO) {
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
        btn.isOpen = YES;
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
        btn.isOpen = NO;
    }
    
//    [self makeTextFieldEditingUnEnable];
//
//    if (_lastClickBtn==btn)
//    {
//        if (btn.tag-1234==0)
//        {
//            if (btn.isOpen==NO)
//            {
//            [_tableView reloadData];
//            [UIView animateWithDuration:0.25 animations:^{
//                _tableView.frame=CGRectMake(btn.x, btn.maxY, btn.width, 80);
//            } completion:^(BOOL finished) {
//                _tableView.alpha=1;
//            }];
//                btn.isOpen=YES;
//            }
//            else
//            {
//                [_tableView reloadData];
//                [UIView animateWithDuration:0.25 animations:^{
//                    _tableView.frame=CGRectMake(btn.x, btn.maxY, btn.width, 0);
//                } completion:^(BOOL finished) {
//                    _tableView.alpha=0;
//                }];
//                btn.isOpen=NO;
//                [self makeTextFieldEditingUnEnable];
//
//            }
//        }else if (btn.tag-1234==1)
//        {
//            if (btn.isOpen==NO){
//                [_tableView reloadData];
//            [UIView animateWithDuration:0.25 animations:^{
//                _tableView.frame = CGRectMake(btn.x, btn.maxY, btn.width, 80);
//            } completion:^(BOOL finished) {
//                _tableView.alpha = 1;
//            }];
//            btn.isOpen = YES;
//        }else{
//            [_tableView reloadData];
//            [UIView animateWithDuration:0.25 animations:^{
//                _tableView.frame = CGRectMake(btn.x, btn.maxY, btn.width, 0);
//            } completion:^(BOOL finished) {
//                _tableView.alpha = 0;
//                
//            }];
//            btn.isOpen = NO;
//            [self makeTextFieldEditingUnEnable];
//
//        }
//        }else if (btn.tag-1234==2)
//        {
//            [_tableView reloadData];
//            if (btn.isOpen==NO)
//            {
//                [UIView animateWithDuration:0.25 animations:^{
//                    _tableView.frame=CGRectMake(btn.x, btn.maxY, btn.width, 80);
//                } completion:^(BOOL finished) {
//                    _tableView.alpha=1;
//                }];
//                btn.isOpen=YES;
//            }else{
//                [_tableView reloadData];
//                [UIView animateWithDuration:0.25 animations:^{
//                    _tableView.frame=CGRectMake(btn.x, btn.maxY, btn.width, 0);
//                } completion:^(BOOL finished) {
//                    _tableView.alpha=0;
//                }];
//                btn.isOpen=NO;
//                [self makeTextFieldEditingUnEnable];
//
//            }
//        }
//    
//    }else
//    {
//        _tableView.alpha=0;
//        _lastClickBtn.isOpen=NO;
//        if (btn.tag -1234==0)
//        {
//            [_tableView reloadData];
//            if (btn.isOpen==NO)
//            {
//                [UIView animateWithDuration:0.25 animations:^{
//                    _tableView.frame=CGRectMake(btn.x, btn.maxY, btn.width, 80);
//                } completion:^(BOOL finished) {
//                    _tableView.alpha=1;
//                }];
//                btn.isOpen=YES;
//            }else
//            {
//                [_tableView reloadData];
//                [UIView animateWithDuration:0.25 animations:^{
//                    _tableView.frame=CGRectMake(btn.x, btn.maxY, btn.width, 0);
//                } completion:^(BOOL finished) {
//                    _tableView.alpha=0;
//                }];
//                btn.isOpen=NO;
//            }
//        }else if (btn.tag-1234 ==1){
//            [_tableView reloadData];
//            _tableView.alpha=0;
//            if (btn.isOpen==NO)
//            {
//                [UIView animateWithDuration:0.25 animations:^{
//                    _tableView.frame=CGRectMake(btn.x, btn.maxY, btn.width, 80);
//                } completion:^(BOOL finished) {
//                    _tableView.alpha=1;
//                }];
//                btn.isOpen=YES;
//            }else
//            {
//                [_tableView reloadData];
//                [UIView animateWithDuration:0.25 animations:^{
//                    _tableView.alpha=0;
//                    _tableView.frame=CGRectMake(btn.x, btn.maxY, btn.width, 0);
//                }];
//                btn.isOpen=NO;
//            }
//        }else if (btn.tag-1234==2){
//            [_tableView reloadData];
//            if (btn.isOpen==NO)
//            {
//                [UIView animateWithDuration:0.25 animations:^{
//                    _tableView.frame=CGRectMake(btn.x, btn.maxY, btn.width, 80);
//                } completion:^(BOOL finished) {
//                    _tableView.alpha=1;
//                }];
//                btn.isOpen=YES;
//            }else
//            {
//                [_tableView reloadData];
//                [UIView animateWithDuration:0.25 animations:^{
//                    _tableView.alpha=0;
//                    _tableView.frame=CGRectMake(btn.x, btn.maxY, btn.width, 0);
//                    
//                }];
//                btn.isOpen=NO;
//            }
//        }
//    }
//    _lastClickBtn=btn;
}
//账户类型选择
-(void)drawZhanghuView
{
    NSArray *zhangHuArray=@[@"对公账户0",@"对公账户1",@"对公账户2",@"对公账户3",@"对公账户4"];
    btnScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(TFX, _zhangHuBtn.maxY, TFWIDTH-20, 0)];
    btnScroll.showsVerticalScrollIndicator=NO;
    btnScroll.showsHorizontalScrollIndicator=NO;
    btnScroll.bounces=NO;
    btnScroll.tag=1000;
    [scrollView addSubview:btnScroll];
    
    for (int i=0; i<zhangHuArray.count; i++)
    {
        UIButton *zhBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 40*i, TFWIDTH-20, 40)];
        [zhBtn setTitle:zhangHuArray[i] forState:UIControlStateNormal];
        zhBtn.backgroundColor=[UIColor grayColor];
        zhBtn.tag=123+i;
        [zhBtn addTarget:self action:@selector(zhangHuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnScroll addSubview:zhBtn];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, (40-1)*i, TFWIDTH-20, 1)];
        lineView.backgroundColor=[UIColor blackColor];
        [btnScroll addSubview:lineView];
    }
    UIButton *selectBtn=[btnScroll viewWithTag:123+zhangHuArray.count-1];
    btnScroll.contentSize=CGSizeMake(TFWIDTH-20, selectBtn.maxY);
}

//账户类型选择
-(void)zhBtnClick:(selectButton *)sender
{
    if (btn1Scroll.tag==2000)
    {
        btn1Scroll.frame=CGRectMake(TFX, _bankBtn.maxY, TFWIDTH-20, 0);
    }
    
    sender.isOpen=!sender.isOpen;
    if (sender.isOpen==NO)
    {
        [UIView animateWithDuration:0.25 animations:^{
            btnScroll.frame=CGRectMake(TFX, sender.maxY, TFWIDTH-20, 3*40);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            btnScroll.frame=CGRectMake(TFX, sender.maxY, TFWIDTH-20, 0);
        }];
    }
}
//账户类型按钮的选择
-(void)zhangHuBtnClick:(UIButton *)btn
{
    _zhangHuBtn.btnLabel.text=btn.titleLabel.text;
    btnScroll.frame=CGRectMake(TFX, _zhangHuBtn.maxY, TFWIDTH-20, 0);
}

//所属银行选择
-(void)drawBankView
{
    NSArray *bankArray=@[@"中国银行0",@"中国银行1",@"中国银行2",@"中国银行3",@"中国银行4"];
    btn1Scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(TFX, _bankBtn.maxY, TFWIDTH-20, 0)];
    btn1Scroll.showsVerticalScrollIndicator=NO;
    btn1Scroll.showsHorizontalScrollIndicator=NO;
    btn1Scroll.bounces=NO;
    btn1Scroll.tag=2000;
    [scrollView addSubview:btn1Scroll];
    
    for (int i=0; i<bankArray.count; i++)
    {
        UIButton *bankBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 40*i, TFWIDTH-20, 40)];
        [bankBtn setTitle:bankArray[i] forState:UIControlStateNormal];
        bankBtn.backgroundColor=[UIColor grayColor];
        bankBtn.tag=321+i;
        [bankBtn addTarget:self action:@selector(bank1BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn1Scroll addSubview:bankBtn];
    }
    UIButton *selectBtn=[btn1Scroll viewWithTag:321+bankArray.count-1];
    btn1Scroll.contentSize=CGSizeMake(TFWIDTH-20, selectBtn.maxY);
}
//所属银行选择
-(void)bankBtnClick:(selectButton *)sender
{
    if (btnScroll.tag==1000)
    {
        btnScroll.frame=CGRectMake(TFX, _zhangHuBtn.maxY, TFWIDTH-20, 0);
    }
    
    sender.isOpen=!sender.isOpen;
    if (sender.isOpen==NO)
    {
        [UIView animateWithDuration:0.25 animations:^{
            btn1Scroll.frame=CGRectMake(TFX, sender.maxY, TFWIDTH-20, 3*40);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            btn1Scroll.frame=CGRectMake(TFX, sender.maxY, TFWIDTH-20, 0);
        }];
    }
}
//所属银行按钮的选择
-(void)bank1BtnClick:(UIButton *)btn
{
    _bankBtn.btnLabel.text=btn.titleLabel.text;
    btn1Scroll.frame=CGRectMake(TFX, _bankBtn.maxY, TFWIDTH-20, 0);
}

#pragma mark -- pickView代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
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
        return 110;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  
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
    
}

#pragma mark 
#pragma mark -----textField协议方法
//点击输入框让选择界面消失
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (btnScroll.tag==1000||btn1Scroll.tag==2000)
    {
        btnScroll.frame=CGRectMake(TFX, _zhangHuBtn.maxY, TFWIDTH-20, 0);
        btn1Scroll.frame=CGRectMake(TFX, _bankBtn.maxY, TFWIDTH-20, 0);
    }
    
    return YES;
}
#pragma mark
#pragma mark------协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden=@"cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.backgroundColor=[UIColor colorWithWhite:0.5 alpha:1];
    cell.textLabel.text=@"上海";
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i=0; i<3; i++)
    {
        selectButton *btn=[scrollView viewWithTag:1234+i];
        if (btn.x==_tableView.x)
        {
            btn.btnLabel.text=@"上海";
            _tableView.alpha=0;
            btn.isOpen=NO;
            //[self makeTextFieldEditingEnable];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}
//#pragma mark －－textField可编辑 ｜｜ 不可编辑
//- (void)makeTextFieldEditingUnEnable
//{
//    for(UIView * view in scrollView.subviews){
//        if ([view isKindOfClass:[UITextField class]]) {
//            UITextField *field = (UITextField *)view;
//            field.enabled = NO;
//        }
//    }
//}
//- (void)makeTextFieldEditingEnable
//{
//    for(UIView * view in scrollView.subviews){
//        if ([view isKindOfClass:[UITextField class]]) {
//            UITextField *field = (UITextField *)view;
//            field.enabled = YES;
//        }
//    }
//}


//跳到提交界面
-(void)referClick:(UIButton *)sender
{
    NSLog(@"%@,%@",_zhangHuBtn.btnLabel.text,_bankBtn.btnLabel.text);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
