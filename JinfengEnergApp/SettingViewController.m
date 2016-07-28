//
//  SettingViewController.m
//  JinfengEnergApp
//
//  Created by BlackChen on 15/12/8.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "SettingViewController.h"
#import "personCell.h"
#import "PersonView.h"
#import "UpdateAndCleanView.h"
#import "CalculateFileSize.h"
#import "LoginAccountViewController.h"

@interface SettingViewController (){
//    section Header
    personCell *headerView;
//    视图隐现
    BOOL ButtonisSelected;
    RDVTabBarController *tabbarVC;
    LoginAccountViewController *loginAccountViewController;
//点击
    NSDictionary *predifDic;
// 版本
    NSString *lastVersion;
    NSString *currentVersion;
//    cookie
    NSString *cookieString;
//    本地
    NSUserDefaults *defaults;
//    二维码
    UIImageView *codeImageView;
//    提示文字
    UILabel *codeLable;
//    bool
    BOOL touch;
    NSArray *imageTextArr;
}
@property (strong,nonatomic)UIAlertView *alertView;
@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    tabbarVC = (RDVTabBarController *)delegate.window.rootViewController;
    if ([tabbarVC isKindOfClass:[RDVTabBarController class]])
    {
        tabbarVC.tabBar.hidden = YES;
        [tabbarVC.otherChoiceView removeFromSuperview];
        tabbarVC.viewisHidden = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;

    if ([tabbarVC isKindOfClass:[RDVTabBarController class]])
    {
        tabbarVC.tabBar.hidden = NO;
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    defaults = [NSUserDefaults standardUserDefaults];

    self.view.backgroundColor = [UIColor whiteColor];
    [self setCoookiee];
    [self loadBriefIntroduction];

    [self setLeftNavgationButton];
    [self addTabViewOfSetting];
    touch = NO;

    imageTextArr = @[@"wechat",@"当前是 安卓(Android) 端安装二维码,扫码可安装,点击可切换至 苹果(iOS) 端安装二维码"];
}

- (void)setLeftNavgationButton{
    NavigationBarView *navigationBarView = [[NavigationBarView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 64)];
    navigationBarView.backgroundColor = [UIColor colorWithRed:53/170.0 green:170/255.0 blue:0.0 alpha:1];
    navigationBarView.title_Lable.text = @"设置";
    [navigationBarView addSubview:navigationBarView.leftButton];
    [navigationBarView.leftButton addTarget:self action:@selector(backOfClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigationBarView];
}
//表视图
- (void)addTabViewOfSetting{
    self.mTableView = [[TQMultistageTableView alloc] initWithFrame:AdaptCGRectMake(0, 44, 320,568-64)];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.view addSubview:self.mTableView];
}

#pragma mark - TQTableViewDataSource
- (BOOL)mTableView:(TQMultistageTableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(TQMultistageTableView *)tableView
{
    return 5;
}

- (NSInteger)mTableView:(TQMultistageTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 1;
    
}
#pragma mark ----展开内容
- (UITableViewCell *)mTableView:(TQMultistageTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ButtonisSelected = YES;
    static NSString *cellIdentifier = @"TQMultistageTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 10000000)];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UIView *view = [[UIView alloc] initWithFrame:cell.bounds] ;
    view.backgroundColor = [UIColor whiteColor];
    if (_introduceTextView) {
        [_introduceTextView removeFromSuperview];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (indexPath.section == 0) {
        //TODO: 设置添加其他
        PersonView *personView = [[PersonView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 80)];
        personView.acountLable.text = [NSString stringWithFormat:@"姓名/账户:   %@",_acountName];
        cell.backgroundView = personView;
    }else if (indexPath.section == 1){
        UpdateAndCleanView *updateView = [[UpdateAndCleanView alloc]initWithFrame:AdaptCGRectMake(0, 60, 320, 44)];
        updateView.tag = 11;
        updateView.updateAndCleanLable.text = [NSString stringWithFormat:@"当前版本:     %@",lastVersion];
        [updateView.updateAndCleanButton setTitle:@"更新" forState:UIControlStateNormal];
        cell.backgroundView = updateView;
    }else if (indexPath.section == 2){
        UpdateAndCleanView *cacheView = [[UpdateAndCleanView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 44)];
        cacheView.updateAndCleanLable.text = [NSString stringWithFormat:@"目前缓存数据:     %@",_cacheData];
        cacheView.tag=1234;
        [cacheView.updateAndCleanButton setTitle:@"清空" forState:UIControlStateNormal];
        cell.backgroundView = cacheView;
    }else if (indexPath.section == 3){
        codeImageView = [[UIImageView alloc]initWithFrame:AdaptCGRectMake(100, -10, 120, 120)];
        codeImageView.image = [UIImage imageNamed:imageTextArr[0]];
        codeLable = [[UILabel alloc]initWithFrame:AdaptCGRectMake(30, 110, 260, 30)];
        codeLable.text = imageTextArr[1];
        codeLable.font = [UIFont systemFontOfSize:12];
        codeLable.numberOfLines = 2;
        codeLable.textAlignment = NSTextAlignmentCenter;
        for (UIView *view in cell.backgroundView.subviews) {
            [view removeFromSuperview];}
        [cell.contentView addSubview:codeImageView];
        [cell.contentView addSubview:codeLable];
    }else if (indexPath.section == 4){
        _introduceTextView = [[UILabel alloc]initWithFrame:AdaptCGRectMake(10, 1, 300, 0)];
        _introduceTextView.textColor =  [UIColor colorWithRed:53/255.0 green:170/255.0 blue:0.0 alpha:1];
        if (predifDic[@"text"] != NULL) {
            _introduceTextView.text = [NSString stringWithFormat:@"         %@",predifDic[@"text"]];
        }else{
            _introduceTextView.text = @"无网络或连接不到服务器！";
        }
        
        _introduceTextView.font = [UIFont systemFontOfSize:13.0];
        CGSize labelSize = {0, 0};
        
        labelSize = [_introduceTextView.text sizeWithFont:[UIFont systemFontOfSize:13.0]constrainedToSize:CGSizeMake(300.0/(320/SCREEN_WIDTH), 500) lineBreakMode:UILineBreakModeWordWrap];
        _introduceTextView.numberOfLines = 0;//表示label可以多行显示
        _introduceTextView.lineBreakMode = UILineBreakModeCharacterWrap;//换行模式，与上面的计算保持一致。
        _introduceTextView.frame = AdaptCGRectMake(10,1, 300, labelSize.height);//保持原来Label的位置和宽度，只是改变高度。
        UIView *lineView = [[UIView alloc]initWithFrame:AdaptCGRectMake(0, labelSize.height, 320, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        for (UIView *view in cell.backgroundView.subviews) {
            [view removeFromSuperview];
        }
        
        [cell.contentView addSubview:lineView];
        [cell.contentView addSubview:_introduceTextView];
    }
    
    return cell;
}

//警告
- (void)alertViewWithTitle:(NSString *)string message:(NSString *)message btTitle:(NSString *)btTitle{
    _alertView = [[UIAlertView alloc] initWithTitle:string message:message delegate:nil cancelButtonTitle:btTitle otherButtonTitles:nil, nil];
    [_alertView show];
}

#pragma mark ============= 检查缓存  ===========
- (void)clearCache{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        //拿到算有文件的数组
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        //拿到每个文件的名字,如有有不想清除的文件就在这里判断
        for (NSString *fileName in childerFiles) {
            //将路径拼接到一起
            NSString *fullPath = [path stringByAppendingPathComponent:fileName];
            folderSize += [self   fileSizeAtPath:fullPath];
        }
        _cacheData = [NSString stringWithFormat:@"%.2f M",folderSize];
        self.alertView = [[UIAlertView alloc] initWithTitle:@"清理缓存" message:[NSString stringWithFormat:@"缓存大小为%.2fM,确定要清理缓存吗?", folderSize] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [self.alertView show];
        self.alertView.delegate = self;
    }
}

//计算单个文件夹的大小
-(float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}


#pragma mark -弹框
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        //点击了确定,遍历整个caches文件,将里面的缓存清空
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSFileManager *fileManager=[NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]) {
            NSArray *childerFiles=[fileManager subpathsAtPath:path];
            for (NSString *fileName in childerFiles) {
                //如有需要，加入条件，过滤掉不想删除的文件
                NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
                [fileManager removeItemAtPath:absolutePath error:nil];
                _cacheData = @"0.00M";
                 UpdateAndCleanView *cacheView = (UpdateAndCleanView *)[self.view viewWithTag:1234];
                cacheView.updateAndCleanLable.text = [NSString stringWithFormat:@"目前缓存数据:     %@",_cacheData];
            }
        }
    }
    self.alertView = nil;
}

- (void)loadBriefIntroduction{
    NSString *url = [NSString stringWithFormat:@"%@/PhoneInfo/enterInfo/",JFENERGYMANAGER_IP];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        requestTmp=[requestTmp stringByReplacingOccurrencesOfString:@"'"withString:@"\""];
        NSError *error;
        SBJSON *sbjson=[[SBJSON alloc]init];
        //用对象解析string
        predifDic = [sbjson objectWithString:requestTmp error:&error];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self alertViewWithTitle:@"提示" message:@"无网络或连接不到服务器！" btTitle:@"确定"];
    }];
    [operation start];
}

#pragma mark - Table view delegate
/**
 *	第一层展开高度
 */
- (CGFloat)mTableView:(TQMultistageTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==4) {
        CGSize labelSize = {0, 0};
        
        labelSize = [_introduceTextView.text sizeWithFont:[UIFont systemFontOfSize:13.0]constrainedToSize:CGSizeMake(300.0/(320/SCREEN_WIDTH), 500) lineBreakMode:UILineBreakModeWordWrap];
        return labelSize.height;
}else if(indexPath.section==0){
    return 80.0/(320/SCREEN_WIDTH);
    }else if(indexPath.section==3){
        //TODO:
        return 150.0/(320/SCREEN_WIDTH);
    }else{
        return 60.0/(320/SCREEN_WIDTH);
    }
}
//第二层高度
- (CGFloat)mTableView:(TQMultistageTableView *)tableView heightForOpenCellAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}

- (CGFloat)mTableView:(TQMultistageTableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 3) {
        return 64/(320/SCREEN_WIDTH);
    }else{
        return 44/(320/SCREEN_WIDTH);
    }
}

- (UIView *)mTableView:(TQMultistageTableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *images = @[[UIImage imageNamed:@"users"],[UIImage imageNamed:@"update"],[UIImage imageNamed:@"clear_cookies"],[UIImage imageNamed:@"anzhuang"],[UIImage imageNamed:@"about"]];
    NSArray *titles = @[@"个人信息",@"检查更新",@"清除缓存",@"应用安装",@"关于我们"];
    
    headerView = [[personCell alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 44)];
    headerView.icon.image = images[section];
    headerView.title.text = titles[section];
    headerView.button.tag = 500 + section;
    
    ButtonisSelected = YES;

//    线
    UIView *lineviewone;
        if (section == 0) {
        lineviewone = [[UIView alloc]initWithFrame:AdaptCGRectMake(0, 0, tableView.frame.size.width, 1)];

    }else if (section == 3){
        lineviewone = [[UIView alloc]initWithFrame:AdaptCGRectMake(0, 44, tableView.frame.size.width, 1)];
    }else if (section == 4){
            lineviewone = [[UIView alloc]initWithFrame:AdaptCGRectMake(0,  44, tableView.frame.size.width, 1)];
       UIView *lineviewtt = [[UIView alloc]initWithFrame:AdaptCGRectMake(0,  0, tableView.frame.size.width, 1)];
        lineviewtt.backgroundColor = [UIColor lightGrayColor];
        [headerView addSubview:lineviewtt];
        
    }
    lineviewone.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:lineviewone];

    return headerView;
}

//选择header
- (void)mTableView:(TQMultistageTableView *)tableView didSelectHeaderAtSection:(NSInteger)section
{
    if (section == 0) {
        _acountName = [defaults objectForKey:@"login"];

    }else if(section == 1){
        if ([defaults objectForKey:@"currentVersion"]) {
            lastVersion = [defaults objectForKey:@"currentVersion"];
        }else{
            NSString *key = @"CFBundleVersion";
            // 上一次的使用版本（存储在沙盒中的版本号）
            lastVersion = [NSBundle mainBundle].infoDictionary[key];
        }
    }else if (section == 2){
        [self dianCacheData];
    }
}

- (void)dianCacheData{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        //拿到算有文件的数组
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        //拿到每个文件的名字,如有有不想清除的文件就在这里判断
        for (NSString *fileName in childerFiles) {
            //将路径拼接到一起
            NSString *fullPath = [path stringByAppendingPathComponent:fileName];
            folderSize += [self   fileSizeAtPath:fullPath];
        }
        _cacheData = [NSString stringWithFormat:@"%.2f M",folderSize];
    }
}

#pragma mark ----弹出cell点击
- (void)mTableView:(TQMultistageTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:
        {
            [self loginOut];
        }
            break;
        case 1:
        {
            [self loadCurrentVersion];
        }
            break;
        case 2:
        {
            [self clearCache];
        }
            break;
        case 3:
        {
            [self changeCodeAndText];
        }
            break;
            break;
        default:
            break;
    }
}

- (void)changeCodeAndText{
    touch = !touch;

    if (touch!=YES) {
    
        imageTextArr = @[@"wechat",@"当前是 安卓(Android) 端安装二维码,扫码可安装,点击可切换至 苹果(iOS) 端安装二维码"];

    }else{
        imageTextArr = @[@"iosappcode",@"当前是 苹果(iOS) 端安装二维码,扫码可安装,点击可切换至 安卓(Android) 端安装二维码"];


    }

    

}

- (void)loginOut{
    NSString *urlStr = [NSString stringWithFormat:@"%@/PhoneInfo/LoginOut/",JFENERGYMANAGER_IP];
    
    NSDictionary *preDic = @{@"phonetype":@"ios",@"cookie":cookieString};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json", nil];
    [manager GET:urlStr parameters:preDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"LoginOut"] isEqual:@"ok"]) {
            loginAccountViewController = [LoginAccountViewController new];
            //登录成功记录登录状态本地
//非登录状态
            [defaults setObject:@"0" forKey:@"nologin"];
//            销毁密码
            [defaults removeObjectForKey:@"password"];
            
//            自动登录状态
            [defaults setObject:@"NO" forKey:@"loginState"];
            
            [self.navigationController pushViewController:loginAccountViewController animated:YES];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

- (void)loadCurrentVersion{
    NSString *urlStr = [NSString stringWithFormat:@"%@/PhoneInfo/GetVersionUrl/",JFENERGYMANAGER_IP];
    NSDictionary *preDic = @{@"phonetype":@"ios",@"cookie":cookieString};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json", nil];
    [manager GET:urlStr parameters:preDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSString *lastVersionstr = [responseObject objectForKey:@"IosVersion"];
        currentVersion = lastVersionstr;
        if ([currentVersion isEqual:lastVersion]) { // 版本号相同：这次打开和上次打开的是同一个版本
            [self alertViewWithTitle:@"提示" message:@"已经是最新版本" btTitle:@"确定"];
        } else { // 这次打开的版本和上一次不一样
            //非登录状态
            [defaults setObject:@"0" forKey:@"nologin"];
            //            销毁密码
            [defaults removeObjectForKey:@"password"];
            //            自动登录状态
            [defaults setObject:@"NO" forKey:@"loginState"];
            
            NSString *title = NSLocalizedString(@"提示", nil);
            NSString *message = NSLocalizedString(@"亲,有新版本,需要更新吗?", nil);
            NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
            NSString *otherButtonTitle = NSLocalizedString(@"更新", nil);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            // Create the actions.
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                currentVersion = nil;
            }];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [defaults setObject:currentVersion forKey:@"currentVersion"];
                
                NSString *DurlStr = [responseObject objectForKey:@"IosUrl"];
                //            下载
                NSURL *url1 = [NSURL URLWithString:DurlStr];
                [[UIApplication sharedApplication] openURL:url1];
            }];
            
            // Add the actions.
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self alertViewWithTitle:@"提示" message:@"无网络或连接不到服务器！" btTitle:@"确定"];
    }];
}

#pragma mark 再取出保存的cookie重新设置cookie
- (void)setCoookiee
{
    //取出保存的cookie
    //对取出的cookie进行反归档处理
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"cookie"]];
    
    if (cookies) {
        //设置cookie
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (id cookie in cookies) {
            [cookieStorage setCookie:(NSHTTPCookie *)cookie];
        }
    }else{
    }
    //打印cookie，检测是否成功设置了cookie
    NSArray *cookiesA = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookiesA) {
        cookieString = [cookie.name stringByAppendingFormat:@"=%@",cookie.value];
    }
}

//header展开
- (void)mTableView:(TQMultistageTableView *)tableView willOpenHeaderAtSection:(NSInteger)section
{
    UIButton *button = (UIButton *)[self.view viewWithTag:500+section];
    [button setImage:[UIImage imageNamed:@"bottom_arrow_hiddeen"] forState:UIControlStateNormal];
}

//header关闭
- (void)mTableView:(TQMultistageTableView *)tableView willCloseHeaderAtSection:(NSInteger)section
{
    UIButton *button = (UIButton *)[self.view viewWithTag:500+section];
    [button setImage:[UIImage imageNamed:@"bottom_arrow"] forState:UIControlStateNormal];
}
//返回
- (void)backOfClick:(UIButton *)sender{
    tabbarVC.tabBar.hidden = NO;
    tabbarVC.selectedIndex = 0;
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
