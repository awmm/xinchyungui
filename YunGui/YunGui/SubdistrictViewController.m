//
//  SubdistrictViewController.m
//  YunGui
//
//  Created by wmm on 15/11/11.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "SubdistrictViewController.h"
#import "UIView+Extension.h"

#import "ExpandTalkingVillageCell.h"
#import "ManagerVillageCell.h"
#import "SegmentView.h"
#import "SQButton.h"
#import "SubDistrictDetailController.h"
#import "NewDistrictController.h"
#import "Tools.h"
#import "SideMenuUtil.h"
#import "MJRefresh.h"

#define headBtnWidth  self.view.frame.size.width / _btnTitleArray.count//无统计条件的顶部按钮宽度
#define headBWidth   ( self.view.frame.size.width - TopBtnWidth)/ _btnTitleArray.count  //有统计条件的顶部按钮宽度
#define headBtnHeight 35.0f
#define TopBtnWidth  40.0f

#define SegViewHeight 35.0f
#define maxy _searchBar == nil ? 64 : _searchBar.maxY

//static const CGFloat MJDuration = 2.0;

@interface SubdistrictViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,SegViewDelegate>
{
    //分段选择
    SegmentView       *_segmentControl;
    
    //tableView
    UITableView              *_tableView;
    
    //数据源
    NSMutableArray           *_managerArray;
    
    NSMutableArray           *_cityArray;
    
    NSMutableArray           *_adminArray;
    
    //按钮标题
    NSArray                  *_btnTitleArray;
    
    //search
    UISearchBar              *_searchBar;
    
    //被选中的btn
    UIButton                 *_selectedBtn;
    
    //顶部是否有可伸展的按钮
    SQButton                 *_btn;
    //伸展按钮摆放view
    UIView                   *_btnView;
    
    //划线
    UIView                   *_line;
    
    //字节列表的整体视图
    UIView                   *_titleView;
    
    //头部分段选择
    UISegmentedControl       *_topSegment;
    
    dispatch_queue_t          _globelQueue;
  
}
@property (strong, nonatomic) NSString *userRole;
@end

@implementation SubdistrictViewController

@synthesize revealController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SideMenuUtil addViewGesture:self revealController:revealController];
    [ViewTool setNavigationBar:self.navigationController.navigationBar];
    self.navigationItem.title = @"小区管理";
    self.navigationItem.leftBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithString:@"list.png" WithAction:@selector(sideLeftButton_selector:)];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    _userRole = [userDefaultes objectForKey:@"userName"];
    if([_userRole isEqualToString:@"0"]){
        self.role = 0;
    }else if ([_userRole isEqualToString:@"1"]){
        self.role = 1;
    }else if([_userRole isEqualToString:@"2"]){
        self.role = 2;
    }
    _managerArray = [NSMutableArray arrayWithCapacity:0];
    
    _globelQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    [self getData];
    //导航不影响 tableView
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightBtnClick)];
    [self creatSegment];
    
    
}
#pragma mark -请求数据
- (void)getData
{
    if (self.role == 0) {
        NSString *urlSr ;
        NSDictionary *parameterDict = @{};
        dispatch_async(_globelQueue, ^{
          
            //       [Tools  sendUrlWith:urlSr parameter:parameterDict success:^(id data) {
            //
            //       } fail:^(NSError *error) {
            //
            //       }];
        });
        dispatch_async(_globelQueue, ^{
           
            //        [Tools  sendUrlWith:urlSr parameter:parameterDict success:^(id data) {
            //            
            //        } fail:^(NSError *error) {
            //            
            //        }];
        });
        dispatch_async(_globelQueue, ^{
         
            //        [Tools  sendUrlWith:urlSr parameter:parameterDict success:^(id data) {
            //
            //        } fail:^(NSError *error) {
            //
            //        }];
        });
       

}
    [NSThread  sleepForTimeInterval:2];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}
//创建分段
- (void)creatSegment
{ 
   //商务经理
    if (self.role == 0) {
        _segmentControl = [[SegmentView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - SegViewHeight, self.view.frame.size.width, SegViewHeight) withTitlesArray:@[@"我的小区",@"拓展小区",@"在谈小区"]];
        _segmentControl.firstIndex = 0;
        if (_segmentControl.selectIndex == 0) {
            _btnTitleArray = @[@"小区名称",@"城市",@"负责人",@"创建人"];
            [self creatSearchWithText:@"小区名称/城市/负责人/创建人"];
            
            [self creatListTitleWithTitle:_btnTitleArray hadButton:NO withsearchBar:YES];
        }else{
            _btnTitleArray = @[@"小区名称",@"负责人"];
            [self creatSearchWithText:@"小区名称/创建人"];
            
            [self creatListTitleWithTitle:_btnTitleArray hadButton:NO withsearchBar:NO];
        }
        
        //**************Q********************Q***************
        NSArray *arr = [NSArray array];
        if (_btnTitleArray.count == 4 ) {
            arr = @[@"浪诗物业",@"南京",@"小明",@"德玛西亚"];
        }else if (_btnTitleArray.count == 2){
            arr = @[@"浪诗物业",@"德玛西亚"];
        }
        [_managerArray addObject:arr];
        //**************Q********************Q***************
        
        
          [self creatTableVieWithSearchBar:YES];
        
    }else {//城市 & 管理层
        NSArray *segItemArray;
        if (self.role == 1) {
            segItemArray = @[@"小区统计",@"辖区小区"];
        }else{
            segItemArray = @[@"小区统计",@"所有小区"];
        }
        _segmentControl = [[SegmentView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - SegViewHeight, self.view.frame.size.width, SegViewHeight) withTitlesArray:segItemArray];
         _segmentControl.selectIndex = 0;
        
        if (_segmentControl.selectIndex == 0) {
            
            _btnTitleArray = @[@"序号",@"等级",@"数量",@"百分比"];
            
            //*******************************************************
             NSArray *arr = [NSArray array];
            arr = @[@"浪诗物业",@"南京",@"小明",@"德玛西亚"];
            [_managerArray addObject:arr];
            //*******************************************************
            
          [self creatListTitleWithTitle:_btnTitleArray hadButton:YES withsearchBar:NO];
            
        }else{
            
            _btnTitleArray = @[@"小区名称",@"城市",@"负责人",@"创建人"];
            [self creatSearchWithText:@"小区名称/城市/负责人/创建人"];
           [self creatListTitleWithTitle:_btnTitleArray hadButton:NO withsearchBar:YES];
            
        }
      [self creatTableVieWithSearchBar:NO];
       
    }

    
    _segmentControl.frame = CGRectMake(0, self.view.frame.size.height - SegViewHeight, self.view.frame.size.width, SegViewHeight);
   _segmentControl.selectIndex = 0;
    _segmentControl.delegate = self;
    _segmentControl.indicatorViewColor = [UIColor cyanColor];
//    [_segmentControl addTarget:self action:@selector(segmentVauleChanged) forControlEvents:UIControlEventValueChanged];

//    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,  [UIFont systemFontOfSize:14.0f],NSFontAttributeName,nil];
//    [_segmentControl setTitleTextAttributes:attributeDict forState:UIControlStateNormal];
//    [_segmentControl setTitleTextAttributes:attributeDict forState:UIControlStateSelected];
    [self.view addSubview:_segmentControl];
    
    
}
- (void)creatSearchWithText:(NSString *)text
{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 40)];
    _searchBar.delegate = self;
    _searchBar.searchBarStyle = UISearchBarStyleDefault;
//    [_searchBar setImage:[UIImage imageNamed:@"search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    _searchBar.placeholder = text;
    [self.view addSubview:_searchBar];
}

- (void)creatListTitleWithTitle:(NSArray *)titleArr hadButton:(BOOL) isHasBtn withsearchBar:(BOOL) hassearch
{
    CGRect rect ;
    CGFloat heigh;
    CGFloat x;
    if (hassearch) {
        heigh = 104;
    }else{
        heigh = 94;
    }
    if (isHasBtn) {
        x = 0.0f;
    }else{
        x = 0.0f;
    }
    rect = CGRectMake(x, heigh, self.view.frame.size.width, headBtnHeight);
    _titleView = [[UIView alloc] initWithFrame:rect];
    _titleView.backgroundColor  = [UIColor colorWithWhite:0.85 alpha:1];

        for (int i = 0; i < titleArr.count; i ++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(headBtnWidth * i, 0, headBtnWidth, headBtnHeight)];
            btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            if(i == 0){
                btn.selected = YES;
                _selectedBtn = btn;
            }
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_titleView addSubview: btn];
            
            _titleView.tag = 9999;
//             NSLog(@"%@",NSStringFromCGRect(btn.frame));
        }
    if (isHasBtn) {
        [self creatTopSegment];
    }
     [self.view addSubview:_titleView];
    
   
}
#pragma mark --创建点击伸展的按钮
//创建点击伸展的按钮
- (void)creatTopSegment
{
//    _btn = [[SQButton alloc] initWithFrame:CGRectMake(0, 0, TopBtnWidth, headBtnHeight)];
//    
//    [_btn setTitle:@"全部" forState:UIControlStateNormal];
//    
//    [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_btn setTitleColor:[UIColor colorWithWhite:0.3 alpha:0.8] forState:UIControlStateSelected];
//    [_btn addTarget:self action:@selector(topBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [_titleView addSubview:_btn];
    
    
     NSArray *titleArr = @[@"按等级统计",@"按竞争对手统计"];
    _topSegment = [[UISegmentedControl alloc] initWithItems:titleArr];
    _topSegment.selectedSegmentIndex = 0;
    _topSegment.tag = 9998;
    [_topSegment addTarget:self action:@selector(detailBtnClick) forControlEvents:UIControlEventValueChanged];
    _topSegment.frame = CGRectMake(0, 64 + 5, 300, 30);
    _topSegment.center = CGPointMake(self.view.width / 2.0 , 64 + _topSegment.height / 2.0);
    [self.view addSubview:_topSegment];
//    CGFloat height;
//    CGFloat firstBtnH;
//    CGFloat secBtnH;
//    //计算两个按钮的高度
//    firstBtnH = [titleArr[0] boundingRectWithSize:CGSizeMake(TopBtnWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName : [UIColor blackColor]} context:nil].size.height;
//    secBtnH = [titleArr[1] boundingRectWithSize:CGSizeMake(TopBtnWidth, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName : [UIColor blackColor]} context:nil].size.height;
//    height = firstBtnH + secBtnH;
//    
//    _btnView =  [[UIView alloc] initWithFrame:CGRectMake( 0, 64, TopBtnWidth, headBtnHeight + secBtnH)];
//    _btnView.userInteractionEnabled = YES;
//    _btnView.alpha = 1;
//    _btnView.backgroundColor = [UIColor redColor];
//    
//   
//    
//   
//    SQButton *fBtn = [[SQButton alloc] initWithFrame:CGRectMake(0, 0, TopBtnWidth, headBtnHeight)];
//    [fBtn setTitle:titleArr[0] forState:UIControlStateNormal];
//    [fBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [fBtn setBackgroundColor:[UIColor lightGrayColor]];
//    fBtn.titleLabel.numberOfLines = 0;
//    [fBtn setTitleColor:[UIColor colorWithWhite:0.4 alpha:0.8] forState:UIControlStateSelected];
//    fBtn.layer.borderWidth = 0.5;
//    fBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
//    [fBtn addTarget:self action:@selector(detailBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    _btn = fBtn;
//    [_btnView addSubview:fBtn];
//    
//    SQButton *sBtn = [[SQButton alloc] initWithFrame:CGRectMake(0, fBtn.maxY, TopBtnWidth, secBtnH)];
//    [sBtn setTitle:titleArr[1] forState:UIControlStateNormal];
//    [sBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [sBtn setBackgroundColor:[UIColor lightGrayColor]];
//    sBtn.titleLabel.numberOfLines = 0;
//    [sBtn setTitleColor:[UIColor colorWithWhite:0.4 alpha:0.8] forState:UIControlStateSelected];
//    sBtn.layer.borderWidth = 0.5;
//    sBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
//    [sBtn addTarget:self action:@selector(detailBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [_btnView addSubview:sBtn];
//    
//    if (_btnView.alpha == 0) {
//        _btn.isSelected = NO;
//    }
//    [self.view insertSubview:_btnView aboveSubview:_tableView];
}
//点击按钮伸展
//- (void)topBtnClick
//{
//    NSLog(@"hsh");
//    if (_btn.isSelected == NO) {
//        [UIView animateWithDuration:0.25 animations:^{
//            _btnView.alpha = 1;
//            _btnView.frame = CGRectMake(0, _titleView.maxY, _btnView.width, _btnView.height);
//
//        }];
//        _btn.isSelected = YES;
//    }else{
//        [UIView animateWithDuration:0.25 animations:^{
//            
//            _btnView.frame = CGRectMake(0, _titleView.maxY-20, TopBtnWidth, 50);
//            _btnView.alpha = 0.5;
//        } completion:^(BOOL finished) {
//            _btnView.alpha = 0;
//        }];
//        _btn.isSelected = NO;
//    }
//}

//具体统计方式按钮的点击
- (void)detailBtnClick
{

}
#pragma mark --tableView的创建
- (void)creatTableVieWithSearchBar:(BOOL)hasSearch
{
    CGRect rect;
    if (hasSearch) {
        rect = CGRectMake(0,_titleView.maxY, self.view.width, self.view.height - SegViewHeight - _titleView.maxY);
//        NSLog(@"have search %@",NSStringFromCGRect(_titleView.frame));
    }else{
    rect =  CGRectMake(0, _titleView.height + _topSegment.height + 64, self.view.width, self.view.height - SegViewHeight - _titleView.maxY);
//        NSLog(@" no search %@",NSStringFromCGRect(_titleView.frame));
//        NSLog(@"%f",_titleView.maxY);
    }
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;

    
    _tableView.delegate = self;
    _tableView.dataSource = self;

    
//    [_btnView removeFromSuperview];
      [self.view addSubview:_btnView];
  
      [self.view insertSubview:_tableView atIndex:0];
//    
   _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       //
       [self getData];
   }];
//
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //下啦加载更多
        [self getData];
    }];

}
#pragma mark --tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 30;
    //    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.role == 0) {
        if (_segmentControl.selectIndex == 0) {
            ManagerVillageCell *cell1 = [ManagerVillageCell cellWithTableView:tableView];
            
            cell1.count = [_managerArray[0] count];
            
            cell1.array1 = _managerArray[0];
            if (indexPath.row %2 == 0) {
                cell1.backgroundColor = [UIColor whiteColor];
            }else{
                cell1.backgroundColor = [UIColor colorWithRed:(20.0f/255.0f) green:(30.0f/255.0f) blue:(40.0f/255.0f) alpha:0.1f];
            }
            
            return cell1;
        }else{
            ExpandTalkingVillageCell *cell2 = [ExpandTalkingVillageCell cellWithTableView:tableView];
            
            cell2.count = [_managerArray[0] count];
            
            cell2.array2 = _managerArray[0];
            cell2.selectionStyle = UITableViewCellSelectionStyleBlue;
            if (indexPath.row %2 == 0) {
                cell2.backgroundColor = [UIColor whiteColor];
            }else{
                cell2.backgroundColor = [UIColor colorWithRed:(20.0f/255.0f) green:(30.0f/255.0f) blue:(40.0f/255.0f) alpha:0.1f];
            }
            return cell2;
        }
    }else {
        ManagerVillageCell *cell1 = [ManagerVillageCell cellWithTableView:tableView];
        if (_segmentControl.selectIndex == 0) {
            cell1.count = [_managerArray[0] count];
            cell1.array1 = _managerArray[0];
            if (indexPath.row %2 == 0) {
                cell1.backgroundColor = [UIColor whiteColor];
            }else{
                cell1.backgroundColor = [UIColor colorWithRed:(20.0f/255.0f) green:(30.0f/255.0f) blue:(40.0f/255.0f) alpha:0.1f];
            }
            
        }else{
        
            cell1.count = [_managerArray[0] count];
            
            cell1.array1 = _managerArray[0];
            cell1.selectionStyle = UITableViewCellSelectionStyleBlue;
            if (indexPath.row %2 == 0) {
                cell1.backgroundColor = [UIColor whiteColor];
            }else{
                cell1.backgroundColor = [UIColor colorWithRed:(20.0f/255.0f) green:(30.0f/255.0f) blue:(40.0f/255.0f) alpha:0.1f];
            }
            
        }
       return cell1;
    }
    return nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SubDistrictDetailController *detailControll = [[SubDistrictDetailController alloc] init];
    
    [self.navigationController pushViewController:detailControll animated:YES];
    
}
#pragma mark --SegmentView的代理方法
- (void)segmentView:(SegmentView *)segment didSelectIndex:(NSInteger)index
{
    NSIndexPath *indexPath;

  
    if (self.role == 0) {
        
        UIView * v = [self.view viewWithTag:9999];
        [v removeFromSuperview];
        [_topSegment removeFromSuperview];
        
        if (index == 0) {
            
            if (self.navigationItem.rightBarButtonItem == nil) {
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightBtnClick)];
            }
//            _tableView.backgroundColor = [UIColor cyanColor];
            _btnTitleArray = @[@"小区名称",@"城市",@"负责人",@"创建人"];
            _segmentControl.selectIndex = (int)index;
            [_managerArray removeAllObjects];
            
            [_searchBar removeFromSuperview];
            [self creatSearchWithText:@"小区名字/城市/负责人/创建人"];
            
//            [_tableView setContentOffset:CGPointMake(0, 34) animated:NO];
            [self creatListTitleWithTitle:_btnTitleArray hadButton:NO withsearchBar:YES];
            
        }else {
            
            self.navigationItem.rightBarButtonItem = nil;
            _btnTitleArray = @[@"小区名称",@"负责人"];
//            _tableView.backgroundColor = [UIColor brownColor];
            _segmentControl.selectIndex = (int)index;
            [_managerArray removeAllObjects];
//            [_tableView setContentOffset:CGPointMake(0, 34) animated:NO];
            
            [_searchBar removeFromSuperview];
            [self creatSearchWithText:@"小区名称/负责人"];
            
            [self creatListTitleWithTitle:_btnTitleArray hadButton:NO withsearchBar:YES];
        }
        
        NSArray *arr = [NSArray array];
        
        if (_btnTitleArray.count == 4 ) {
            arr = @[@"浪诗物业",@"南京",@"小明",@"德玛西亚"];
        }else if (_btnTitleArray.count == 2){
            arr = @[@"浪诗物业",@"德玛西亚"];
        }
        [_managerArray addObject:arr];
        [_tableView reloadData];
    }else{
        
        UIView * v = [self.view viewWithTag:9999];
        [v removeFromSuperview];
        [_topSegment removeFromSuperview];

        if (index == 0) {
            
            self.navigationItem.rightBarButtonItem = nil;
            _segmentControl.selectIndex = (int)index;
            _btnView.alpha = 0;
            [_searchBar removeFromSuperview];
//            _tableView.backgroundColor = [UIColor cyanColor];
            _btnTitleArray = @[@"序号",@"等级",@"数量",@"百分比"];
            [_managerArray removeAllObjects];
            _tableView.frame = CGRectMake(0,_titleView.maxY + _topSegment.height -_searchBar.height  , self.view.width, self.view.height - SegViewHeight - _titleView.maxY + _searchBar.height);
            [self creatListTitleWithTitle:_btnTitleArray hadButton:YES withsearchBar:NO];
            NSArray *arr = [NSArray array];
            arr = @[@"浪诗物业",@"南京",@"小明",@"德玛西亚"];
            [_managerArray addObject:arr];
//            [_tableView setContentOffset:CGPointMake(0, 34) animated:NO];
            [_tableView reloadData];
            
        }else if(index == 1){
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightBtnClick)];
            [_topSegment removeFromSuperview];
            _segmentControl.selectIndex = (int)index;
             _btnView.alpha = 0;
            _btnTitleArray = @[@"小区名称",@"城市",@"负责人",@"创建人"];;
//            _tableView.backgroundColor = [UIColor brownColor];
            [_managerArray removeAllObjects];
            [self creatSearchWithText:@"小区名称/城市/负责人/创建人"];
            [self creatListTitleWithTitle:_btnTitleArray hadButton:NO withsearchBar:YES];
            _tableView.frame = CGRectMake(0,_titleView.maxY, self.view.width, self.view.height - SegViewHeight - _titleView.maxY );
            
            NSArray *arr = [NSArray array];
            arr = @[@"浪诗物业",@"南京",@"小明",@"德玛西亚"];
            [_managerArray addObject:arr];
//            [_tableView setContentOffset:CGPointMake(0, 34) animated:NO];
            [_tableView reloadData];
            
        }
        
        NSArray *arr = [NSArray array];
        
        if (_btnTitleArray.count == 4 ) {
            arr = @[@"浪诗物业",@"南京",@"小明",@"德玛西亚"];
        }else if (_btnTitleArray.count == 2){
            arr = @[@"浪诗物业",@"德玛西亚"];
        }

        [_tableView reloadData];
    
    }
}
//- (void)segmentVauleChanged
//{
//    if (self.role == 0) {
//        
//        UIView * v = [self.view viewWithTag:9999];
//        [v removeFromSuperview];
//        
//        if (_segmentControl.selectIndex == 0) {
//            
//            
//            _tableView.backgroundColor = [UIColor cyanColor];
//            _btnTitleArray = @[@"小区名称",@"城市",@"负责人",@"创建人"];
//            [_managerArray removeAllObjects];
//            
//            [self creatListTitleWithTitle:_btnTitleArray];
//            
//        }else if(_segmentControl.selectIndex == 1){
//            
//            _btnTitleArray = @[@"小区名称",@"负责人"];
//            _tableView.backgroundColor = [UIColor brownColor];
//            [_managerArray removeAllObjects];
//            
//            [self creatListTitleWithTitle:_btnTitleArray];
//        }else{
//            //         NSLog(@"2");
//            _btnTitleArray = @[@"小区名称",@"负责人"];
//            _tableView.backgroundColor = [UIColor greenColor];
//            [_managerArray removeAllObjects];
//            
//            [self creatListTitleWithTitle:_btnTitleArray];
//        }
//        
//        
//        NSArray *arr = [NSArray array];
//        
//        if (_btnTitleArray.count == 4 ) {
//            arr = @[@"浪诗物业",@"南京",@"小明",@"德玛西亚"];
//        }else if (_btnTitleArray.count == 2){
//            arr = @[@"浪诗物业",@"德玛西亚"];
//        }
//        
//        
//        NSLog(@"after remove == %@",_managerArray);
//        [_managerArray addObject:arr];
//        NSLog(@"after remove == %@",_managerArray);
//        [_tableView reloadData];
//    }
//    
//}

#pragma mark --列表字节按钮点击
- (void)btnClick:(UIButton *)btn
{
    
}
#pragma mark --点击 ＋ 号
- (void)rightBtnClick
{
    NewDistrictController *newVC = [[NewDistrictController alloc] init];
    [self.navigationController pushViewController:newVC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

// 拉开左侧:点击.
- (void)sideLeftButton_selector:(id)sender {
    
    NSLog(@"SubdistrictViewController...");
    [self.revealController toggleSidebar:!self.revealController.sidebarShowing duration:kGHRevealSidebarDefaultAnimationDuration];
}

@end
