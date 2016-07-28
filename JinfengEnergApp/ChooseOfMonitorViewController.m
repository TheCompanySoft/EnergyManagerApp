//
//  ChooseViewController.m
//  JinfengEnergApp
//
//  Created by BlackChen on 15/12/8.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "ChooseOfMonitorViewController.h"
#import "ChooseViewController.h"
#import "UIButton+DIYButton.h"

@interface ChooseOfMonitorViewController (){
    RDVTabBarController *tabbarVC;
    ChooseViewController *cooseViewController;
    
    //   已选企业名
    NSMutableArray *businessNames;
    //   已选滚动视图
    UIScrollView *selectedScroView;
    NSInteger viewTag;
    
    //    已选电表
    NSMutableArray *selectedMeters;
    //    通知中心
    NSNotificationCenter *notificationCenter;
    //    拼接字符串
    NSMutableArray *pieStringArray;
    
    //    全部数据
    NSArray *allDataArray;
    // 待加载数据
    NSMutableArray *dataArray;
    //选剩下的数据
    NSMutableArray *remainMutableArray;
    
    //    选择后的子部数据
    NSMutableArray *subClassData;
    
    //    电表滚动视图
    UIView *businessView;
    UIScrollView *dataScrollviewView;
    //    单选信息
    NSDictionary *dicInfo;
//    最后一个视图
    UIView *lastViewinSCR;
//    本地
    NSUserDefaults *userDefaults;
}
@end

@implementation ChooseOfMonitorViewController

- (void)viewWillAppear:(BOOL)animated{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    tabbarVC = (RDVTabBarController *)delegate.window.rootViewController;
    if ([tabbarVC isKindOfClass:[RDVTabBarController class]])
    {
        tabbarVC.tabBar.hidden = NO;
    }
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    for (UIView *view in dataScrollviewView.subviews) {
        if (view.tag > 0) {
            [view removeFromSuperview];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabBarButton];
    
    [self addNoChangeView];
    [self addChoiceView];
    
    //获取通知中心单例对象
    notificationCenter = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [notificationCenter addObserver:self selector:@selector(noticeeee:) name:@"selectedCompany" object:@"choice"];
}

- (void)noticeeee:(NSNotification *)sender{
#pragma mark 1.获取选择的企业
    if ([sender.name isEqual:@"selectedCompany"]) {
        businessNames = [sender.userInfo objectForKey:@"selectedCompanys"];
        dataArray = [NSMutableArray array];
        for (NSDictionary *dic in businessNames) {
            NSDictionary *dicc = @{@"id":dic[@"id"],@"text":dic[@"name"],@"type":dic[@"type"]};
            [dataArray addObject:dicc];
        }
        viewTag = 1;
        [self addMareViewWithArray:dataArray];
    }
}
//添加视图，联动
- (void)addMareViewWithArray:(NSMutableArray *)array{
    NSInteger count = array.count;
    if (array.count%3 == 0) {
        count = count - 1;
    }
    float y;
    UIView *lastView;
    if (dataScrollviewView.subviews.count==1) {
        lastView = [dataScrollviewView viewWithTag:viewTag];
        y = lastView.frame.origin.y+lastView.frame.size.height;
    }else{
        lastView = [dataScrollviewView viewWithTag:viewTag-1];
        y = lastView.frame.origin.y+lastView.frame.size.height +1;
    }
    
    businessView = [[UIView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, (count/3+1)*30)];
    businessView.tag = viewTag;
    [dataScrollviewView addSubview:businessView];
    
    if (businessView.tag != 1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, y-1, SCREEN_WIDTH, 1)];
        view.backgroundColor = [UIColor whiteColor];
        view.tag = businessView.tag;
        [dataScrollviewView addSubview:view];
    }
    
    CGRect frame = businessView.frame;
    frame.origin.y = y;
    frame.origin.x = lastView.frame.origin.x;
    businessView.frame = frame;
    
#pragma mark ------九宫格
    int btag = 0;
    NSInteger num = array.count / 3 + 1; // 循环次数
    for (int i = 0; i < num; i ++) {
        int max = 0;
        if (i == num - 1) {
            max = array.count % 3;// 如果是最后一个循环，就取余数
        }else {
            max = 3;// 不是最后一个循环，就初始化3个对象
        }
        for (int j = 0; j < max; j ++) {
            // 具体初始化的内容
            UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
            bButton.frame = AdaptCGRectMake(13 + j * 106, 3 + i * (24+6), 80, 24);
            bButton.tag = businessView.tag;
            [bButton setTitle:array[btag][@"text"] forState:UIControlStateNormal];
            [bButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            bButton.idString = array[btag][@"id"];
            
            bButton.titleLabel.font = [UIFont systemFontOfSize:12];
            bButton.titleLabel.numberOfLines = 2;
            bButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            bButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);//设置title在button上的位置（上top，左left，下bottom，右right）
            bButton.layer.cornerRadius = bButton.frame.size.height/2;
            bButton.layer.masksToBounds = YES;
            bButton.selected = NO;
            [bButton addTarget:self action:@selector(busTouchButton:) forControlEvents:UIControlEventTouchUpInside];
            btag ++;
            [businessView addSubview:bButton];
            
            //            之前已选
            for (NSDictionary *dic in  selectedMeters) {
                /*最末层*/
                if ([bButton.idString isEqual:dic[@"id"]] && [dic[@"group"] isEqual:@"0"]) {
                    [bButton setBackgroundImage:[UIImage imageNamed:@"select_yellow"] forState:UIControlStateNormal];
                    [bButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    bButton.selected = YES;
                }
            }
            bButton = nil;
        }
    }
    viewTag ++;
}
//点击
- (void)busTouchButton:(UIButton *)sender{
    viewTag = sender.tag + 1;
    lastViewinSCR = [dataScrollviewView viewWithTag:sender.tag];
    if (sender.tag < 2) {
        for (NSDictionary *dic in dataArray) {
            if ([sender.idString isEqual:dic[@"id"]]) {
                dicInfo = nil;
                dicInfo = [dic copy];
            }
        }
    }else{
        for (NSDictionary *dic in allDataArray) {
            if ([sender.idString isEqual:dic[@"id"]] ) {
                dicInfo = nil;
                dicInfo = [dic copy];
            }
        }
    }
//去除下层
    NSArray *pieArray = [NSArray arrayWithArray:pieStringArray];
    if (pieArray.count>0) {
        NSInteger countIndex;
        for (int i = 0; i < pieArray.count; i ++) {
            if ([dicInfo[@"pid"] isEqual:pieArray[i][@"pid"]]) {
                countIndex = i;
                for (int j = 0; j < pieArray.count; j ++) {
                    if (j>=i) {
                        [pieStringArray removeObject:pieArray[j]];
                    }
                }
            }
        }
    }
    
    
    for (UIView *view in dataScrollviewView.subviews) {
        if (view.tag > sender.tag) {
            [view removeFromSuperview];
        }
    }
    int isSelect = 0;
    NSArray *array = [NSArray arrayWithArray:selectedMeters];
    for (NSDictionary *dic in array) {
        if ([dicInfo[@"id"] isEqual:dic[@"id"]] && [dicInfo[@"group"] isEqual:@"0"]) {
            [selectedMeters removeObject:dic];
            [self setSelectedViewWithArray:selectedMeters];
            isSelect = 1;
        }
    }
    switch (isSelect) {
        case 1:
        {
            if ([pieStringArray containsObject:dicInfo]) {
                [pieStringArray removeObject:dicInfo];
            }
            //            已选删除
            sender.selected = NO;
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sender setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
            break;
        case 0:
            if (sender.selected != YES) {
                sender.selected = YES;
                if (sender.tag < 2) {
                    /*选中就下载数据*/
                    pieStringArray = [NSMutableArray arrayWithObject:dicInfo];
                    [self loadTotolData];
                }else{
                    if ([dicInfo[@"group"] isEqual:@"0"]) {
#pragma mark ----添加已选
                           NSMutableString *string = [NSMutableString string];
                           for(NSDictionary *rrrr in pieStringArray){
                               if (string.length==0) {
                                   string = [NSMutableString stringWithFormat:@"%@",rrrr[@"text"]];
                               }else{
                               string = [NSMutableString stringWithFormat:@"%@>%@",string,rrrr[@"text"]];
                               }
                           }

                        NSString *str = [NSString stringWithFormat:@"%@>%@",string,dicInfo[@"text"]];

                        NSMutableDictionary *dic = [dicInfo mutableCopy];
                        [dic setObject:str forKey:@"pieString"];
                          if ([selectedMeters containsObject:dic]!=YES) {
                            [selectedMeters addObject:dic];
                        }
                        [self setSelectedViewWithArray:selectedMeters];
                    }else{
                        if (![pieStringArray containsObject:dicInfo]) {
                            [pieStringArray addObject:dicInfo];
                        }
                        [self loadDataeewithdic:dicInfo];
                    }
                }
                [self resetLastViewwithArray:[NSArray arrayWithObject:dicInfo]];
            }else{
                if ([dicInfo[@"group"] isEqual:@"0"] != YES) {
                    sender.selected = NO;
                    
                    if ([pieStringArray containsObject:dicInfo]) {
                        [pieStringArray removeObject:dicInfo];
                    }
                    
                    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [sender setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                }
            }
            break;
        default:
            break;
    }
}
//刷新最后一个图
- (void)resetLastViewwithArray:(NSArray *)array{
    for (UIButton *button in lastViewinSCR.subviews) {
        for (NSDictionary *dic in array) {
            
            if ([dicInfo[@"group"] isEqual:@"0"]) {
                /*最末层*/
                if ([button.idString isEqual:dic[@"id"]]) {
                    [button setBackgroundImage:[UIImage imageNamed:@"select_yellow"] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    button.selected = YES;
                }
                
            }else{
                /*其它层*/
                if ([button.idString isEqual:dic[@"id"]]) {
                    [button setBackgroundImage:[UIImage imageNamed:@"select2_bg"] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor colorWithRed:53/255.0 green:170/255.0 blue:0.0 alpha:1] forState:UIControlStateNormal];
                    button.selected = YES;
                    
                }else{
                    [button setBackgroundImage:nil forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    button.selected = NO;
                }
            }
        }
    }
}
//下层数据
- (void)loadDataeewithdic:(NSDictionary *)dic1{
    subClassData = [NSMutableArray array];
#pragma mark 4.找出子层,添加新层,子等数据数据处理
    for (NSDictionary *dic in allDataArray) {
        if ([dic1[@"id"] isEqual:dic[@"pid"]] ) {
            [subClassData addObject:dic];
        }
    }
    
    [self addMareViewWithArray:subClassData];
}
//总数据
- (void)loadTotolData{
    //POST请求
    NSString *urlStr = [NSString stringWithFormat:@"%@/PhoneInfo/SearchMeasureToolList",JFENERGYMANAGER_IP];

    NSDictionary *paramsDiction  = @{@"enterid":dicInfo[@"id"]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlStr parameters:paramsDiction success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        if ([requestTmp containsString:@"error"] == YES) {
            NSString *strr = [userDefaults objectForKey:@"loginState"];
            LoginAccountViewController *loginAccountViewController;
            //            重登方式
            if ([strr isEqual:@"YES"]) {
                NSString *str = [userDefaults objectForKey:@"password"];
                NSString *str1 = [userDefaults objectForKey:@"login"];
                if (![str1 isEqual:@""]&&![str isEqual:@""]) {
                    [self loadDate:str1 and:str];
                }else{
                    [userDefaults setObject:@"NNNN" forKey:@"NNNN"];
                    [userDefaults setObject:@"0" forKey:@"nologin"];
                    
                    loginAccountViewController = [[LoginAccountViewController alloc]init];
                    [self.navigationController pushViewController:loginAccountViewController animated:YES];
                }
            }else{
                [userDefaults setObject:@"NNNN" forKey:@"NNNN"];
                [userDefaults setObject:@"0" forKey:@"nologin"];
                
                loginAccountViewController = [[LoginAccountViewController alloc]init];
                [self.navigationController pushViewController:loginAccountViewController animated:YES];
            }
            
        }else{
            NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            str = [str stringByReplacingOccurrencesOfString:@"'"withString:@"\""];
            NSError *error;
            SBJSON *sbjson=[[SBJSON alloc]init];
            //用对象解析string
            allDataArray = [[NSArray alloc]init];
#pragma mark 4.数据加载完成,获取子部,加载子表
            allDataArray = [sbjson objectWithString:str error:&error];
            
            //        查到选中企业下的电表
            subClassData = [NSMutableArray array];
            NSString *pid = [[NSString alloc]init];
            for (NSDictionary *dic in allDataArray) {
                if ([dic[@"text"] isEqual:@"计量器具"]) {
                    pid = dic[@"id"];
                }
                if ([dic[@"pid"] isEqual:pid]) {
                    [subClassData addObject:dic];
                }
            }
            [self addMareViewWithArray:subClassData];
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation * operation, NSError *error ) {
    }];
}

//状态
-(void)loadDate:(NSString*)phone and:(NSString*)password{
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
        /*把cookie进行归档并转换为NSData类型
         注意：cookie不能直接转换为NSData类型，否则会引起崩溃。
         所以先进行归档处理，再转换为Data*/
        NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
        
        //存储归档后的cookie
        userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject: cookiesData forKey: @"cookie"];
        
        [self deleteCookie];
        
        
        [self loadTotolData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络或连接不到服务器！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
    
    
    
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
//导航栏
- (void)settabBarButton{
    UIImageView *loginImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"big_background"]];
    loginImageView.frame = self.view.frame;
    [self.view addSubview:loginImageView];
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 64)];
    navigationBarView.title_Lable.text = @"筛选";
    [navigationBarView addSubview:navigationBarView.leftButton];
    [navigationBarView.leftButton addTarget:self action:@selector(cbackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigationBarView];
    
}
//已选视图
- (void)setSelectedViewWithArray:(NSArray *)array{
    for (UIView *view in selectedScroView.subviews) {
        [view removeFromSuperview];
    }
    //TODO: 字符串拼接
    for (int i = 0; i < array.count; i ++) {
        UIButton *selectedbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectedbutton.frame = AdaptCGRectMake(20, i*(26 + 4), 280, 26);
        [selectedbutton setTitle:array[i][@"pieString"] forState:UIControlStateNormal];
        selectedbutton.idString = array[i][@"id"];
        selectedbutton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        selectedbutton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [selectedbutton setTitleColor:[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0 alpha:1] forState:UIControlStateNormal];
        selectedbutton.titleEdgeInsets = UIEdgeInsetsMake(0, 9, 0, 9);
        selectedbutton.titleLabel.numberOfLines = 2;
        selectedbutton.backgroundColor = [UIColor colorWithRed:206/255.0 green:236/255.0 blue:189/255.0 alpha:1];
        selectedbutton.layer.cornerRadius = selectedbutton.frame.size.height/2;
        selectedbutton.layer.masksToBounds = YES;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame: AdaptCGRectMake(268, 6.5, 12, 12)];
        imageView.layer.cornerRadius = imageView.frame.size.height/2;
        imageView.layer.masksToBounds = YES;
        imageView.backgroundColor = [UIColor redColor];
        imageView.image = [UIImage imageNamed:@"close"];
        [selectedbutton addSubview:imageView];
        
        [selectedScroView addSubview:selectedbutton];
        if (array.count > 3) {
            CGSize newSize = CGSizeMake(selectedScroView.frame.size.width, selectedScroView.frame.size.height*(array.count/3 + 1));
            [selectedScroView setContentSize:newSize];
        }
        
        [selectedbutton addTarget:self action:@selector(choiceButtonItem2:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
#pragma mark 点击删除,删除最底层也在这
- (void)choiceButtonItem2:(UIButton *)sender{
    
    //    已选若selectedArray含则移除
    NSArray *array = [selectedMeters copy];
    for (NSDictionary *dic in array) {
        if ([dic[@"id"] isEqual:sender.idString]) {
            [selectedMeters removeObject:dic];
            [self setSelectedViewWithArray:selectedMeters];
            
            [self resetLastViewwithArray1:subClassData];
            
        }
    }
    
    [sender removeFromSuperview];
    
}
//更新最后一个图
- (void)resetLastViewwithArray1:(NSArray *)array{
    for (UIView *view in lastViewinSCR.subviews) {
        [view removeFromSuperview];
    }
#pragma mark ------九宫格
    int btag = 0;
    NSInteger num = array.count / 3 + 1; // 循环次数
    for (int i = 0; i < num; i ++) {
        int max = 0;
        if (i == num - 1) {
            max = array.count % 3;// 如果是最后一个循环，就取余数
        }else {
            max = 3;// 不是最后一个循环，就初始化3个对象
        }
        for (int j = 0; j < max; j ++) {
            // 具体初始化的内容
            UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
            bButton.frame = AdaptCGRectMake(13 + j * 106, 3 + i * (24+6), 80, 24);
            bButton.tag = lastViewinSCR.tag;
            [bButton setTitle:array[btag][@"text"] forState:UIControlStateNormal];
            [bButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            bButton.idString = array[btag][@"id"];
            bButton.titleLabel.font = [UIFont systemFontOfSize:12];
            bButton.titleLabel.numberOfLines = 2;
            bButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            bButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);//设置title在button上的位置（上top，左left，下bottom，右right）
            bButton.layer.cornerRadius = bButton.frame.size.height/2;
            bButton.layer.masksToBounds = YES;
            bButton.selected = NO;
            [bButton addTarget:self action:@selector(busTouchButton:) forControlEvents:UIControlEventTouchUpInside];
            btag ++;
            [lastViewinSCR addSubview:bButton];
            
            //            之前已选
            for (NSDictionary *dic in selectedMeters) {
                /*最末层*/
                if ([bButton.idString isEqual:dic[@"id"]] && [dic[@"group"] isEqual:@"0"]) {
                    [bButton setBackgroundImage:[UIImage imageNamed:@"select_yellow"] forState:UIControlStateNormal];
                    [bButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    bButton.selected = YES;
                }
            }
            
            bButton = nil;
        }
    }
    
}
//基本框架图
- (void)addNoChangeView{
    
    UILabel *textLable = [[UILabel alloc]initWithFrame:AdaptCGRectMake(10, 64, 100, 20)];
    textLable.text = @"已选器具";
    textLable.textColor = [UIColor whiteColor];
    textLable.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:textLable];
    
    selectedMeters = [NSMutableArray array];
    selectedScroView = [[UIScrollView alloc]initWithFrame:AdaptCGRectMake(0, 64+20, 320, 90)];
    selectedScroView.backgroundColor = [UIColor redColor];
    selectedScroView.directionalLockEnabled = YES; //只能一个方向滑动
    selectedScroView.pagingEnabled = NO; //是否翻页
    selectedScroView.showsVerticalScrollIndicator =NO; //垂直方向的滚动指示
    selectedScroView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    selectedScroView.showsHorizontalScrollIndicator = YES;//水平方向的滚动指示
    CGSize newSize = CGSizeMake(selectedScroView.frame.size.width, selectedScroView.frame.size.height*2);
    [selectedScroView setContentSize:newSize];
    selectedScroView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:selectedScroView];
    
    UIView *seView = [[UIView alloc]initWithFrame:AdaptCGRectMake(0, 180, 320, 14)];
    UILabel *txtLable = [[UILabel alloc]initWithFrame:AdaptCGRectMake(10, 0, 100, 14)];
    txtLable.text = @"器具选择";
    txtLable.font = [UIFont systemFontOfSize:14];
    txtLable.textColor = [UIColor whiteColor];
    [seView addSubview:txtLable];
    seView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.2];
    [self.view addSubview:seView];
    
    UIView *vvvvvv = [[UIView alloc]initWithFrame:AdaptCGRectMake(0, 200, 320, 30)];
    UIButton *choiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    choiceButton.frame = AdaptCGRectMake(20, 1, 280, 23);
    choiceButton.backgroundColor = [UIColor whiteColor];
    [choiceButton setTitle:@"选择企业" forState:UIControlStateNormal];
    choiceButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    choiceButton.layer.cornerRadius = choiceButton.frame.size.height/2;
    choiceButton.layer.masksToBounds = YES;
    [choiceButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [choiceButton addTarget:self action:@selector(choiceInside:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:AdaptCGRectMake(280, 5, 14, 14)];
    imageView.image = [UIImage imageNamed:@"arrow"];
    
    [vvvvvv addSubview:choiceButton];
    [vvvvvv addSubview:imageView];
    [self.view addSubview:vvvvvv];
    
    UIButton *choiceButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    choiceButton1.frame = AdaptCGRectMake(20, 568-37, 280, 25);
    choiceButton1.backgroundColor = [UIColor whiteColor];
    [choiceButton1 setTitle:@"确定" forState:UIControlStateNormal];
    choiceButton1.titleLabel.font = [UIFont systemFontOfSize:14.0];
    choiceButton1.layer.cornerRadius = choiceButton1.frame.size.height/2;
    choiceButton1.layer.masksToBounds = YES;
    choiceButton1.tag = 1;
    [choiceButton1 setTitleColor:[UIColor colorWithRed:53/255.0 green:170/255.0 blue:0.0 alpha:1] forState:UIControlStateNormal];
    [choiceButton1 addTarget:self action:@selector(choiceInside1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:choiceButton1];
    
}
#pragma mark ----传值到主页
- (void)choiceInside1:(UIButton *)sender{
    if (sender.tag == 1) {
        if ([tabbarVC isKindOfClass:[RDVTabBarController class]])
        {
            tabbarVC.tabBar.hidden = NO;
        }
        if (selectedMeters.count != 0) {
            [self denfaultData];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else{
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择您想查看的表!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertView addAction:cancelAction];
            [self presentViewController:alertView animated:YES completion:nil];
        }
    }
}
//通知
- (void)denfaultData{
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"selectedMeter" object:@"selectedMeter" userInfo:@{@"selectedMeters":selectedMeters,@"nameArr":businessNames}];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}

- (void)choiceInside:(UIButton *)sender{
    if (selectedMeters.count>0) {
        [selectedMeters removeAllObjects];
        for (UIView *view in selectedScroView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    if ([tabbarVC isKindOfClass:[RDVTabBarController class]])
    {
        tabbarVC.tabBar.hidden = YES;
    }
    cooseViewController = [ChooseViewController new];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:cooseViewController];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
//底视图
- (void)addChoiceView{
    for (UIView *view in dataScrollviewView.subviews) {
        [view removeFromSuperview];
    }
    
    dataScrollviewView = [[UIScrollView alloc]initWithFrame:AdaptCGRectMake(0, 230, 320, 568-230-40)];
    dataScrollviewView.directionalLockEnabled = YES; //只能一个方向滑动
    dataScrollviewView.pagingEnabled = NO; //是否翻页
    dataScrollviewView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    dataScrollviewView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    dataScrollviewView.tag = 0;
    dataScrollviewView.bounces = NO;
    dataScrollviewView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    CGSize newSize = CGSizeMake(dataScrollviewView.frame.size.width, dataScrollviewView.frame.size.height*2.5);
    [dataScrollviewView setContentSize:newSize];
    
    [self.view addSubview:dataScrollviewView];
}
//返回
- (void)cbackClick{
    if ([tabbarVC isKindOfClass:[RDVTabBarController class]])
    {
        tabbarVC.tabBar.hidden = NO;
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
