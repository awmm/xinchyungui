//
//  ViewController.m
//  YunGui
//
//  Created by wmm on 15/11/5.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "ViewController.h"
#import "MenuListViewController.h"
#import "GHRevealViewController.h"

#define LeftDistance [UIView getWidth:30.0f]

@interface ViewController ()

@property (nonatomic, strong) UITextField *userName;
@property (nonatomic, strong) UITextField *password;

@property (nonatomic, strong) UIButton *loginBtn;

//- (void)login:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, kScreenHeight);
    [self createUI];
}

- (void)createUI{
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight)];
    bg.image = [UIImage imageNamed:@"Login_Bg.png"];
    [self.view addSubview:bg];
    
    UIImageView *userImg = [[UIImageView alloc] initWithFrame:CGRectMake(LeftDistance,self.view.height*0.4, [UIView getWidth:20.0f], [UIView getWidth:20.0f])];
    userImg.image = [UIImage imageNamed:@"Btn_Normal_Zhanghuhao.png"];
    
    _userName = [[UITextField alloc] initWithFrame:CGRectMake(LeftDistance+userImg.width+[UIView getWidth:10.0f],self.view.height*0.4, self.view.width-[UIView getWidth:120.0f], [UIView getWidth:20.0f])];
    _userName.placeholder = @"用户名";
//    _userName.keyboardType = UIKeyboardTypePhonePad;//电话键盘
    [_userName setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [_userName setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    _userName.delegate = self;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(LeftDistance,_userName.maxY+[UIView getWidth:5.0f], self.view.width-[UIView getWidth:60.0f], 1)];
    line.layer.borderWidth = 18;
    line.layer.borderColor = [[UIColor grayColor] CGColor];
    
    
    UIImageView *passImg = [[UIImageView alloc] initWithFrame:CGRectMake(LeftDistance,line.maxY+[UIView getHeight:20.0f], [UIView getWidth:20.0f], [UIView getWidth:20.0f])];
    passImg.image = [UIImage imageNamed:@"Btn_Normal_Mima.png"];

    _password = [[UITextField alloc] initWithFrame:CGRectMake(LeftDistance+userImg.width+[UIView getWidth:10.0f],line.maxY+[UIView getHeight:20.0f],self.view.width-[UIView getWidth:120.0f], [UIView getWidth:20.0f])];
    _password.placeholder = @"密码";
    _password.returnKeyType =UIReturnKeyGo;//return键
    _password.secureTextEntry = YES;//密码
    _password.delegate = self;
    [_password setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [_userName setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(LeftDistance,_password.maxY+[UIView getWidth:5.0f], self.view.width-[UIView getWidth:60.0f], 1)];
    line2.layer.borderWidth = 1;
    line2.layer.borderColor = [[UIColor grayColor] CGColor];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginBtn setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:24]];
    [loginBtn setBackgroundColor:UIColorFromRGB(0x144d9a)];
    loginBtn.frame = CGRectMake(LeftDistance, line2.maxY+[UIView getHeight:50.0f], self.view.width-LeftDistance*2, [UIView getHeight:40.0f]);
    loginBtn.layer.cornerRadius = 25.0;//圆角
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:userImg];
    [self.view addSubview:_userName];
    [self.view addSubview:line];
    [self.view addSubview:passImg];
    [self.view addSubview:_password];
    [self.view addSubview:line2];
    [self.view addSubview:loginBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}

- (void)loginToHome{
    MenuListViewController* menuVc = [[MenuListViewController alloc] init];
    if (nil==menuVc) return;
    
    menuVc.roleId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"roleId"] intValue];
    
    UIColor *bgColor = [UIColor whiteColor];
    GHRevealViewController* revealController = [[GHRevealViewController alloc] initWithNibName:nil bundle:nil];
    revealController.view.backgroundColor = bgColor;
    // 绑定.
    menuVc.revealController = revealController;
    revealController.sidebarViewController = menuVc;
    // show.
    revealController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;    // 淡入淡出.
    [self presentViewController:revealController animated:YES completion:nil];
}

- (void)login:(id)sender {
// [[UIApplication sharedApplication]openURL:[NSURL URLWithString: @"itms-services://?action=download-manifest&url=https://172.16.9.29:8443/integration_dog/app/plist/crm/HappyMouse.plist"]];
//     [sender setBackgroundImage:[UIImage imageNamed:@"imageName2.png"] forState:UIControlStateHighlighted];
//    sender setBackgroundColor:<#(UIColor * _Nullable)#>
    if(_userName.text == nil | [_userName.text length] == 0 | _password.text == nil | [_password.text length] == 0)
    {
        [Tools showMessage:@"账号密码不能为空" view:self];
        return;
    }else{
        [SVProgressHUD showWithStatus:@"登录中"];
        [_userName resignFirstResponder];
        [_password resignFirstResponder];
        //method=app.user.login&name=zhaoy&password=111111
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:@"app.user.login" forKey:@"method"];
        [dictionary setObject:_userName.text forKey:@"name"];
        [dictionary setObject:_password.text forKey:@"password"];
        [DataTool postWithUrl:HEAD_URL parameters:[DataTool addSignToDic:dictionary] success:^(id data) {
            [SVProgressHUD dismiss];
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *status = [(NSDictionary *)jsonDic objectForKey:@"status"];
            
            if ([status isEqualToString:@"SUCCESS"]) {
                NSDictionary *data = [(NSDictionary *)jsonDic objectForKey:@"data"];
                int roleId = [[(NSDictionary *)data objectForKey:@"roleId"] intValue];
                NSString *roleName = [(NSDictionary *)data objectForKey:@"roleName"];
                NSString *roleTag = [(NSDictionary *)data objectForKey:@"roleTag"];
                int userId = [[(NSDictionary *)data objectForKey:@"userId"] intValue];
                NSString *userName = [(NSDictionary *)data objectForKey:@"userName"];
                NSLog(@"%d%@%@%d%@",roleId,roleName,roleTag,userId,userName);//4商务经理business44zhaoy
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setInteger:roleId forKey:@"roleId"];
                [userDefaults setObject:roleName forKey:@"roleName"];
                [userDefaults setObject:roleTag forKey:@"roleTag"];
                [userDefaults setInteger:userId forKey:@"userId"];
                [userDefaults setObject:userName forKey:@"userName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }else{
                NSString *code = [(NSDictionary *)jsonDic objectForKey:@"code"];
                NSString *msg = [(NSDictionary *)jsonDic objectForKey:@"msg"];
                NSLog(@"%@%@%@",status,code,msg);
                [Tools showMessage:msg view:self];
            }
            [self loginToHome];
        } fail:^(NSError *error) {
            NSLog(@"error:%@",error);
            [Tools showMessage:@"登录失败" view:self];
        }];
    }

}

//关闭虚拟键盘。
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _userName){
        [_userName resignFirstResponder];
        [_password resignFirstResponder];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_userName resignFirstResponder];
    [_password resignFirstResponder];
    
}

//防止虚拟键盘挡住输入框。
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if(self.view.frame.origin.y == 0)
//    {
//        [UIView animateWithDuration:0.3 animations:^{
//            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - offsetH, self.view.frame.size.width, self.view.frame.size.height);
//        }];
//    }
}

@end
