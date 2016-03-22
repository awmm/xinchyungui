//
//  MenuListViewController.m
//  YunGui
//
//  Created by wmm on 15/11/5.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "MenuListViewController.h"
#import "SideMenuUtil.h"
#import "BranchStatisticController.h"
#import "YGNavigationController.h"
#import "HomeViewController.h"
#import "PropertyViewController.h"
#import "SubdistrictViewController.h"
#import "MapViewController.h"
#import "ViewController.h"

#define kSidebarCellTextKey	@"CellText"
#define kSidebarCellImageKey	@"CellImage"
#define kSidebarCellSelectImageKey	@"CellSelectImage"
#define kGHRevealSidebarWidth2 [UIView getWidth:200.0f]

@interface MenuListViewController (){
    NSArray *_cellInfos;	//!< 单元格信息.
    NSArray *_controllers;	//!< 导航控制器集.
}
@property (strong, nonatomic) UITableView *menuTableView;
@property (strong, nonatomic) UIButton *headImgBtn;
@property (strong, nonatomic) UILabel  *workNumLbl;
@property (strong, nonatomic) UIButton *logoutBtn;

@property (strong, nonatomic) UIView *overlayView;
@property (strong,nonatomic) UIImagePickerController * imagePikerViewController;
@property (strong,nonatomic) UIButton *takeButton;


@end

@implementation MenuListViewController

@synthesize revealController;
@synthesize roleId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置自身窗口尺寸
    self.view.frame = CGRectMake(0.0f, 0.0f, kGHRevealSidebarWidth2, CGRectGetHeight(self.view.bounds));
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    // 绑定主页为内容视图.
    if (YES) {

        YGNavigationController *ygNV = [[YGNavigationController alloc]initWithRootViewController:homeVC];
        [SideMenuUtil addNavigationGesture:ygNV revealController:revealController];
        [SideMenuUtil setRevealControllerProperty:ygNV revealController:revealController];
        revealController.contentViewController = ygNV;
    }
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    int userRole = [[userDefaultes objectForKey:@"roleId"] intValue];
    SubdistrictViewController *subVC = [[SubdistrictViewController alloc] init];
    PropertyViewController *proVC = [[PropertyViewController alloc] init];
    MapViewController *mapVC = [[MapViewController alloc] init];
    

    if(userRole == 4){

        _cellInfos = @[
                       @{kSidebarCellImageKey: [UIImage imageNamed:@"Btn_Normal_Baifang.png"], kSidebarCellSelectImageKey: [UIImage imageNamed:@"Btn_Push_Baifang.png"], kSidebarCellTextKey: NSLocalizedString(@"我的拜访", @"")},
                        @{kSidebarCellImageKey: [UIImage imageNamed:@"Btn_Normal_Guiti.png"], kSidebarCellSelectImageKey: [UIImage imageNamed:@"Btn_Push_Guiti.png"], kSidebarCellTextKey: NSLocalizedString(@"柜体验收", @"")},
                       @{kSidebarCellImageKey: [UIImage imageNamed:@"Btn_Normal_Wuye.png"], kSidebarCellSelectImageKey: [UIImage imageNamed:@"Btn_Push_Wuye.png"], kSidebarCellTextKey: NSLocalizedString(@"物业管理", @"")},
                       @{kSidebarCellImageKey: [UIImage imageNamed:@"Btn_Normal_Xiaoqu.png"], kSidebarCellSelectImageKey: [UIImage imageNamed:@"Btn_Push_Xiaoqu.png"], kSidebarCellTextKey: NSLocalizedString(@"小区管理", @"")},
                       @{kSidebarCellImageKey: [UIImage imageNamed:@"Btn_Normal_Mingpian.png"], kSidebarCellSelectImageKey: [UIImage imageNamed:@"Btn_Push_Mingpian.png"], kSidebarCellTextKey: NSLocalizedString(@"名片扫描", @"")},
                       @{kSidebarCellImageKey: [UIImage imageNamed:@"Btn_Normal_Ditu.png"], kSidebarCellSelectImageKey: [UIImage imageNamed:@"Btn_Push_Ditu.png"], kSidebarCellTextKey: NSLocalizedString(@"小区地图", @"")}
                       ];
        _controllers = @[
                         [[YGNavigationController alloc]initWithRootViewController:homeVC],
                         [[YGNavigationController alloc]initWithRootViewController:subVC],
                         [[YGNavigationController alloc]initWithRootViewController:subVC],
                         [[YGNavigationController alloc]initWithRootViewController:proVC],
                         @"scanning",
                         [[YGNavigationController alloc]initWithRootViewController:mapVC]
                         ];
                    NSLog(@"%d",userRole);
    }else{
        _cellInfos = @[
                       @{kSidebarCellImageKey: [UIImage imageNamed:@"Btn_Normal_Baifang.png"], kSidebarCellSelectImageKey: [UIImage imageNamed:@"Btn_Push_Baifang.png"], kSidebarCellTextKey: NSLocalizedString(@"拜访管理", @"")},
                       @{kSidebarCellImageKey: [UIImage imageNamed:@"Btn_Normal_Guiti.png"], kSidebarCellSelectImageKey: [UIImage imageNamed:@"Btn_Push_Guiti.png"], kSidebarCellTextKey: NSLocalizedString(@"小区管理", @"")},
                       @{kSidebarCellImageKey: [UIImage imageNamed:@"Btn_Normal_Wuye.png"], kSidebarCellSelectImageKey: [UIImage imageNamed:@"Btn_Push_Wuye.png"], kSidebarCellTextKey: NSLocalizedString(@"网点统计", @"")}
                        ];
        _controllers = @[
                        [[YGNavigationController alloc]initWithRootViewController:homeVC],
                        [[YGNavigationController alloc]initWithRootViewController:subVC],
                        [[YGNavigationController alloc]initWithRootViewController:proVC]
                        ];

    }
    
    // 添加手势.
    for (id obj in _controllers) {
        [SideMenuUtil setRevealControllerProperty:obj revealController:revealController];
        if ([obj isKindOfClass:UINavigationController.class]) {
            [SideMenuUtil addNavigationGesture:(UINavigationController*)obj revealController:revealController];
        }
    }
    
    // ui.
    [self createUI];
    
    self.imagePikerViewController = [[UIImagePickerController alloc] init];
    self.imagePikerViewController.delegate = self;
    self.imagePikerViewController.allowsEditing = YES;
}

- (void)viewDidUnload {
    [self setMenuTableView:nil];
    [super viewDidUnload];
}

- (void)createUI{
    UIColor *bgColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
    self.view.backgroundColor = bgColor;
    
    //    self.view.frame = CGRectMake(0.0f, 0.0f, kGHRevealSidebarWidth2, CGRectGetHeight(self.view.bounds));
    UIView *menuTopView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)/4)];
    
    self.headImgBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width-[UIView getWidth:60.0f])/2, [UIView getHeight:30.0f], [UIView getWidth:60.0f] , [UIView getWidth:60.0f])];
    self.headImgBtn.layer.cornerRadius = CGRectGetHeight(self.headImgBtn.bounds)/2;
    //    self.headImgBtn.layer.masksToBounds = CGRectGetHeight(self.headImgBtn.bounds)/2;//圆形
    self.headImgBtn.layer.masksToBounds = YES;//圆形
    self.headImgBtn.layer.borderWidth = 3.0;
    self.headImgBtn.layer.borderColor = [[UIColor yellowColor] CGColor];
    [self.headImgBtn setBackgroundImage:[UIImage imageNamed:@"headImg.png"] forState:UIControlStateNormal];
    //    [self.headImgBtn addTarget:self action:@selector(showSelectedImg:) forControlEvents:UIControlEventTouchUpInside];
    
    self.workNumLbl = [[UILabel alloc] initWithFrame:CGRectMake((self.view.width-[UIView getWidth:60.0f])/2, self.headImgBtn.maxY+[UIView getHeight:10.0f] , [UIView getWidth:60.0f] , [UIView getHeight:15.0f])];
    self.workNumLbl.text = [NSString stringWithFormat:@"姓名:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
    self.workNumLbl.textColor = [UIColor whiteColor];
    self.workNumLbl.font = [UIView getFontWithSize:12];
    self.workNumLbl.textAlignment = NSTextAlignmentCenter;
    
    self.logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-[UIView getWidth:30.0f], self.headImgBtn.maxY+[UIView getWidth:5.0f], [UIView getWidth:20.0f] , [UIView getWidth:20.0f])];
    [self.logoutBtn setBackgroundImage:[UIImage imageNamed:@"Btn_Normal_Zhuxiao.png"] forState:UIControlStateNormal];
    [self.logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    
    menuTopView.height = self.logoutBtn.maxY + [UIView getHeight:20.0f];
    menuTopView.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:menuTopView];
    [self.view addSubview:self.headImgBtn];
    [self.view addSubview:self.workNumLbl];
    [self.view addSubview:self.logoutBtn];
    
    self.menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, menuTopView.height, self.view.width, self.view.height-menuTopView.height)];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.backgroundColor = [UIColor clearColor];
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    self.menuTableView.scrollEnabled =NO; //设置tableview 不能滚动
    [self.view addSubview:self.menuTableView];
}

- (void)logout:(UIButton *)button{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"roleId"];
    [userDefaults removeObjectForKey:@"roleName"];
    [userDefaults removeObjectForKey:@"roleTag"];
    [userDefaults removeObjectForKey:@"userId"];
    [userDefaults removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    ViewController *viewController = [[ViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    // 设置自身窗口尺寸
    self.view.frame = CGRectMake(0.0f, 0.0f, kGHRevealSidebarWidth2, CGRectGetHeight(self.view.bounds));
}


-(void)takePhoto{
    //拍照，会自动回调- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info，对于自定义照相机界面，拍照后回调可以不退出实现连续拍照效果
    NSLog(@"takePicture...");
    [self.imagePikerViewController takePicture];
    [SVProgressHUD showWithStatus:@"识别中"];
    self.takeButton.hidden = YES;
}

- (UIView *)drawCameraView {
    UIView* cameraView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight)];
    
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    upView.alpha = 0.5;
    upView.backgroundColor = [UIColor blackColor];
    [cameraView addSubview:upView];
    
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 35, kScreenHeight-110)];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
    [cameraView addSubview:leftView];
    
    UIView* rightView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-35, 30, 35, kScreenHeight-110)];
    rightView.alpha = 0.5;
    rightView.backgroundColor = [UIColor blackColor];
    [cameraView addSubview:rightView];
    
    //    UIView* middleView = [[UIView alloc] initWithFrame:CGRectMake(35, 30, kScreenWidth-70, kScreenHeight-110)];
    UIView* middleView = [[UIView alloc] initWithFrame:CGRectMake(35, 30, kScreenWidth-70, kScreenHeight-150)];
    middleView.alpha = 1;
    [cameraView addSubview:middleView];
    
    UIView * downView1 = [[UIView alloc] initWithFrame:CGRectMake(35, kScreenHeight-120, kScreenWidth-70, 40)];
    downView1.alpha = 0.5;
    downView1.backgroundColor = [UIColor blackColor];
    [cameraView addSubview:downView1];
    
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-80, kScreenWidth, 80)];
    downView.alpha = 1;
    //    NSString *bg_path = [[NSBundle mainBundle] pathForResource:@"uexCardRec/card_bg" ofType:@"png"];
    //    UIImage *bg_img = [UIImage imageWithContentsOfFile:bg_path];
    UIImage *bg_img = [UIImage imageNamed:@"card_bg.png"];
    downView.backgroundColor = [UIColor colorWithPatternImage:bg_img];
    [cameraView addSubview:downView];
    
    self.takeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.takeButton.alpha = 1;
    //      NSString *path = [[NSBundle mainBundle] pathForResource:@"uexCardRec/shot" ofType:@"png"];
    //      UIImage *img = [UIImage imageWithContentsOfFile:path];
    UIImage *img = [UIImage imageNamed:@"shot.png"];
    [self.takeButton setImage:img forState:UIControlStateNormal];
    [self.takeButton setFrame:CGRectMake(kScreenWidth/2-30, kScreenHeight-65, 50, 50)];
    [self.takeButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [cameraView addSubview:self.takeButton];
    
    
    //用于取消操作的button
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.alpha = 1;
    [cancelButton setFrame:CGRectMake(kScreenWidth-70, kScreenHeight-65, 50, 50)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [cancelButton addTarget:self action:@selector(cancelCamera) forControlEvents:UIControlEventTouchUpInside];
    [cameraView addSubview:cancelButton];
    
    
    UIView* leftUpLine = [[UIView alloc] initWithFrame:CGRectMake(35, 30, 3, 20)];
    leftUpLine.alpha = 1;
    leftUpLine.backgroundColor = [UIColor redColor];
    [cameraView addSubview:leftUpLine];
    
    UIView* leftUpLine2 = [[UIView alloc] initWithFrame:CGRectMake(35, 30, 20, 3)];
    leftUpLine2.alpha = 1;
    leftUpLine2.backgroundColor = [UIColor redColor];
    [cameraView addSubview:leftUpLine2];
    
    UIView* rightUpLine = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-38, 30, 3, 20)];
    rightUpLine.alpha = 1;
    rightUpLine.backgroundColor = [UIColor redColor];
    [cameraView addSubview:rightUpLine];
    
    UIView* rightUpLine2 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-55, 30, 20, 3)];
    rightUpLine2.alpha = 1;
    rightUpLine2.backgroundColor = [UIColor redColor];
    [cameraView addSubview:rightUpLine2];
    
    UIView* leftButLine = [[UIView alloc] initWithFrame:CGRectMake(35, kScreenHeight-140, 3, 20)];
    leftButLine.alpha = 1;
    leftButLine.backgroundColor = [UIColor redColor];
    [cameraView addSubview:leftButLine];
    
    UIView* leftButLine2 = [[UIView alloc] initWithFrame:CGRectMake(35, kScreenHeight-122, 20, 3)];
    leftButLine2.alpha = 1;
    leftButLine2.backgroundColor = [UIColor redColor];
    [cameraView addSubview:leftButLine2];
    
    UIView* rightButLine = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-38, kScreenHeight-140, 3, 20)];
    rightButLine.alpha = 1;
    rightButLine.backgroundColor = [UIColor redColor];
    [cameraView addSubview:rightButLine];
    
    UIView* rightButLine2 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-55, kScreenHeight-122, 20, 3)];
    rightButLine2.alpha = 1;
    rightButLine2.backgroundColor = [UIColor redColor];
    [cameraView addSubview:rightButLine2];
    
    return cameraView;
}


//startScanning
- (void)startScanning{
    self.imagePikerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePikerViewController.delegate = self;
    self.imagePikerViewController.showsCameraControls = NO;
    self.overlayView.frame = self.imagePikerViewController.cameraOverlayView.frame;
    self.overlayView.backgroundColor = [UIColor clearColor];
    self.imagePikerViewController.cameraOverlayView = [self drawCameraView];
    
    // 相机全屏
    CGSize screenBounds = [UIScreen mainScreen].bounds.size;
    CGFloat cameraAspectRatio = 4.0f/3.0f;
    CGFloat camViewHeight = screenBounds.width * cameraAspectRatio;
    CGFloat scale = screenBounds.height / camViewHeight;
    self.imagePikerViewController.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
    self.imagePikerViewController.cameraViewTransform = CGAffineTransformScale(self.imagePikerViewController.cameraViewTransform, scale, scale);
    
    [self presentViewController:self.imagePikerViewController animated:YES completion:NULL];
    

}
#pragma mark -
#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    HWCloudsdk *sdk = [[HWCloudsdk alloc] init];
    
    NSString *apiKey = @"b5777b52-f26c-4d1f-b834-c5a2053fe37e";
    NSLog(@"识别开始。。。");
    //    NSString *cardResult = [sdk cardLanguage:language cardImage: image apiKey:apiKey];
    NSString *cardResult = nil;
    [sdk cardLanguage:@"chns" cardImage:image apiKey:apiKey successBlock:^(id responseObject) {
        NSLog(@"%@",responseObject);
        //        cardResult = responseObject;
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    NSLog(@"识别结果。。。%@",cardResult);
    
    if(cardResult == nil || [cardResult isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"网络异常或超时,请稍后再试！"];
        [SVProgressHUD dismissWithDelay:1555.0];
        NSLog(@"识别失败。。。网络异常或超时");
        return;
    }
    
    NSData *data = [cardResult dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSDictionary * rootDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    NSLog(@"%@",rootDic);
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    
    NSString *code = [rootDic objectForKey:@"code"];
    if ([code isEqualToString:@"0"]) {
        
        [SVProgressHUD dismiss];
        
        NSArray *names = [rootDic objectForKey:@"name"];
        if (names.count > 0) {
            NSString *nameString = [names componentsJoinedByString:@","];
            [keyValues addObject:[NSString stringWithFormat:@"\"name\":\"%@\"",nameString]];
        }else{
            [keyValues addObject:@"\"name\":\"\""];
        }
        
        NSArray *faxs = [rootDic objectForKey:@"fax"];
        if (faxs.count > 0) {
            NSString *faxString = [faxs componentsJoinedByString:@","];
            [keyValues addObject:[NSString stringWithFormat:@"\"fax\":\"%@\"",faxString]];
        }else{
            [keyValues addObject:@"\"fax\":\"\""];
        }
        
        NSArray *telephones = [rootDic objectForKey:@"tel"];
        if (telephones.count > 0) {
            NSString *telephoneString = [telephones componentsJoinedByString:@","];
            [keyValues addObject:[NSString stringWithFormat:@"\"telephone\":\"%@\"",telephoneString]];
        }else{
            [keyValues addObject:@"\"telephone\":\"\""];
        }
        NSArray *cellphones = [rootDic objectForKey:@"mobile"];
        if (cellphones.count > 0) {
            NSString *cellphoneString = [cellphones componentsJoinedByString:@","];
            [keyValues addObject:[NSString stringWithFormat:@"\"cellphone\":\"%@\"",cellphoneString]];
        }else{
            [keyValues addObject:@"\"cellphone\":\"\""];
        }
        NSArray *organizations = [rootDic objectForKey:@"comp"];
        if (organizations.count > 0) {
            NSString *organizationString = [organizations componentsJoinedByString:@","];
            [keyValues addObject:[NSString stringWithFormat:@"\"organization\":\"%@\"",organizationString]];
        }else{
            [keyValues addObject:@"\"organization\":\"\""];
        }
        NSArray *emails = [rootDic objectForKey:@"email"];
        if (emails.count > 0) {
            NSString *emailString = [emails componentsJoinedByString:@","];
            [keyValues addObject:[NSString stringWithFormat:@"\"email\":\"%@\"",emailString]];
        }else{
            [keyValues addObject:@"\"email\":\"\""];
        }
        NSArray *addresss = [rootDic objectForKey:@"addr"];
        if (addresss.count > 0) {
            NSString *addressString = [addresss componentsJoinedByString:@","];
            [keyValues addObject:[NSString stringWithFormat:@"\"address\":\"%@\"",addressString]];
        }else{
            [keyValues addObject:@"\"address\":\"\""];
        }
        NSArray *urls = [rootDic objectForKey:@"web"];
        if (urls.count > 0) {
            NSString *urlString = [urls componentsJoinedByString:@","];
            [keyValues addObject:[NSString stringWithFormat:@"\"url\":\"%@\"",urlString]];
        }else{
            [keyValues addObject:@"\"url\":\"\""];
        }
        
        [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
        [reString appendString:@"}"];
        //        [self jsSuccessWithName:@"uexCardRec.cbResultCardInfo" opId:0 dataType:0 strData:reString];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"名片识别失败！"];
        [SVProgressHUD dismissWithDelay:1555.0];
    }
}


-(void)cancelCamera{
    [self.imagePikerViewController dismissViewControllerAnimated:YES completion:nil];
}

// 处理菜单项点击事件.
- (BOOL)onSelectRowAtIndexPath:(NSIndexPath *)indexPath hideSidebar:(BOOL)hideSidebar {
    BOOL rt = NO;
    do {
        if (nil==indexPath) break;
        
        // 获得当前项目.
        id controller = _controllers[indexPath.row];
        if (nil!=controller) {
            // 命令.
            if ([controller isKindOfClass:NSString.class]) {
                NSString* cmd = controller;
                if ([cmd isEqualToString:@"logout"]) {
                    [self cancelButton_selector:nil];
                    rt = YES;
                    break;
                }
                if ([cmd isEqualToString:@"scanning"]) {
                    [self startScanning];
                    rt = YES;
//                    if (hideSidebar) {
//                        [revealController toggleSidebar:NO duration:kGHRevealSidebarDefaultAnimationDuration];
//                    }
                    break;
                }
//                if ([cmd isEqualToString:@"BranchStatisticController"]) {
//                    controller = [[BranchStatisticController alloc] init];
//                    rt = YES;
//                    revealController.contentViewController = controller;
//                    if (hideSidebar) {
//                        [revealController toggleSidebar:NO duration:kGHRevealSidebarDefaultAnimationDuration];
//                    }
//                    break;
//                }
            }
            
            // 页面跳转.
            if ([controller isKindOfClass:UIViewController.class]) {
                rt = YES;
                revealController.contentViewController = controller;
                if (hideSidebar) {
                    [revealController toggleSidebar:NO duration:kGHRevealSidebarDefaultAnimationDuration];
                }
            }
        }
    } while (0);
    return rt;
}

/// 选择某个菜单项.
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
    [_menuTableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
    if (scrollPosition == UITableViewScrollPositionNone) {
        [_menuTableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    }
    [self onSelectRowAtIndexPath:indexPath hideSidebar:NO];
    NSLog(@"selectRowAtIndexPath: %@", revealController.contentViewController);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MenuListCell";
    MenuListCell *cell = (MenuListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MenuListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone; 
    NSDictionary *info = _cellInfos[indexPath.row];
    cell.defaultImage = info[kSidebarCellImageKey];
    cell.selectedImage = info[kSidebarCellSelectImageKey];
    cell.textLabel.text = info[kSidebarCellTextKey];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIView getHeight:40.0f];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [UIView getHeight:30.0f];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.menuTableView.frame.size.width, [UIView getHeight:30.0f])];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake([UIView getWidth:10.0f], [UIView getHeight:5.0f], self.menuTableView.frame.size.width-[UIView getWidth:10.0f]*2, [UIView getHeight:20.0f])];
//    lab.text = [self.indexArray objectAtIndex:section];
    lab.text = @"MENU";
    lab.font = [UIView getFontWithSize:14.0f];
    lab.textColor = [UIColor whiteColor];
    [view addSubview:lab];
    
    UIView *lineView = [ViewTool getLineViewWith:CGRectMake(0, [UIView getHeight:30.0f]-1, self.menuTableView.frame.size.width, 1) withBackgroudColor:[UIColor grayColor]];
    [view addSubview:lineView];
    
    return view;
}

/// 处理单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self onSelectRowAtIndexPath:indexPath hideSidebar:YES];
    NSLog(@"didSelectRowAtIndexPath: %@", revealController.contentViewController);
}

/// 取消按钮:点击.
- (void)cancelButton_selector:(id)sender {
    if (nil!=revealController) {
        [revealController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
