//
//  LoginAccountViewController.m
//  JinFengEnergyAPP
//
//  Created by BlackChen on 15/12/4.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "LoginAccountViewController.h"
#import "HomeViewController.h"
@interface LoginAccountViewController ()<UITextFieldDelegate>{
    RDVTabBarController *tabbarVC;
    HomeViewController *homeViewController;
    MBProgressHUD *_HUD;//提示
//账户，密码
    UITextField *accoutTextfield;
    UITextField *accoutText;
    UITextField *passwordText;
    //本地
    NSUserDefaults *defaults;
}

@end

@implementation LoginAccountViewController
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    tabbarVC = (RDVTabBarController *)delegate.window.rootViewController;
    if ([tabbarVC isKindOfClass:[RDVTabBarController class]])
    {
        tabbarVC.tabBar.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    tabbarVC = (RDVTabBarController *)delegate.window.rootViewController;
    self.navigationController.navigationBarHidden = YES;
    if ([tabbarVC isKindOfClass:[RDVTabBarController class]])
    {
        tabbarVC.tabBar.hidden = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *loginImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic_bg"]];
    loginImageView.frame = self.view.frame;
    [self.view addSubview:loginImageView];
    
    [self addLoginTextfieldAndButton];
    
    //    账户名
    accoutText = (UITextField *)[self.view viewWithTag:50];
    
    //    账户密码
    passwordText = (UITextField *)[self.view viewWithTag:51];
    [self PhoneInfoisSession1];
    
}
#pragma mark 删除cookie
- (void)deleteCookie
{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    //删除cookie
    for (NSHTTPCookie *tempCookie in cookies) {
        [cookieStorage deleteCookie:tempCookie];
    }
}
//状态
- (void)PhoneInfoisSession1{

    NSString *url = [NSString stringWithFormat:@"%@/PhoneInfo/isSession/",JFENERGYMANAGER_IP];
    ////2 创建一个请求管理器
    AFHTTPRequestOperationManager *operationManager=[AFHTTPRequestOperationManager manager];
    //3 设置请求可以接受内容的样式
    operationManager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
    
    // 4 管理器发送POST请求
    [operationManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str = [responseObject objectForKey:@"SessionState"];
        if ([str isEqual:@"ok"]) {
        
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            NSString *str1 = [userDefaultes objectForKey:@"loginState"];
            
            NSString *str2 = [userDefaultes objectForKey:@"password"];
            NSString *str3 = [userDefaultes objectForKey:@"login"];
            accoutText.text = str3;
            if ([str1 isEqual:@"YES"]) {
                passwordText.text = str2;
                
                //创建一个消息对象
                NSNotification *notice = [NSNotification notificationWithName:@"isLogin" object:@"isLogin" userInfo:@{@"isLogin":@"1"}];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络或连接不到服务器！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
}
//布局
- (void)addLoginTextfieldAndButton{
    UIImageView *iconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"face"]];
    iconImage.frame = AdaptCGRectMake(110, 100, 100, 100);
    [self.view addSubview:iconImage];
    
    NSArray *accoutTextt = @[@"请输入您的账号",@"请输入您的密码"];
    NSArray *images = @[[UIImage imageNamed:@"user_name"],[UIImage imageNamed:@"password"]];
    for (int i = 0; i < 2; i ++) {
        UIView *textView = [[UIView alloc]initWithFrame:AdaptCGRectMake(50, 250+i*55, 220, 38)];
        UIImageView *bgimageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"usename_bg"]];
        bgimageView.frame = AdaptCGRectMake(0, 0, 220, 38);
        [textView addSubview:bgimageView];
        textView.layer.cornerRadius = textView.frame.size.height/2;
        textView.layer.masksToBounds = YES;
        
        accoutTextfield = [[UITextField alloc]initWithFrame:AdaptCGRectMake(50, 0, 170,38)];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:images[i]];
        accoutTextfield.leftView = imageView;
        accoutTextfield.leftViewMode = UITextFieldViewModeAlways;
        accoutTextfield.placeholder = accoutTextt[i];
        accoutTextfield.clearsOnBeginEditing = YES;
        
        accoutTextfield.returnKeyType = UIReturnKeyDone;
        accoutTextfield.textColor=[UIColor whiteColor];
        accoutTextfield.tag = 50+i;
        accoutTextfield.font = [UIFont systemFontOfSize:15];
        accoutTextfield.tintColor = [UIColor whiteColor];
        accoutTextfield.clearButtonMode=UITextFieldViewModeWhileEditing;
        accoutTextfield.backgroundColor=[UIColor clearColor];
        if (i==1) {
            accoutTextfield.secureTextEntry = YES;
        }
        [textView addSubview:accoutTextfield];
        [self.view addSubview:textView];
    }
    accoutTextfield.delegate = self;
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = AdaptCGRectMake(45, 400, 230, 40);
    loginButton.backgroundColor = [UIColor whiteColor];
    [loginButton addTarget:self action:@selector(loginToHomeView:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor colorWithRed:53/255.0 green:170/255.0 blue:0.0 alpha:1] forState:UIControlStateNormal];
    
    
    loginButton.layer.cornerRadius = loginButton.frame.size.height/2;
    loginButton.layer.masksToBounds = YES;
    [self.view addSubview:loginButton];
    
    
    UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    switchButton.tag = 115;
    
    [defaults removeObjectForKey:@"loginState"];
        [defaults setObject:@"NO" forKey:@"loginState"];

    
    [switchButton setImage:[UIImage imageNamed:@"login_white2"] forState:UIControlStateNormal];

    switchButton.frame = AdaptCGRectMake(0, 5, 15, 15);
    
    UILabel *switchLable = [[UILabel alloc]initWithFrame:AdaptCGRectMake(15, 0, 60, 25)];
    switchLable.text = @"自动登录";
    switchLable.textAlignment = NSTextAlignmentLeft;
    switchLable.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    switchLable.font = [UIFont systemFontOfSize:14];
    
    switchLable.textColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = AdaptCGRectMake(200, 450, 75, 25);
    [button addTarget:self action:@selector(choiceLogin:) forControlEvents:UIControlEventTouchUpInside];
    [button addSubview:switchButton];
    [button addSubview:switchLable];
    
    [self.view addSubview:button];
    
    
}
#pragma mark ----自动登录选项
- (void)choiceLogin:(UIButton *)sender{
    [defaults removeObjectForKey:@"loginState"];
    defaults = [NSUserDefaults standardUserDefaults];
    UIButton *button = [self.view viewWithTag:115];
    if (sender.selected != YES) {
        sender.selected = YES;
        [button setImage:[UIImage imageNamed:@"login_white"] forState:UIControlStateNormal];
        //登录成功记录登录状态本地
        [defaults setObject:@"YES" forKey:@"loginState"];
        
    }else{
        sender.selected = NO;
        [button setImage:[UIImage imageNamed:@"login_white2"] forState:UIControlStateNormal];
        [defaults setObject:@"NO" forKey:@"loginState"];
    }
}
//登录
- (void)loginToHomeView:(UIButton *)sender{
    if (accoutText.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else if (passwordText.text.length == 0){
        //提示框
        UIAlertView *failureAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您输入的密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [failureAlertView show];
        
    }else{
        [self loadDate:accoutText.text and:passwordText.text];
    }
}
//加载数据
#pragma mark 获取并保存cookie到userDefaults

-(void)loadDate:(NSString*)phone and:(NSString*)password{
    _HUD=[MBProgressHUD show:MBProgressHUDModeIndeterminate message:@"加载中..." customView:self.view];
    NSString *passwordMD5 =[password md5HexDigest:password];
    //POST请求
    NSString *url = [NSString stringWithFormat:@"%@/PhoneInfo/login/",JFENERGYMANAGER_IP];

    NSDictionary *parameters=@{@"username":phone,@"pwd":passwordMD5};
    ////2 创建一个请求管理器
    AFHTTPRequestOperationManager *operationManager=[AFHTTPRequestOperationManager manager];
    //3 设置请求可以接受内容的样式
    operationManager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
    
    // 4 管理器发送POST请求
    [operationManager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *panduanStr = [NSString stringWithString:operation.responseString];
        
        if ([panduanStr containsString:@"error"] == YES) {
            [_HUD hide:YES afterDelay:0.0f];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查用户名或者密码是否正确!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];

        }else{
            //获取cookie
            /*把cookie进行归档并转换为NSData类型
             注意：cookie不能直接转换为NSData类型，否则会引起崩溃。
             所以先进行归档处理，再转换为Data*/
            NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
            
            //存储归档后的cookie
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject: cookiesData forKey: @"cookie"];
            
            defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:password forKey:@"password"];
            
            [defaults setObject:phone forKey:@"login"];            
            NSTimer *timer;
            if (!timer) {
                timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(doTime) userInfo:nil repeats:NO];
            }
            
            NSString *strq = [defaults objectForKey:@"nologin"];
            if ([strq isEqual:@"0"]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                tabbarVC = (RDVTabBarController *)delegate.window.rootViewController;
                if ([tabbarVC isKindOfClass:[RDVTabBarController class]])
                {
                    tabbarVC.selectedIndex = 0;
                }
            }else{
                //创建一个消息对象
                NSNotification *notice = [NSNotification notificationWithName:@"isLogin" object:@"isLogin" userInfo:@{@"isLogin":@"1"}];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
            }
            [_HUD hide:YES afterDelay:0.3f];
        }
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [_HUD hide:YES afterDelay:0.3f];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络或连接不到服务器！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
    
}

-(void)doTime
{
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:@"nologin"];
//    跳转方式
    if ([str  isEqual:@"0"]) {
        [defaults removeObjectForKey:@"nologin"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        tabbarVC = (RDVTabBarController *)delegate.window.rootViewController;
        if ([tabbarVC isKindOfClass:[RDVTabBarController class]])
        {
            tabbarVC.selectedIndex = 0;
        }
    }else{
        //创建一个消息对象
        NSNotification *notice = [NSNotification notificationWithName:@"Login1" object:@"Login1" userInfo:@{@"Login1":@"1"}];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    }

    
}
//UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    return YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
