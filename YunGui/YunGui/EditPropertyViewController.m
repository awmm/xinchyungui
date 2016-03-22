//
//  EditPropertyViewController.m
//  YunGui
//
//  Created by HanenDev on 15/11/17.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "EditPropertyViewController.h"
#import "UIView+Extension.h"
#import "selectButton.h"
#import "Macro.h"
#import "MapDetailViewController.h"

#define TFWIDTH 200.0f
#define TFX 90.0f

@interface EditPropertyViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView     *_cityPickView;
    UIView          *_backView;
    UIButton        *_sureBtn;
    UIButton        *_cancleBtn;
}
@property(nonatomic,strong)NSArray * titleArray;
@property(nonatomic,strong)UIScrollView * scrollView;

@property(nonatomic,strong)UITextField *propertyTF;
@property(nonatomic,strong)UITextField *detailTF;
@property(nonatomic,strong)UITextField *nameTF;
@property(nonatomic,strong)UITextField *telTF;
@property(nonatomic,strong)UITextField *bankIDTF;
@property(nonatomic,strong)UITextField *houseHolderTF;
@property(nonatomic,strong)UILabel     *tabLabel;

@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSArray *selectedArray;
@end

@implementation EditPropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [ViewTool setNavigationBar:self.navigationController.navigationBar];
    self.title=@"物业编辑";
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(referClick:)];

    
    [self createUI];
    [self getPickerData];

}
-(void)createUI
{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
    _scrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_scrollView];
    
    _titleArray=@[@"物业名称:",@"所属地区:",@"详细地址:",@"物业联系人:",@"电话:",@"标签:",@"我的账户:"];
    
    for (int i=0; i<_titleArray.count; i++)
    {
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(5, (40+10)*i, 80, 40)];
        label.text=_titleArray[i];
        label.font=[UIFont systemFontOfSize:15.0f];
        [_scrollView addSubview:label];
    }
    
    //物业名称
    _propertyTF=[[UITextField alloc]initWithFrame:CGRectMake(TFX, 5, 200, 30)];
    _propertyTF.borderStyle=UITextBorderStyleLine;
    [_scrollView addSubview:_propertyTF];
    
    //所属地区
    for (int i=0; i<3; i++)
    {
        selectButton *btn=[[selectButton alloc]initWithFrame:CGRectMake(TFX+(70+5)*i, _propertyTF.maxY+20, 70, 30)];
        btn.tag=1111+i;
        //btn.backgroundColor=[UIColor lightGrayColor];
        [btn addTarget:self action:@selector(areaSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
    }
   
    [self creatCityPickView];
    //详细地址
    _detailTF=[[UITextField alloc]initWithFrame:CGRectMake(TFX, _propertyTF.maxY+20+30+20, TFWIDTH, 30)];
    _detailTF.borderStyle=UITextBorderStyleLine;
    [_scrollView addSubview:_detailTF];
    
    //物业联系人
    _nameTF=[[UITextField alloc]initWithFrame:CGRectMake(TFX, _detailTF.maxY+20, TFWIDTH, 30)];
    _nameTF.borderStyle=UITextBorderStyleLine;
    [_scrollView addSubview:_nameTF];
    
    //电话
    _telTF=[[UITextField alloc]initWithFrame:CGRectMake(TFX, _nameTF.maxY+20, TFWIDTH, 30)];
    _telTF.borderStyle=UITextBorderStyleLine;
    [_scrollView addSubview:_telTF];
    
    //标签
    _tabLabel=[[UILabel alloc]initWithFrame:CGRectMake(TFX, _telTF.maxY+20, TFWIDTH, 30)];
    _tabLabel.text=@"公司企业";
    _tabLabel.textAlignment=NSTextAlignmentCenter;
    _tabLabel.font=[UIFont systemFontOfSize:15.0F];
    [_scrollView addSubview:_tabLabel];
    
    NSArray * zhArray=@[@"编号:",@"开户银行:",@"银行账户:",@"账户类型:",@"开户银行详细地址:"];
    for (int i=0; i<zhArray.count; i++)
    {
//        CGFloat width=[zhArray[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil].size.width;
//        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(TFX-10, _tabLabel.maxY+20+30*i, width, 40)];
//        label.font=[UIFont systemFontOfSize:14.0f];
//        label.text=zhArray[i];
//        label.tag=222+i;
//        //label.backgroundColor=[UIColor lightGrayColor];
//        [_scrollView addSubview:label];
//        
//        UITextField * field=[[UITextField alloc]initWithFrame:CGRectMake(label.maxX+5, label.y, self.view.width-label.maxX-5, 25)];
//        field.borderStyle=UITextBorderStyleLine;
//        
//        [_scrollView addSubview:field];
        
        UITextField * field=[[UITextField alloc]initWithFrame:CGRectMake(TFX, _tabLabel.maxY+20+(30+5)*i, 200, 30)];
        field.borderStyle=UITextBorderStyleLine;
        field.placeholder=zhArray[i];
        field.tag=222+i;
        [_scrollView addSubview:field];
    }
    UITextField *label=[_scrollView viewWithTag:222+zhArray.count-1];
    _scrollView.contentSize=CGSizeMake(self.view.width, label.maxY);
    
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
        selectButton *provinceBtn = [_scrollView viewWithTag:1111];
        provinceBtn.isOpen = NO;
        //[provinceBtn setTitle:[self.provinceArray objectAtIndex:[_cityPickView selectedRowInComponent:0]] forState:UIControlStateNormal];
        provinceBtn.btnLabel.text=[self.provinceArray objectAtIndex:[_cityPickView selectedRowInComponent:0]];
        
        selectButton *cityBtn = [_scrollView viewWithTag:1112];
        cityBtn.isOpen = NO;
        //[cityBtn setTitle:[self.cityArray objectAtIndex:[_cityPickView selectedRowInComponent:1]] forState:UIControlStateNormal];
        cityBtn.btnLabel.text=[self.cityArray objectAtIndex:[_cityPickView selectedRowInComponent:1]];
        
        selectButton *townBtn = [_scrollView viewWithTag:1113];
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
        selectButton *provinceBtn = [_scrollView viewWithTag:1111];
        provinceBtn.isOpen = NO;
        selectButton *cityBtn = [_scrollView viewWithTag:1112];
        cityBtn.isOpen = NO;
        selectButton *townBtn = [_scrollView viewWithTag:1113];
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




//提交物业编辑
-(void)referClick:(UIButton *)btn
{
    NSLog(@"ssssssssss");
//    MapDetailViewController *vc=[[MapDetailViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
