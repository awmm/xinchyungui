//
//  EditVisitViewController.m
//  YunGui
//
//  Created by wmm on 15/11/14.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "EditVisitViewController.h"

@interface EditVisitViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *titleArray;

@property (strong, nonatomic) UILabel *isTongQian;
@property (strong, nonatomic) UILabel *subName;
@property (strong, nonatomic) UILabel *contact;
@property (strong, nonatomic) UILabel *contactPhone;
@property (strong, nonatomic) UILabel *area;
@property (strong, nonatomic) UILabel *address;
@property (strong, nonatomic) UILabel *proName;
@property (strong, nonatomic) UILabel *competitor;
@property (strong, nonatomic) UIImageView *photoView;
@property (strong, nonatomic) UITextView *visitRecord;

@end

@implementation EditVisitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [ViewTool setNavigationBar:self.navigationController.navigationBar];
    self.navigationItem.title = @"添加记录";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(addVisitRecord:)];
    self.view.backgroundColor = [UIColor whiteColor];
    _titleArray = @[@"统签:",@"小区名:",@"联系人:",@"联系电话:",@"所属地区:",@"具体地址:",@"物业名:",@"竞争对手:",@"添加照片:",@"拜访记录:"];
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight); // frame中的size指UIScrollView的可视范围
    _scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    _scrollView.pagingEnabled = NO; //是否翻页
    _scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    _scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [self drawUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawUI{
    for (int i = 0; i<_titleArray.count; i++) {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 60*i+64, 120.0f, 60.0f)];
        lable.text = _titleArray[i];
        [_scrollView addSubview:lable];
        if (i<_titleArray.count-1) {
            UIView * lineView=[[UIView alloc]initWithFrame:CGRectMake(0.0f, 60*(i+1)+63, kScreenWidth, 1.0f)];
            lineView.backgroundColor=[UIColor lightGrayColor];
            [_scrollView addSubview:lineView];
        }
    }
    
    _isTongQian = [[UILabel alloc] initWithFrame:CGRectMake(120.f, 64.0f, kScreenWidth-120.0f, 60.0f)];
    _isTongQian.textColor = [UIColor grayColor];
    _isTongQian.text = @"是";
    [_scrollView addSubview:_isTongQian];
    
    _subName = [[UILabel alloc] initWithFrame:CGRectMake(120.0f, 124.0f, kScreenWidth-120.0f, 60.0f)];
    _subName.textColor = [UIColor grayColor];
    _subName.text = @"朗诗";
    [_scrollView addSubview:_subName];
    
    _contact = [[UILabel alloc] initWithFrame:CGRectMake(120.0f, 194.0f, kScreenWidth-140.0f, 40.0f)];
    _contact.textColor = [UIColor grayColor];
    _contact.text = @"小明";
    [_scrollView addSubview:_contact];
    
    _contactPhone = [[UILabel alloc] initWithFrame:CGRectMake(120.0f, 254.0f, kScreenWidth-140.0f, 40.0f)];
    _contactPhone.textColor = [UIColor grayColor];
    _contactPhone.text = @"12312312322";
    [_scrollView addSubview:_contactPhone];
    
    _area = [[UILabel alloc] initWithFrame:CGRectMake(120.0f, 304.0f, kScreenWidth-120.0f, 60.0f)];
    _area.textColor = [UIColor grayColor];
    _area.text = @"根据选择的小区自动填充";
    [_scrollView addSubview:_area];
    
    _address = [[UILabel alloc] initWithFrame:CGRectMake(120.0f, 364.0f, kScreenWidth-120.0f, 60.0f)];
    _address.textColor = [UIColor grayColor];
    _address.text = @"根据选择的小区自动填充";
    [_scrollView addSubview:_address];
    
    _proName = [[UILabel alloc] initWithFrame:CGRectMake(120.0f, 424.0f, kScreenWidth-120.0f, 60.0f)];
    _proName.textColor = [UIColor grayColor];
    _proName.text = @"根据选择的小区自动填充";
    [_scrollView addSubview:_proName];
    
    _competitor = [[UILabel alloc] initWithFrame:CGRectMake(120.0f, 484.0f, kScreenWidth-120.0f, 60.0f)];
    _competitor.textColor = [UIColor grayColor];
    _competitor.text = @"根据选择的小区自动填充";
    [_scrollView addSubview:_competitor];
    
    
    _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(120.0f, 544.0f, (kScreenWidth-120.0f)/3, 60.0f)];
    _photoView.image = [UIImage imageNamed:@"logo.png"];
    _photoView.animationDuration = 2.0;
    _photoView.animationRepeatCount = 1;
    
    [_scrollView addSubview:_photoView];
    
    _visitRecord = [[UITextView alloc] initWithFrame:CGRectMake(120.0f, 614.0f, kScreenWidth-130.0f, 110.0f)];
    _visitRecord.textColor = [UIColor grayColor];
    _visitRecord.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _visitRecord.layer.borderWidth = 1.0f;
    _visitRecord.layer.cornerRadius = 8.0f;
    _visitRecord.layer.masksToBounds = YES;
    _visitRecord.text = @"小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录";
    NSUInteger length = _visitRecord.text.length;
    _visitRecord.selectedRange = NSMakeRange(length,0);
    _visitRecord.delegate = self;
    [_visitRecord becomeFirstResponder];
    
//    当UITextView中含有文字时，系统默认将光标定位到最后的位置，下面的语句将光标定位到首位置。
//    [cpp] m_contentTextField.selectedRange = NSMakeRange(0,0);
    [_scrollView addSubview:_visitRecord];
    
    _scrollView.contentSize =  CGSizeMake(0, kScreenHeight+100.0f);

}


- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"textViewDidEndEditing....");
    [self.delegate passValue:textView.text];
}

//跳到提交界面
-(void)addVisitRecord:(UIButton *)sender
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

@end
