//
//  HomeViewController.m
//  JinFengEnergyAPP
//  Created by BlackChen on 15/12/4.
//  Copyright © 2015年 BlackChen. All  rights reserved.
//
#import "HomeViewController.h"
#import "AllChooseViewController.h"
#import "imageAndTextView.h"
#import "HomeLinechartInfo.h"
#import "HeaderchartcolorView.h"
#import "TWRChart.h"
#import "URBSegmentedControl.h"
#import "TimeEnergyView.h"
#import "warningViewcellTableViewCell.h"
#import "DataView.h"
#import "DataLabel.h"
#import "LoginAccountViewController.h"

@interface HomeViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    RDVTabBarController *tabbarVC;
    AllChooseViewController *chooseViewController;
    LoginAccountViewController *loginAccountViewController;
    
    TimeEnergyView *_realtimeEnergyConsumptionView;
//    视图隐藏
    BOOL isHidden;
    BOOL ishidden;
//    警告
    UIAlertView *alertOfView;
    
    UIView *viewOfTitlAndButon;
//    弹出视图
    UITableView *warningTableView;
    
//    本地
    NSUserDefaults *userDefaults;
//    最新消息的数字
    NSNumber *MAXX;
//    本地数组
    NSArray *userDefaultArray;
    
//    饼状图,表格
    NSMutableArray *values;
    NSMutableArray *colors;
    NSMutableArray *energyBMs;
//    实时能耗已选择
    UILabel *lableAndbuttonOfTime;
//    实时能耗选择
    UIView *otherView;
//    能耗信息／污染气体
    DataView *dataView;
    DataView *dataView1;
//    饼状图和表格底图
    UIScrollView *myscrollview;
    //    能耗和污染气体
    NSMutableArray *consumptionDataArray;
    NSMutableArray *pollutionDataArray;
    //    警告信息
    NSMutableArray *warningDataArray;
//    名字／值／颜色
    NSMutableArray*_energyNameArray;
    NSMutableArray*_energyValueArray;
    NSMutableArray*_colorArray;
//    刷新时间
    NSDictionary *reflashTime;
//    导航栏
    NavigationBarView *navigationBarView;
//    cookie
    NSString *cookieString;
//    版本
    NSString *lastVersion;
    NSString *currentVersion;

}
@property(strong, nonatomic) TWRChartView *chartView;
@property(nonatomic,assign)int time;
@property(nonatomic,strong) NSTimer *timer1;
@property(nonatomic,strong) NSTimer *timer3;
@property(nonatomic,strong) NSTimer *timer4;
@property(nonatomic,strong) NSTimer *timer5;
@property(nonatomic,strong) NSTimer *timer6;

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated{
//    启动定时器
        [self.timer1 setFireDate:[NSDate distantPast]];
        [self.timer3 setFireDate:[NSDate distantPast]];
        [self.timer4 setFireDate:[NSDate distantPast]];
        [self.timer5 setFireDate:[NSDate distantPast]];
        [self.timer6 setFireDate:[NSDate distantPast]];
    self.navigationController.navigationBarHidden = YES;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    tabbarVC = (RDVTabBarController *)delegate.window.rootViewController;
    tabbarVC.tabBar.hidden = NO;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    //关闭定时器
    [self.timer1 setFireDate:[NSDate distantFuture]];
    [self.timer3 setFireDate:[NSDate distantFuture]];
    [self.timer4 setFireDate:[NSDate distantFuture]];
    [self.timer5 setFireDate:[NSDate distantFuture]];
    [self.timer6 setFireDate:[NSDate distantFuture]];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStausBar];
    _energyNameArray=[NSMutableArray array];
    _energyValueArray=[NSMutableArray array];
    _colorArray=[NSMutableArray array];

    isHidden = YES;
    ishidden = YES;
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(notice:) name:@"allSelectedCompany" object:@"allChoice"];
    
//    版本检测
    [self loadDataa];

    [self versionCheck];

    [self addtableViewOfWarning];
    [self addOtherchoice];
    [self setNavItem];
    [self addLineGraphOfRealtimeEnergyConsumption];
    [self addSegment];
    [self addEnergyConsumption];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tap];
}

- (void)versionCheck{
    if ([userDefaults objectForKey:@"currentVersion"]) {
        lastVersion = [userDefaults objectForKey:@"currentVersion"];
    }else{
        NSString *key = @"CFBundleVersion";
        // 上一次的使用版本（存储在沙盒中的版本号）
        lastVersion = [NSBundle mainBundle].infoDictionary[key];
    }
    
    //TODO:时间
//    存储的日期
    NSString *dateString = [userDefaults objectForKey:@"day"];
    int i = [self intervalSinceNow:dateString];

//    若是一天后就更新
    if (i > 0) {
        
        [self loadCurrentVersion];
    }
}

- (int)intervalSinceNow: (NSString *) theDate
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
//    大于一天返回
    if (cha/86400>=1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        return [timeString intValue];
    }
    return -1;
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
        } else { // 这次打开的版本和上一次不一样
            
            NSString *title = NSLocalizedString(@"提示", nil);
            NSString *message = NSLocalizedString(@"亲,有新版本,需要更新吗?", nil);
            NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
            NSString *otherButtonTitle = NSLocalizedString(@"更新", nil);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            // Create the actions.
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
//                存储点击取消的日期
                [userDefaults setObject:strDate forKey:@"day"];
                currentVersion = nil;
            }];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //非登录状态
                [userDefaults setObject:@"0" forKey:@"nologin"];
                //            销毁密码
                [userDefaults removeObjectForKey:@"password"];
                //            自动登录状态
                [userDefaults setObject:@"NO" forKey:@"loginState"];

                [userDefaults setObject:currentVersion forKey:@"currentVersion"];
                
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

//警告
- (void)alertViewWithTitle:(NSString *)string message:(NSString *)message btTitle:(NSString *)btTitle{
    alertOfView = [[UIAlertView alloc] initWithTitle:string message:message delegate:nil cancelButtonTitle:btTitle otherButtonTitles:nil, nil];
    [alertOfView show];
}

//设置状态栏为白色
-(void)setStausBar{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)notice:(NSNotification *)sender{
    self.selectedCompanys = [sender.userInfo objectForKey:@"allSelectedCompanys"];
    if (self.selectedCompanys.count!=0) {
        userDefaults= [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"HomaeUserDefaults"];
        //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
        [userDefaults setObject:self.selectedCompanys forKey:@"HomaeUserDefaults"];
        
        if (self.selectedCompanys.count>0) {
            [warningTableView reloadData];
            [self loadDataa];
        }
    }
}
//导航栏
- (void)setNavItem{
    UIImageView *loginImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"big_background"]];
    loginImageView.frame = self.view.frame;
    [self.view addSubview:loginImageView];
    
    navigationBarView = [[NavigationBarView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 64)];
    navigationBarView.title_Lable.text = @"当日用能概况";
    [navigationBarView addSubview:navigationBarView.navigationBarButton];
    [navigationBarView addSubview:navigationBarView.rightWarningButton];
    navigationBarView.navigationBarButton.tag = 101;
    navigationBarView.rightWarningButton.tag = 100;
    [navigationBarView. rightWarningButton addTarget:self action:@selector(selectorOfWarnAndChooce:) forControlEvents:UIControlEventTouchUpInside];
    
    [navigationBarView. navigationBarButton addTarget:self action:@selector(selectorOfWarnAndChooce:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigationBarView];
    
}

#pragma mark 再取出保存的cookie重新设置cookie
- (void)setCoookie
{
    //取出保存的cookie
    userDefaults = [NSUserDefaults standardUserDefaults];
    //对取出的cookie进行反归档处理
    NSArray *cookies =[NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"cookie"]];
    
    if (cookies) {
        //设置cookie
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (id cookie in cookies) {
            [cookieStorage setCookie:(NSHTTPCookie *)cookie];
        }
    }
    //打印cookie，检测是否成功设置了cookie
    NSArray *cookiesA = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookiesA) {
        cookieString = [cookie.name stringByAppendingFormat:@"=%@",cookie.value];
    }
}
//下载
- (void)loadDataa{
    [self setCoookie];
    if (self.selectedCompanys.count == 0) {
        //本地去参数加载
        userDefaults= [NSUserDefaults standardUserDefaults];
        userDefaultArray = [userDefaults objectForKey:@"HomaeUserDefaults"];
        if (userDefaultArray.count != 0) {
            self.selectedCompanys = [userDefaultArray copy];
        }else{
            self.selectedCompanys = @[@{@"type":@"0",@"id":JFENERGYMANAGER_ID}];
        }
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/PhoneInfo/GetReflashState/",JFENERGYMANAGER_IP];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        requestTmp=[requestTmp stringByReplacingOccurrencesOfString:@"'"withString:@"\""];
    
        NSError *error;
        SBJSON *sbjson=[[SBJSON alloc]init];
        //用对象解析string
        reflashTime = [sbjson objectWithString:requestTmp error:&error];
        [self loadConsumptionData];
        [self loadTimeEnergyData];
        [self loadPieChart];
        [self addWarningData];

        //污染气体排放
        int AirPolltiontime = [reflashTime[@"AirPolltion"] intValue];
        //能耗构成
        int EnergyConsisttime = [reflashTime[@"EnergyConsist"] intValue];
        //能耗信息时间
        int EnergyInfotime = [reflashTime[@"EnergyInfo"] intValue];
        //警告
        int MonitorWarntime = [reflashTime[@"MonitorWarn"] intValue];
        //实时能耗
        int RealtimeConsume = [reflashTime[@"RealtimeConsume"]intValue];
        //污染气体排放
            self.timer1 = [NSTimer scheduledTimerWithTimeInterval:AirPolltiontime target:self selector:@selector(doTimea) userInfo:nil repeats:YES];
        //能耗构成
        if (!self.timer3) {
            self.timer3 = [NSTimer scheduledTimerWithTimeInterval:EnergyConsisttime target:self selector:@selector(doTimec) userInfo:nil repeats:YES];
        }
       //能耗信息时间
            self.timer4 = [NSTimer scheduledTimerWithTimeInterval:EnergyInfotime target:self selector:@selector(doTimed) userInfo:nil repeats:YES];
        //警告
            self.timer5 = [NSTimer scheduledTimerWithTimeInterval:MonitorWarntime target:self selector:@selector(doTimee) userInfo:nil repeats:YES];
        //实时能耗
            self.timer6 = [NSTimer scheduledTimerWithTimeInterval:RealtimeConsume target:self selector:@selector(doTimef) userInfo:nil repeats:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self alertView];
    }];
    [operation start];
}

//污染气体排放
-(void)doTimea{
    [self pollutionData];
}

//能耗构成
-(void)doTimec{
    [self loadPieChart];
}
//能耗信息时间
-(void)doTimed{
    [self loadConsumptionData];
}
//警告
-(void)doTimee{
    [self addWarningData];
}
//实时能耗
-(void)doTimef{
    [self loadTimeEnergyData];
}
//实时能耗
- (void)loadTimeEnergyData{
    NSString *URLTmp = [NSString stringWithFormat:@"%@/CenterMain/CenterRealTimeConsume_Popup_M/?",JFENERGYMANAGER_IP];

    NSMutableArray *idArr = [NSMutableArray array];
    if (self.selectedCompanys.count>0) {
    for (NSDictionary *dic in self.selectedCompanys) {
        [idArr addObject:[dic objectForKey:@"id"]];
    }
    NSString * string = [idArr componentsJoinedByString:@","];
    NSString *URL = [URLTmp stringByAppendingFormat:@"type=%@&id=%@&cookie=%@",self.selectedCompanys[0][@"type"],string,cookieString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URL]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        
        requestTmp=[requestTmp stringByReplacingOccurrencesOfString:@"'"withString:@"\""];
        NSError *error;
        SBJSON *sbjson=[[SBJSON alloc]init];
        //用对象解析string
        NSArray *array = [sbjson objectWithString:requestTmp error:&error];
                
        if (_colorArray.count>0) {
            [_colorArray removeAllObjects];
            [_energyValueArray removeAllObjects];
            [_energyNameArray removeAllObjects];
        }
        if (array.count>1) {
            for (NSDictionary *dic in array) {
                HomeLinechartInfo *homeinfo=[[HomeLinechartInfo alloc]initWithDictionary:dic];
                
                [_energyNameArray addObject:homeinfo.energyType];
                [_energyValueArray addObject:homeinfo.energyList];
                [_colorArray addObject:homeinfo.energyColor];
            }
            [self addOtherchoice];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self alertView];
    }];
    [operation start];
}
}
//能耗构成
- (void)loadPieChart{
    NSString *URLTmp = [NSString stringWithFormat:@"%@/CenterMain/EnergyConsist_Popup_M/?",JFENERGYMANAGER_IP];
    NSMutableArray *idArr = [NSMutableArray array];
     if (self.selectedCompanys.count>0) {
    for (NSDictionary *dic in self.selectedCompanys) {
        [idArr addObject:[dic objectForKey:@"id"]];
    }
    NSString *string = [idArr componentsJoinedByString:@","];
         
    NSString *URL = [URLTmp stringByAppendingFormat:@"type=%@&id=%@&cookie=%@",self.selectedCompanys[0][@"type"],string,cookieString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URL]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        requestTmp=[requestTmp stringByReplacingOccurrencesOfString:@"'"withString:@"\""];
        NSError *error;
        values = [NSMutableArray array];
        colors = [NSMutableArray array];
        energyBMs = [NSMutableArray array];
        SBJSON *sbjson=[[SBJSON alloc]init];
        //用对象解析string
        NSArray *array = [sbjson objectWithString:requestTmp error:&error];
        if (array.count>0) {
            for (NSDictionary *dic in array) {
                //            能耗值
                [energyBMs addObject:[dic objectForKey:@"energyBM"]];
                //            种类和占比
                [values addObject:[dic objectForKey:@"energyName"]];
                //            颜色
                UIColor *color = [self stringTOColor:dic[@"energyColor"]];
                [colors addObject:color];
            }
        }
        
        NSMutableArray *persentValues = [NSMutableArray array];
        for (NSString *str in values) {
            NSScanner *scanner = [NSScanner scannerWithString:str];
            [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
            float number;
            [scanner scanFloat:&number];
            [persentValues addObject:@(number)];
        }
        
        if (values != nil) {
            UILabel *lable = (UILabel *)[_chartView viewWithTag:1050];
            [lable removeFromSuperview];
            // Doughnut Chart
            TWRCircularChart *pieChart = [[TWRCircularChart alloc] initWithValues:persentValues colors:colors type:TWRCircularChartTypeDoughnut animated:YES];
            // You can even leverage callbacks when chart animation ends!
            [_chartView loadCircularChart:pieChart withCompletionHandler:^(BOOL finished) {
                if (finished) {
                }
            }];
            [self addOtherPieView];
            [self addSheetView];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    [operation start];
}
}
//饼状图图片文字
- (void)addOtherPieView{
    UIImageView *imageView = (UIImageView *)[myscrollview viewWithTag:6];
    if (imageView) {
        [imageView removeFromSuperview];
    }
    
    UIImageView *ggggView = [[UIImageView alloc]initWithFrame:AdaptCGRectMake(27.15, 27.05, 76.2, 76.2)];
    ggggView.tag = 6;
    ggggView.backgroundColor = [UIColor clearColor];
    ggggView.image = [UIImage imageNamed:@"yuan"];
    ggggView.layer.cornerRadius = ggggView.frame.size.height/2;
    ggggView.layer.masksToBounds = YES;
    [_chartView addSubview:ggggView];
    
    NSMutableArray *icons = [NSMutableArray array];
    for (UIColor *color in colors) {
        UIImage *iamge = [self createImageWithColor:color];
        [icons addObject:iamge];
    }
    
    if (values.count != 0) {
        UILabel *lable = (UILabel *)[_chartView viewWithTag:1050];
        if (lable) {
            [lable removeFromSuperview];
        }
        for (int i = 0; i <  values.count; i ++) {
            imageAndTextView *stuctureView = [[imageAndTextView alloc]initWithFrame:AdaptCGRectMake(10, 14+11*i, 50, 11)];
            stuctureView.imageView.frame = AdaptCGRectMake(5, 2, 6, 6);
            stuctureView.imageView.layer.cornerRadius = stuctureView.imageView.frame.size.height/2;
            stuctureView.imageView.layer.masksToBounds = YES;
            stuctureView.imageView.image = icons[i];
            stuctureView.lable.frame = AdaptCGRectMake(13, 0, 44, 10);
            stuctureView.lable.text = values[i];
            stuctureView.lable.font = [UIFont systemFontOfSize:8];
            [ggggView addSubview:stuctureView];
        }
    }
}

//污染气体
- (void)pollutionData{
    
    NSString *URLTmp = [NSString stringWithFormat:@"%@/CenterMain/CenterAirPolltion_Popup_M/?",JFENERGYMANAGER_IP];
    NSMutableArray *idArr = [NSMutableArray array];
     if (self.selectedCompanys.count>0) {
    for (NSDictionary *dic in self.selectedCompanys) {
        [idArr addObject:[dic objectForKey:@"id"]];
    }
    NSString * string = [idArr componentsJoinedByString:@","];
    NSString *URL = [URLTmp stringByAppendingFormat:@"type=%@&id=%@&cookie=%@",self.selectedCompanys[0][@"type"],string,cookieString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URL]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        requestTmp=[requestTmp stringByReplacingOccurrencesOfString:@"'"withString:@"\""];
        NSError *error;
        SBJSON *sbjson=[[SBJSON alloc]init];
        pollutionDataArray = [NSMutableArray array];
        //用对象解析string
        NSArray *array = [sbjson objectWithString:requestTmp error:&error];

        for (NSDictionary *dic in array) {
            NSString *str = [[dic objectForKey:@"airName"] stringByAppendingFormat:@":%@",[dic objectForKey:@"airValue"]];
            [pollutionDataArray addObject:str];
        }
        
        for (UIView *view  in dataView1.subviews) {
            [view removeFromSuperview];
        }
        CGSize newSize = CGSizeMake(dataView1.frame.size.width, 25*pollutionDataArray.count);
        [dataView1 setContentSize:newSize];
        for (int i = 0; i < pollutionDataArray.count; i ++) {
            DataLabel *dataLable = [[DataLabel alloc]initWithFrame:AdaptCGRectMake(160, i*20, 140, 20)];
            dataLable.text = pollutionDataArray[i];
            dataLable.textAlignment = NSTextAlignmentLeft;
            [dataView1 addSubview:dataLable];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    [operation start];
    }
}
//能耗信息
- (void)loadConsumptionData{
    NSString *URLTmp = [NSString stringWithFormat:@"%@/PhoneInfo/GetTotalEnergyInfo/?",JFENERGYMANAGER_IP];
    NSMutableArray *idArr = [NSMutableArray array];
     if (self.selectedCompanys.count>0) {
    for (NSDictionary *dic in self.selectedCompanys) {
        [idArr addObject:[dic objectForKey:@"id"]];
    }
         
    NSString * string = [idArr componentsJoinedByString:@","];
    NSString *URL = [URLTmp stringByAppendingFormat:@"type=%@&id=%@&cookie=%@",self.selectedCompanys[0][@"type"],string,cookieString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URL]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        if ([requestTmp containsString:@"error"] == YES) {
            NSString *strr = [userDefaults objectForKey:@"loginState"];
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
            requestTmp=[requestTmp stringByReplacingOccurrencesOfString:@"'"withString:@"\""];
            NSError *error;
            SBJSON *sbjson=[[SBJSON alloc]init];
            consumptionDataArray = [NSMutableArray array];
            //用对象解析string
            NSArray *array = [sbjson objectWithString:requestTmp error:&error];
            for (NSDictionary *dic in array) {
                NSString *str = [dic[@"energyName"] stringByAppendingFormat:@":%@",dic[@"energyData"] ];
                if ([consumptionDataArray containsObject:str]!=YES) {
                    [consumptionDataArray addObject:str];
                }
            }
            
            for (UIView *view  in dataView.subviews) {
                [view removeFromSuperview];
            }
            CGSize newSize = CGSizeMake(dataView.frame.size.width, 25*consumptionDataArray.count);
            [dataView setContentSize:newSize];
            for (int i = 0; i < consumptionDataArray.count; i ++) {
                
                NSString *string = [NSString stringWithFormat:@"%@",consumptionDataArray[i]];
                DataLabel *dataLable = [[DataLabel alloc]initWithFrame:AdaptCGRectMake(30, i*20, 250, 20)];
                
                dataLable.text = string;
                [dataView addSubview:dataLable];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    [operation start];
}
}
//获取cookie
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
            
            [self loadDataa];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self alertView];
    }];
}
//警告
- (void)alertView{
    if (!alertOfView) {
        alertOfView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络或连接不到服务器！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertOfView show];
    }
}
// 删除cookie
- (void)deleteCookie
{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    for (NSHTTPCookie *tempCookie in cookies) {
        [cookieStorage deleteCookie:tempCookie];
    }
}
//警告信息
- (void)addWarningData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        warningDataArray = [NSMutableArray array];
        //本地去参数加载
        userDefaults= [NSUserDefaults standardUserDefaults];
        MAXX = [userDefaults objectForKey:@"warningDataArrayDeu"];
        NSString *URLStr = [NSString stringWithFormat:@"%@/PhoneInfo/GetMonitorWarnData/?",JFENERGYMANAGER_IP];
        
        NSMutableArray *idArr = [NSMutableArray array];
         if (self.selectedCompanys.count>0) {
        for (NSDictionary *dic in self.selectedCompanys) {
            [idArr addObject:[dic objectForKey:@"id"]];
        }
             
        NSDictionary *parameters = @{@"cookie":cookieString};
        NSString * string = [idArr componentsJoinedByString:@","];
        NSString *URL = [URLStr stringByAppendingFormat:@"type=%@&id=%@",self.selectedCompanys[0][@"type"],string];
             
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json", nil];
        [manager GET:URL parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSArray *array = responseObject;
            
            if (warningDataArray.count>0) {
                [warningDataArray removeAllObjects];
            }
            
            NSMutableArray *wwarningarr = [NSMutableArray array];
            for (NSDictionary *dic in array) {
                NSString *str = dic[@"id"];
                [wwarningarr addObject:str];
            }
            NSNumber *maxCount = [wwarningarr valueForKeyPath:@"@max.floatValue"];
            
            if (wwarningarr.count != 0) {
                userDefaults= [NSUserDefaults standardUserDefaults];
                [userDefaults removeObjectForKey:@"warningDataArrayDeu"];
                //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
                [userDefaults setObject:maxCount forKey:@"warningDataArrayDeu"];
                
                for (NSDictionary *dic in array) {
                    NSMutableDictionary *tttt = [dic mutableCopy];
                    NSInteger i = [tttt[@"id"] integerValue];
                    NSInteger j = [MAXX integerValue];
                    if (i > j) {
                        [tttt setObject:@"0" forKey:@"key"];
                        [warningDataArray addObject:tttt];
                        
                    }else{
                        [tttt setObject:@"1" forKey:@"key"];
                        [warningDataArray addObject:tttt];
                    }
                }
                NSMutableArray *aaar = [NSMutableArray array];
                for (NSDictionary *dic in warningDataArray) {
                    if ([dic[@"key"] isEqual:@"0"]) {
                        [aaar addObject:dic];
                    }
                }
                 navigationBarView.BBValuesLable.text = [NSString stringWithFormat:@"%lu",(unsigned long)aaar.count];
                [warningTableView reloadData];

            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        }];}
    });
}
//实时能耗及选择
- (void)addLineGraphOfRealtimeEnergyConsumption{
    _realtimeEnergyConsumptionView = [[TimeEnergyView alloc]initWithFrame:AdaptCGRectMake(0, 94, 320, 150)];
    _realtimeEnergyConsumptionView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    
    UIView *realtimeEnergyConsumption = [[UIView alloc]initWithFrame:AdaptCGRectMake(0, 64, 320, _realtimeEnergyConsumptionView.frame.origin.y-64)];
    realtimeEnergyConsumption.backgroundColor = [UIColor clearColor];
    
    imageAndTextView *image = [[imageAndTextView alloc]initWithFrame:AdaptCGRectMake(0, 0, 300, 30)];
    image.imageView.image = [UIImage imageNamed:@"ontime"];
    image.lable.text = @"实时能耗";
    [realtimeEnergyConsumption addSubview:image];
    
    UIButton *buttonOfchoice = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonOfchoice.frame = AdaptCGRectMake(240, 7, 70, 16);
    UIImage *rightarrow=[UIImage imageNamed:@"arrow"];
    UIImageView *areaimage=[[UIImageView alloc]initWithFrame:AdaptCGRectMake(50,1, 14, 14)];
    [areaimage setImage:rightarrow];
    [buttonOfchoice addSubview:areaimage];
    buttonOfchoice.backgroundColor = [UIColor whiteColor];
    buttonOfchoice.layer.cornerRadius = buttonOfchoice.frame.size.height/2;
    buttonOfchoice.layer.masksToBounds = YES;
    [buttonOfchoice addTarget:self action:@selector(otherChoice) forControlEvents:UIControlEventTouchUpInside];
    lableAndbuttonOfTime = [[UILabel alloc]initWithFrame:AdaptCGRectMake(0, 0, 50, 16)];
    lableAndbuttonOfTime.text = @"无数据";
    lableAndbuttonOfTime.textColor = [UIColor colorWithRed:53.0/255.0 green:170.0/255.0 blue:0.0/255.0 alpha:1];
    lableAndbuttonOfTime.font = [UIFont systemFontOfSize:14];
    lableAndbuttonOfTime.textAlignment = NSTextAlignmentCenter;
    [buttonOfchoice addSubview:lableAndbuttonOfTime];
    
    [realtimeEnergyConsumption addSubview:buttonOfchoice];
    [self.view addSubview:realtimeEnergyConsumption];
    [self.view addSubview:_realtimeEnergyConsumptionView];
}
//分段选择器
- (void)addSegment{
    URBSegmentedControl *segmentedControl = [[URBSegmentedControl alloc]initWithTitles:@[@" 能  耗  信  息  ",@"污染气体排放"] icons:@[[UIImage imageNamed:@"information"],[UIImage imageNamed:@"contaminated1"]] selecticons:nil ];
    segmentedControl.frame = AdaptCGRectMake(20, 255, 280, 25);
    segmentedControl.baseColor = [UIColor colorWithRed:53/255.0 green:162/255.0 blue:0.0 alpha:1];
    segmentedControl.layer.cornerRadius = segmentedControl.frame.size.height/8;
    segmentedControl.layer.masksToBounds = YES;
    segmentedControl.layer.borderWidth = 0.5;
    segmentedControl.layer.borderColor = [UIColor whiteColor].CGColor;
    segmentedControl.selectedSegmentIndex=0;
    [segmentedControl setImageColor:[UIColor colorWithRed:53/255.0 green:162/255.0 blue:0.0 alpha:1] forState:UIControlStateSelected];
    segmentedControl.selectedImageColor = [UIColor colorWithRed:53/255.0 green:162/255.0 blue:0.0 alpha:1];
    [segmentedControl setImageColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view addSubview:segmentedControl];
    
    dataView = [[DataView alloc]initWithFrame:AdaptCGRectMake(0, 280, 320, 75)];
    [self.view addSubview:dataView];
    dataView1 = [[DataView alloc]initWithFrame:AdaptCGRectMake(0, 280, 320, 75)];
   
    [segmentedControl setControlEventBlock:^(NSInteger index, URBSegmentedControl *segmentedControl) {
        if (index == 0) {
            [dataView1 removeFromSuperview];
            [self.view addSubview:dataView];
            [self loadConsumptionData];
            
        }else{
            [dataView removeFromSuperview];
            [self.view addSubview:dataView1];
            [self pollutionData];
        }
    }];
}
//能耗构成
- (void)addEnergyConsumption{
    imageAndTextView *image = [[imageAndTextView alloc]initWithFrame:AdaptCGRectMake(0, 350, 300, 30)];
    image.imageView.image = [UIImage imageNamed:@"structure"];
    image.lable.text = @"能耗构成";
    [self.view addSubview:image];
    
    myscrollview = [[UIScrollView alloc ] initWithFrame:AdaptCGRectMake(0, 380, 320, 130)];
    myscrollview.directionalLockEnabled = YES; //只能一个方向滑动
    
    myscrollview.pagingEnabled = YES; //是否翻页
    myscrollview.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.1];
    myscrollview.showsVerticalScrollIndicator =NO; //垂直方向的滚动指示
    myscrollview.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    myscrollview.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    myscrollview.delegate = self;
    
    [self.view addSubview:myscrollview];
    [self addCircleView];
    [self addSheetView];
}
//表格
- (void)addSheetView{
    NSMutableArray *tttArray = [NSMutableArray arrayWithObjects:@"", nil];
    NSMutableArray *qqqArray = [NSMutableArray array];
    [energyBMs insertObject:@"能耗值(千克标准煤)" atIndex:0];
    [qqqArray insertObject:@"比例" atIndex:0];
    for (NSString *str in values) {
        //从字符 中分隔成2个元素的数组
        NSArray *array1 = [str componentsSeparatedByString:@" "];
        [tttArray addObject:array1[0]];
        [qqqArray addObject:array1[1]];
    }
    
    UIView *lable = (UIView *)[myscrollview viewWithTag:5];
    if (lable) {
        [lable removeFromSuperview];
    }
    
    UIView *ttableView = [[UIView alloc]initWithFrame:AdaptCGRectMake(320, 0, 320, 130)];
    ttableView.tag = 5;
    [myscrollview addSubview:ttableView];
    
    CGSize newSize = CGSizeMake(ttableView.frame.size.width+ttableView.frame.origin.x, myscrollview.frame.size.height);
    [myscrollview setContentSize:newSize];
    if (tttArray.count > 1) {
        for (int i = 0; i < tttArray.count; i ++) {
            UILabel *titleeLable = [[UILabel alloc]initWithFrame:AdaptCGRectMake((320+(tttArray.count))/tttArray.count * i+1, 40, (320+(tttArray.count)-1)/tttArray.count, 18)];
            titleeLable.backgroundColor= [UIColor colorWithWhite:1 alpha:0.2];
            titleeLable.text = tttArray[i];
            titleeLable.font = [UIFont systemFontOfSize:13.0];
            titleeLable.textAlignment = NSTextAlignmentCenter;
            titleeLable.textColor = [UIColor whiteColor];
            [ttableView addSubview:titleeLable];
            
            UILabel *titleeeLable = [[UILabel alloc]initWithFrame:AdaptCGRectMake((320+(tttArray.count))/tttArray.count * i+1,  59, (320+(tttArray.count)-1)/tttArray.count, 20)];
            titleeeLable.backgroundColor= [UIColor colorWithRed:176.0/255 green:208/255.0 blue:166/255.0 alpha:1];
            titleeeLable.text = qqqArray[i];
            titleeeLable.font = [UIFont systemFontOfSize:12.0];
            titleeeLable.textAlignment = NSTextAlignmentCenter;
            titleeeLable.textColor = [UIColor colorWithRed:53.0/255.0 green:170.0/255.0 blue:0.0/255.0 alpha:1];
            
            [ttableView addSubview:titleeeLable];
            
            UILabel *titleoeLable = [[UILabel alloc]initWithFrame:AdaptCGRectMake((320+(tttArray.count))/tttArray.count * i+1, 80, (320+(tttArray.count)-1)/tttArray.count, 30)];
            titleoeLable.backgroundColor= [UIColor colorWithRed:176.0/255 green:208/255.0 blue:166/255.0 alpha:1];
            titleoeLable.text = energyBMs[i];
            titleoeLable.font = [UIFont systemFontOfSize:12.0];
            titleoeLable.textAlignment = NSTextAlignmentCenter;
            titleoeLable.textColor = [UIColor colorWithRed:53.0/255.0 green:170.0/255.0 blue:0.0/255.0 alpha:1];
            titleoeLable.numberOfLines = 2;
            [ttableView addSubview:titleoeLable];
        }
    }
}
//饼状图
- (void)addCircleView{
    // Chart View
    _chartView = [[TWRChartView alloc] initWithFrame:AdaptCGRectMake(95, 0, 130, 130)];
    _chartView.backgroundColor = [UIColor clearColor];
    [myscrollview addSubview:_chartView];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:AdaptCGRectMake(35, 55, 60, 20)];
    lable.text = @"暂无数据";
    lable.tag = 1050;
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:15.0];
    [lable adjustsFontSizeToFitWidth];
    [_chartView addSubview:lable];
    [self addOtherPieView];
}
//警告表视图
- (void)addtableViewOfWarning{
    warningTableView = [[UITableView alloc]initWithFrame:AdaptCGRectMake(50, 64, 225, 300) style:UITableViewStylePlain];
    
    warningTableView.scrollEnabled = YES;
    warningTableView.sectionHeaderHeight = 0;
    warningTableView.sectionFooterHeight = 0;
    warningTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    warningTableView.backgroundColor = [UIColor whiteColor];
    warningTableView.delegate = self;
    warningTableView.dataSource = self;
}
//实时能耗其他选择
- (void)addOtherchoice{
    if (otherView) {
        [otherView removeFromSuperview];
        ishidden = YES;
    }
    
    otherView = [[UIView alloc]initWithFrame:AdaptCGRectMake(240, 90, 70, _energyNameArray.count*24)];
    otherView.backgroundColor = [UIColor whiteColor];
    NSString *strr = [userDefaults objectForKey:@"timeChoice"];

    if (_energyNameArray.count>0) {
        
            if ([_energyNameArray containsObject:strr]) {
                lableAndbuttonOfTime.text = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"timeChoice"]];
            }else{
            lableAndbuttonOfTime.text=_energyNameArray[0];
        }
    }
    int j=0;
    for (int i = 0; i < _energyNameArray.count; i ++) {
        if ([_energyNameArray[i] isEqual:strr]) {
            j = i;
        }
    }
    
    [_realtimeEnergyConsumptionView getArray:_energyValueArray and:_colorArray and:j];

    
    for (int i = 0; i < _energyNameArray.count; i ++) {
        UIButton *choiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        choiceButton.frame = AdaptCGRectMake(0, 0 + i * 24, 70, 24);
        [choiceButton setTitle:_energyNameArray[i] forState:UIControlStateNormal];
        [choiceButton setTitleColor:[UIColor colorWithRed:53.0/255.0 green:170/255.0 blue:0.0/255.0 alpha:1] forState:UIControlStateNormal];
        choiceButton.tag = i;
        
        choiceButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [choiceButton addTarget:self action:@selector(choiceAnother:) forControlEvents:UIControlEventTouchUpInside];
        
        [otherView addSubview:choiceButton];
        
        if (i < _energyNameArray.count-1) {
            UIView *lineview = [[UIView alloc]initWithFrame:AdaptCGRectMake(0, 23, 70, 1)];
            lineview.backgroundColor = [UIColor lightGrayColor];
            [choiceButton addSubview:lineview];
        }
    }
}

- (void)choiceAnother:(UIButton *)sender{
    lableAndbuttonOfTime.text = sender.titleLabel.text;
    [_realtimeEnergyConsumptionView getArray:_energyValueArray and:_colorArray  and:sender.tag];
    [userDefaults setObject:sender.titleLabel.text forKey:@"timeChoice"];

    isHidden = YES;
    [warningTableView removeFromSuperview];
    ishidden = YES;
    [otherView removeFromSuperview];
}

/*导航栏选择*/
- (void)selectorOfWarnAndChooce:(UIButton *)sender{
    switch (sender.tag) {
        case 100:
        {
            if (otherView) {
            ishidden = YES;
            [otherView removeFromSuperview];
            }
            /*tableView隐现*/
            if (isHidden != YES) {
                isHidden = YES;
                if (![navigationBarView.BBValuesLable.text isEqual:@"0"]) {
                    navigationBarView.BBValuesLable.text = @"0";
                }
//                给所有预警信息标示已读
                for (NSMutableDictionary *dic in warningDataArray) {
                [dic setObject:@"1" forKey:@"key"];
                }
                
                [warningTableView reloadData];
                [warningTableView removeFromSuperview];
            }else{
                isHidden = NO;
                if (warningDataArray.count == 0) {
                    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有新故障表或者网络延迟,请稍后查看!" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self addWarningData];
                    }];
                    [alertView addAction:cancelAction];
                    [self presentViewController:alertView animated:YES completion:nil];
                }else{
                    float y = warningDataArray.count*50*(SCREEN_HEIGHT/568.0);
                    if (y > warningTableView.frame.size.height) {
                        y = 300*(SCREEN_HEIGHT/568.0);
                    }
                    
                    [warningTableView setFrame:CGRectMake(warningTableView.frame.origin.x, warningTableView.frame.origin.y, warningTableView.frame.size.width,y)];
                    [self.view addSubview:warningTableView];
                }
                
            }
        }
            break;
        case 101:
        {
            
            _selectedCompanys = nil;
            chooseViewController = [AllChooseViewController new];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:chooseViewController];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
            break;
        default:
            break;
    }}

- (void)otherChoice{
    if (ishidden != YES) {
        ishidden = YES;
        [otherView removeFromSuperview];
    }else{
        ishidden = NO;
        [self.view addSubview:otherView];
        
    }
    isHidden = YES;
    [warningTableView removeFromSuperview];
}

/**
 *  UITableViewDataSource
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return warningDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    warningViewcellTableViewCell *cell = [[warningViewcellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"warningCell"];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        UIView *line = [cell viewWithTag:100];
        if (line) {
            [line removeFromSuperview];
        }
    }
        // 更新界面
        if (warningDataArray.count>0) {
            NSString *dic = warningDataArray[indexPath.row][@"key"];
            if ([dic isEqual:@"0"]) {
                warningDataArray[indexPath.row][@"key"] = @"1";
                cell.news.image = [UIImage imageNamed:@"news"];
            }else{
                cell.news.image = [UIImage imageNamed:@""];
            }
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in warningDataArray) {
                if ([dic[@"key"] isEqual:@"0"]) {
                    [arr addObject:dic];
                }
            }
            navigationBarView.BBValuesLable.text = [NSString stringWithFormat:@"%ld",(unsigned long)arr.count];
            
            cell.title.text = warningDataArray[indexPath.row][@"name"];
            cell.time.text = warningDataArray[indexPath.row][@"warningtime"];
            cell.details.text = warningDataArray[indexPath.row][@"descr"];
        }
    
    return cell;
}
/**
 *  UITableViewDelegate
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.bounds.size.height*50/568.0;
}

- (void)tapGesture:(UITapGestureRecognizer *)tap{
    if (isHidden!=YES) {
        isHidden = YES;
        [warningTableView removeFromSuperview];
        if (![navigationBarView.BBValuesLable.text isEqual:@"0"]) {
            navigationBarView.BBValuesLable.text = @"0";
        }
        for (NSDictionary *dic in warningDataArray) {
            NSMutableDictionary *ddd = [dic mutableCopy];
            [ddd setObject:@"1" forKey:@"key"];
        }
        [warningTableView reloadData];
    }
    
    if (ishidden!=YES) {
        ishidden = YES;
        [otherView removeFromSuperview];
    }
    
    tabbarVC.viewisHidden = NO;
    [tabbarVC.otherChoiceView removeFromSuperview];
}

//将颜色转换为图片
-(UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=AdaptCGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//将字符串转换为颜色
- (UIColor *)stringTOColor:(NSString *)str
{
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
