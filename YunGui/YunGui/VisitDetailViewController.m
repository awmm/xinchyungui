//
//  VisitDetailViewController.m
//  YunGui
//
//  Created by wmm on 15/11/14.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "VisitDetailViewController.h"
#import "EditVisitViewController.h"


@interface VisitDetailViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIScrollView *scrollView2;
@property (strong, nonatomic) UISegmentedControl *segment;

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

@implementation VisitDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [ViewTool setNavigationBar:self.navigationController.navigationBar];
    self.navigationItem.title = @"拜访详情";
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushEditViewController:)];
    //  self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem.customView.hidden=YES;
    _titleArray = @[@"统签:",@"小区名:",@"联系人:",@"联系电话:",@"所属地区:",@"具体地址:",@"物业名:",@"竞争对手:",@"添加照片:"];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-40); // frame中的size指UIScrollView的可视范围
    _scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    _scrollView.pagingEnabled = NO; //是否翻页
    _scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    _scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [self drawUI];
    
    _scrollView2 = [[UIScrollView alloc] init];
    _scrollView2.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-40); // frame中的size指UIScrollView的可视范围
    _scrollView2.directionalLockEnabled = YES; //只能一个方向滑动
    _scrollView2.pagingEnabled = NO; //是否翻页
    _scrollView2.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    _scrollView2.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    _scrollView2.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    _scrollView2.delegate = self;
    [self.view addSubview:_scrollView2];
    _scrollView2.hidden = YES;
    [self drawUI2];
    
    NSArray *arr = [[NSArray alloc]initWithObjects:@"基本信息",@"拜访记录", nil];
    _segment = [[UISegmentedControl alloc]initWithItems:arr];
    //在没有设置[segment setApportionsSegmentWidthsByContent:YES]时，每个的宽度按segment的宽度平分
    _segment.frame = CGRectMake(0, kScreenHeight-40, kScreenWidth, 40);
    _segment.selectedSegmentIndex = 0;
    _segment.tintColor = [UIColor lightGrayColor];
    [_segment addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segment];
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
    
//    _visitRecord = [[UITextView alloc] initWithFrame:CGRectMake(120.0f, 614.0f, kScreenWidth-130.0f, 110.0f)];
//    _visitRecord.textColor = [UIColor grayColor];
//    _visitRecord.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _visitRecord.layer.borderWidth = 1.0f;
//    _visitRecord.layer.cornerRadius = 8.0f;
//    _visitRecord.layer.masksToBounds = YES;
//    _visitRecord.text = @"小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录小区拜访记录";
//    [_visitRecord setEditable:NO];
////    _visitRecord.font = [UIFont fontWithName:@"Arial" size:15.0];
//    [_scrollView addSubview:_visitRecord];
    
    _scrollView.contentSize =  CGSizeMake(0, kScreenHeight+100.0f);
}

- (void)drawUI2{
    for (int i = 0; i<5; i++) {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 120*i+64, 120.0f, 30.0f)];
        lable.text = @"MON 07/11";
        [_scrollView2 addSubview:lable];
        UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-120.0, 120*i+64, 120.0f, 30.0f)];
        lable2.text = @"9:30";
        [_scrollView2 addSubview:lable2];
        
        UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 120*i+94, kScreenWidth-20, 30.0f)];
        lable3.text = @"联系人：小王";
        lable3.backgroundColor = [UIColor colorWithRed:(20.0f/255.0f) green:(30.0f/255.0f) blue:(40.0f/255.0f) alpha:0.1f];

        [_scrollView2 addSubview:lable3];
        
        UILabel *lable4 = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 120*i+124, kScreenWidth-20, 30.0f)];
        lable4.text = @"电话：13213213212";
        lable4.backgroundColor = [UIColor colorWithRed:(20.0f/255.0f) green:(30.0f/255.0f) blue:(40.0f/255.0f) alpha:0.1f];
        [_scrollView2 addSubview:lable4];
        
        UILabel *lable5 = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 120*i+154, kScreenWidth-20, 30.0f)];
        lable5.text = @"拜访情况：签合同，预约下次拜访";
        lable5.backgroundColor = [UIColor colorWithRed:(20.0f/255.0f) green:(30.0f/255.0f) blue:(40.0f/255.0f) alpha:0.1f];
        [_scrollView2 addSubview:lable5];
    }
    _scrollView2.contentSize =  CGSizeMake(0, kScreenHeight+100.0f);
}

#pragma mark - ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"...");
}

- (void)changeView:(UISegmentedControl *)control{
    if (_segment.selectedSegmentIndex == 0) {
        _scrollView.hidden = NO;
        _scrollView2.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        _scrollView.hidden = YES;
        _scrollView2.hidden = NO;
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushEditViewController:)];
    }
}

- (void)passValue:(NSString *)value
{
    _visitRecord.text = value;
    NSLog(@"the get value is %@", value);
}

- (void)pushEditViewController:(UIButton *)btn{
    EditVisitViewController * editVisitVC=[[EditVisitViewController alloc]init];
    editVisitVC.delegate = self;
    [self.navigationController pushViewController:editVisitVC animated:NO];
    
}
@end
