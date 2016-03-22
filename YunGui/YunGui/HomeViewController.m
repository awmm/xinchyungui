//
//  HomeViewController.m
//  YunGui
//
//  Created by wmm on 15/11/5.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "HomeViewController.h"
#import "VisitListCell.h"
#import "VisitDetailViewController.h"
#import "NewVisitViewController.h"
#import "MJRefresh.h"
#import "SideMenuUtil.h"


#define CellHeight [UIView getWidth:80.0f]

#pragma mark -
#pragma mark Constants
const CGFloat TableCellHeight = 80.0f;
static const CGFloat MJDuration = 2.0;

@interface HomeViewController ()

//@property (strong, nonatomic) NSString *userRole;

@property (strong, nonatomic) UITableView *visitTableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (nonatomic) BOOL isSearching;

@property (nonatomic, assign) NSInteger manageViewNum;
@property (strong, nonatomic) UIView *statisticsView;//人员统计
@property (strong, nonatomic) UIView *areaVisitView;//辖区拜访
@property (strong, nonatomic) UITableView *statisticsTableView;//人员统计
@property (strong, nonatomic) UITableView *areaVisitTableView;//辖区拜访
@property (strong, nonatomic) UISegmentedControl *segment;

@property (nonatomic, assign) NSInteger manageViewNum2;
@property (strong, nonatomic) UIView *statisticsView2;//办事处统计
@property (strong, nonatomic) UIView *allVisitView;//所有拜访
@property (strong, nonatomic) UITableView *statisticsTableView2;//人员统计
@property (strong, nonatomic) UITableView *allVisitTableView;//所有拜访
@property (strong, nonatomic) UISegmentedControl *segment2;

@property (strong, nonatomic) NSMutableArray *records;
@property (strong, nonatomic) NSMutableArray *allRecords;

- (void)sideLeftButton_selector:(id)sender;

@end

@implementation HomeViewController

@synthesize revealController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"%f",self.view.bounds.origin.x);
    NSLog(@"%f",self.view.bounds.origin.y);
    NSLog(@"%f",self.view.frame.size.width);
    NSLog(@"%f",self.view.frame.size.height);
    NSLog(@"%f-%f",kScreenHeight,kScreenWidth);
        self.view.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight);
    //2016-03-17 17:02:48.131 YunGui[2312:322202] 0.000000
//    2016-03-17 17:02:48.131 YunGui[2312:322202] 0.000000
//    2016-03-17 17:02:48.131 YunGui[2312:322202] 414.000000
//    2016-03-17 17:02:48.131 YunGui[2312:322202] 736.000000
//    2016-03-17 17:02:48.132 YunGui[2312:322202] 736.000000-414.000000
    
    [SideMenuUtil addViewGesture:self revealController:revealController];
    
    //set NavigationBar 背景颜色&title 颜色
    [ViewTool setNavigationBar:self.navigationController.navigationBar];
    
    self.navigationItem.leftBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithString:@"list.png" WithAction:@selector(sideLeftButton_selector:)];
    self.navigationItem.rightBarButtonItem=[ViewTool getBarButtonItemWithTarget:self WithString:@"search.png" WithAction:@selector(showSearchView)];
    

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    int userRole = [[userDefaultes objectForKey:@"roleId"] intValue];
//    [self getData];
    if (userRole == 4) {
        self.navigationItem.title = @"我的拜访";
//        [self drawTopView:self.view];
        [self drawTableView];
    }else if (userRole == 3){
        
        self.navigationItem.title = @"拜访管理";
        [self drawBottomView];
        
        _statisticsView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, kScreenHeight-40)];
        [self.view addSubview:_statisticsView];
        
        _areaVisitView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, kScreenHeight-40)];
        [self.view addSubview:_areaVisitView];
        _areaVisitView.hidden = YES;
        
//        [self drawTopView2];
        [self drawTableView2];
    }else if (userRole == 2){
        
        self.navigationItem.title = @"拜访管理";
        [self drawBottomView2];
        
        _statisticsView2 = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, kScreenHeight-40)];
        [self.view addSubview:_statisticsView2];
        
        _allVisitView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, kScreenHeight-40)];
        [self.view addSubview:_allVisitView];
        _allVisitView.hidden = YES;
        
//        [self drawTopView3];
        [self drawTableView3];
    }else{
        self.navigationItem.title = @"我的拜访";
//        [self drawTopView:self.view];
        [self drawTableView];
    }
        [self drawAddBtn];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickToNewVisit{
    NewVisitViewController *newVisitViewController = [[NewVisitViewController alloc] init];
    [self.navigationController pushViewController:newVisitViewController animated:YES];
    
}

- (void)drawAddBtn{
    
    UIButton *button = [ViewTool getAddButtonWithTarget:self WithString:@"add.png" WithAction:@selector(clickToNewVisit)];
    [self.view addSubview:button];
    [self.view bringSubviewToFront:button];
}

//商务经理
-(void)drawTopView:(UIView *)subView
{
    
    
    
    
//    _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0.0f, 44.0f, self.view.width, 44.0f)];
//    _searchBar.placeholder=@"小区名称/物业名称/拜访时间";
//    _searchBar.backgroundColor = [UIColor blueColor];
//    _searchBar.hidden = YES;
//    _searchBar.delegate = self;
//    
//    [subView addSubview:_searchBar];
//    
//    NSLog(@"%f",_searchBar.frame.size.height);
//    NSArray * labArray=@[@"编号",@"小区",@"物业",@"拜访时间"];
//    for (int i=0; i<4; i ++)
//    {
//        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/4*i, 152.0f, kScreenWidth/4, 40.0f)];
//        label.text=labArray[i];
//        label.textAlignment=NSTextAlignmentCenter;
//        [subView addSubview:label];
//    }
//    
//    UIView * lineView=[[UIView alloc]initWithFrame:CGRectMake(0.0f, 191.0f, kScreenWidth, 1.0f)];
//    lineView.backgroundColor=[UIColor lightGrayColor];
//    [subView addSubview:lineView];
}
-(void)drawTableView
{
    _visitTableView=[[UITableView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _visitTableView.delegate=self;
    _visitTableView.dataSource=self;
    _visitTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

//    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _visitTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf loadNewData];
        [self loadNewData];
    }];
    
    // 马上进入刷新状态
    [_visitTableView.mj_header beginRefreshing];
    
    
    _visitTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf loadMoreData];
        [self loadMoreData];
    }];
    [self.view addSubview:_visitTableView];
}

//UISegmentedControl
- (void)changeManegeView:(UISegmentedControl *)control{
    if (_segment.selectedSegmentIndex == 0) {
        _manageViewNum = 0;
        _statisticsView.hidden = NO ;
        _areaVisitView.hidden = YES;
        
    }else{
        _manageViewNum = 1;
        _statisticsView.hidden = YES ;
        _areaVisitView.hidden = NO;
    }
}

- (void)changeManegeView2:(UISegmentedControl *)control{
    if (_segment2.selectedSegmentIndex == 0) {
        _manageViewNum2 = 0;
        _statisticsView2.hidden = NO ;
        _allVisitView.hidden = YES;
        
    }else{
        _manageViewNum2 = 1;
        _statisticsView2.hidden = YES ;
        _allVisitView.hidden = NO;
    }
}

//城市总监
- (void)drawBottomView{
    NSArray *arr = [[NSArray alloc]initWithObjects:@"人员统计",@"辖区拜访", nil];
    _segment = [[UISegmentedControl alloc]initWithItems:arr];
    //在没有设置[segment setApportionsSegmentWidthsByContent:YES]时，每个的宽度按segment的宽度平分
    _segment.frame = CGRectMake(0, kScreenHeight-40, kScreenWidth, 40);
    _segment.selectedSegmentIndex = 0;
    _segment.tintColor = [UIColor lightGrayColor];
    [_segment addTarget:self action:@selector(changeManegeView:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segment];

}
-(void)drawTopView2
{
    NSArray * labArray=@[@"姓名",@"当日拜访数",@"本周拜访数",@"本月拜访数"];
    for (int i=0; i<4; i ++)
    {
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/4*i, 64.0f, kScreenWidth/4, 40.0f)];
        label.text=labArray[i];
        label.textAlignment=NSTextAlignmentCenter;
        [self.statisticsView addSubview:label];
    }
        
    UIView * lineView=[[UIView alloc]initWithFrame:CGRectMake(0.0f, 103.0f, kScreenWidth, 1.0f)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [self.statisticsView addSubview:lineView];
    
    [self drawTopView:_areaVisitView];
    
}
-(void)drawTableView2
{
    _statisticsTableView=[[UITableView alloc]initWithFrame:CGRectMake(0.0f, 64.0f, kScreenWidth, kScreenHeight-144) style:UITableViewStylePlain];
    _statisticsTableView.delegate=self;
    _statisticsTableView.dataSource=self;
    [_statisticsView addSubview:_statisticsTableView];

    _areaVisitTableView=[[UITableView alloc]initWithFrame:CGRectMake(0.0f, 64.0f, kScreenWidth, kScreenHeight-232) style:UITableViewStylePlain];
    _areaVisitTableView.delegate=self;
    _areaVisitTableView.dataSource=self;
    [_areaVisitView addSubview:_areaVisitTableView];
}

//管理层
- (void)drawBottomView2{
    NSArray *arr = [[NSArray alloc]initWithObjects:@"办事处统计",@"所有拜访", nil];
    _segment2 = [[UISegmentedControl alloc]initWithItems:arr];
    //在没有设置[segment setApportionsSegmentWidthsByContent:YES]时，每个的宽度按segment的宽度平分
    _segment2.frame = CGRectMake(0, kScreenHeight-40, kScreenWidth, 40);
    _segment2.selectedSegmentIndex = 0;
    _segment2.tintColor = [UIColor lightGrayColor];
    [_segment2 addTarget:self action:@selector(changeManegeView2:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segment2];
    
}

-(void)drawTopView3
{
    NSArray * labArray=@[@"办事处名称",@"当日拜访数",@"本周拜访数",@"本月拜访数"];
    for (int i=0; i<4; i ++)
    {
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/4*i, 64.0f, kScreenWidth/4, 40.0f)];
        label.text=labArray[i];
        label.textAlignment=NSTextAlignmentCenter;
        [self.statisticsView2 addSubview:label];
    }
    
    UIView * lineView=[[UIView alloc]initWithFrame:CGRectMake(0.0f, 103.0f, kScreenWidth, 1.0f)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [self.statisticsView2 addSubview:lineView];
    
    [self drawTopView:_allVisitView];
    
}
-(void)drawTableView3
{
    _statisticsTableView2=[[UITableView alloc]initWithFrame:CGRectMake(0.0f, 64.0f, kScreenWidth, kScreenHeight-144) style:UITableViewStylePlain];
    _statisticsTableView2.delegate=self;
    _statisticsTableView2.dataSource=self;
    [_statisticsView2 addSubview:_statisticsTableView2];
    
    _allVisitTableView=[[UITableView alloc]initWithFrame:CGRectMake(0.0f, 64.0f, kScreenWidth, kScreenHeight-232) style:UITableViewStylePlain];
    _allVisitTableView.delegate=self;
    _allVisitTableView.dataSource=self;
    [_allVisitView addSubview:_allVisitTableView];
}

- (void)showSearchView{
}

- (void)getData{
//    NSString *str = @"http://192.168.55.104:7001/htsc-zxll-web/rpt_app_banks_cat_list.do?workNo=MDAyNzQ5&isReSearch=isReSearch";
    NSString *str = @"";
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
//        NSLog(@"获取到的数据为：%@%@",dict,responseObject);
        
//        NSArray *a = dict;
//        for (int i = 0; i < a.count; i++) {
//            NSLog(@"%@",a[i]);
//        }
        
        NSDictionary *dataDic = dict[0];
//        NSString *state = [dataDic objectForKey:@"state"];
//        NSLog(@"%@",state);
//        NSLog(@"%@",state.class);//        __NSCFNumber

        NSString *state = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"state"]];//NSTaggedPointerString

//        if ( [state isKindOfClass:NSNumber.class] )
//        {
//            stateStr = state.stringValue;
//        }

        if ([state isEqualToString:@"1"]) {
            NSLog(@"success");
//            NSString *page = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"page"]];
//            NSString *pageSize = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"pageSize"]];
//            NSString *totalPages = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"totalPages"]];
//            NSString *totalRecords = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"totalRecords"]];

            _allRecords = [dataDic valueForKey:@"records"];
            _records = _allRecords;
//            for (int i = 0; i < _records.count; i++) {
//                NSLog(@"%@",_records[i]);
//            }
//            [self.view addSubview:_visitTableView];
            
        }else{
            NSLog(@"fail");
            [Tools showMessage:@"获取数据失败" view:self];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
//        [Tools showMessage:@"访问超时" view:self];
    }];
//    [self.view addSubview:_visitTableView];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}


#pragma mark - 数据处理相关
#pragma mark 下拉刷新数据
- (void)loadNewData
{
    // 1.添加假数据
//    for (int i = 0; i<5; i++) {
//        [_allRecords insertObject:_records atIndex:0];
//    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_visitTableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [_visitTableView.mj_header endRefreshing];
//    });
}

#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    // 1.添加假数据
//    for (int i = 0; i<5; i++) {
//        [_allRecords addObject:_records];
//    }
    
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_visitTableView reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [_visitTableView.mj_footer endRefreshing];
    });
}

#pragma mark - UITableViewDataSource数据源方法
#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _records.count;
    return 20;
}

#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath是一个对象，记录了组和行信息
    static NSString *CellIdentifier = @"VisitListCell";
    VisitListCell *cell = (VisitListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[VisitListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
//    if (indexPath.row % 2 == 0) {
//        cell.backgroundColor = [UIColor whiteColor];
//    }else{
//        cell.backgroundColor = [UIColor colorWithRed:(20.0f/255.0f) green:(30.0f/255.0f) blue:(40.0f/255.0f) alpha:0.1f];
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (tableView == _visitTableView) {
//        cell.visitNum.text = [NSString stringWithFormat:@"%@",[_records[indexPath.row] objectForKey:@"id"]];
//        cell.visitSub.text = [NSString stringWithFormat:@"%@",[_records[indexPath.row] objectForKey:@"comname"]];
//        cell.visitPro.text = [NSString stringWithFormat:@"%@",[_records[indexPath.row] objectForKey:@"rptcat"]];
//        cell.visitDate.text = [NSString stringWithFormat:@"%@",[_records[indexPath.row] objectForKey:@"pubdate"]];
        cell.visitNum.text=@"xc1112";
        cell.visitSub.text=@"朗诗";
        cell.visitPro.text=@"朗诗物业";
        cell.visitDate.text=@"2015.11.12";
    }
    if (tableView == _statisticsTableView) {
        cell.visitNum.text=@"小明";
        cell.visitSub.text=@"5";
        cell.visitPro.text=@"12";
        cell.visitDate.text=@"46";
    }
    if (tableView == _areaVisitTableView) {
        cell.visitNum.text=@"xc1112";
        cell.visitSub.text=@"朗诗";
        cell.visitPro.text=@"朗诗物业";
        cell.visitDate.text=@"2015.11.12";
    }
    if (tableView == _statisticsTableView2) {
        cell.visitNum.text=@"上海办事处";
        cell.visitSub.text=@"15";
        cell.visitPro.text=@"72";
        cell.visitDate.text=@"555";
    }
    if (tableView == _allVisitTableView) {
        cell.visitNum.text=@"xc1112";
        cell.visitSub.text=@"朗诗";
        cell.visitPro.text=@"朗诗物业";
        cell.visitDate.text=@"2015.11.12";
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

/// 处理单元格点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    VisitDetailViewController *visitDetailVC=[[VisitDetailViewController alloc]init];
    [self.navigationController pushViewController:visitDetailVC animated:NO];
}

#pragma mark - 搜索框代理
#pragma mark  取消搜索
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    _isSearching=NO;
    _searchBar.text=@"";
    [_visitTableView reloadData];
    [_searchBar resignFirstResponder];
}

#pragma mark 输入搜索关键字
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([_searchBar.text isEqual:@""]){
        _isSearching=NO;
        [_visitTableView reloadData];
        return;
    }
    [_searchBar resignFirstResponder];
    [self searchDataWithKeyWord:_searchBar.text];
}

#pragma mark 点击虚拟键盘上的搜索时
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self searchDataWithKeyWord:_searchBar.text];
    [_searchBar resignFirstResponder];//放弃第一响应者对象，关闭虚拟键盘
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope NS_AVAILABLE_IOS(3_0){
    
    NSLog(@"%ld",(long)selectedScope);
    NSMutableArray *dateArr = [[NSMutableArray alloc]init];
    switch (selectedScope) {
        case 0:
            if(_allRecords != nil){
            _records = _allRecords;
            [_visitTableView reloadData];
            break;
            }
        case 1:{
            if(_allRecords != nil){
            [_allRecords enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if([Tools isDateThisDay:[obj objectForKey:@"pubdate"]]){
                    [dateArr addObject:obj];
                }
            }];
            _records = dateArr;
            dateArr = nil;
            [_visitTableView reloadData];
            }
            break;
        }
        case 2:{
            if(_allRecords != nil){
            [_allRecords enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if([Tools isDateThisWeek:[obj objectForKey:@"pubdate"]]){
                    [dateArr addObject:obj];
                }
            }];
            _records = dateArr;
            dateArr = nil;
            [_visitTableView reloadData];
            break;
        }
        }
        case 3:{
            if(_allRecords != nil){
            [_allRecords enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if([Tools isDateThisMonth:[obj objectForKey:@"pubdate"]]){
                    [dateArr addObject:obj];
                }
            }];
            _records = dateArr;
            dateArr = nil;
            [_visitTableView reloadData];
            break;
            }}
    }
}

#pragma mark 搜索形成新数据
-(void)searchDataWithKeyWord:(NSString *)keyWord{
    _isSearching=YES;
    NSLog(@"////");
    NSMutableArray *searchArr = [[NSMutableArray alloc]init];
    if(_allRecords != nil){
    [_allRecords enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *id = [NSString stringWithFormat:@"%@",[obj objectForKey:@"id"]];
        NSString *comname = [NSString stringWithFormat:@"%@",[obj objectForKey:@"comname"]];
        NSString *rptcat = [NSString stringWithFormat:@"%@",[obj objectForKey:@"rptcat"]];
        NSString *pubdate = [NSString stringWithFormat:@"%@",[obj objectForKey:@"pubdate"]];

        if ([id.uppercaseString containsString:keyWord.uppercaseString]||[comname.uppercaseString containsString:keyWord.uppercaseString]||[rptcat.uppercaseString containsString:keyWord.uppercaseString]||[pubdate containsString:keyWord]) {
//        [_records addObject:obj];
            [searchArr arrayByAddingObject:obj];
        }

    }];
                    
    _records = searchArr;
    
    //刷新表格
    [_visitTableView reloadData];
    }
}

// 拉开左侧:点击.
- (void)sideLeftButton_selector:(id)sender {
    
    [self.revealController toggleSidebar:!self.revealController.sidebarShowing duration:kGHRevealSidebarDefaultAnimationDuration];
}
@end
