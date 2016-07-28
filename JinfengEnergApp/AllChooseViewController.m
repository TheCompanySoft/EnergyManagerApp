//
//  ChooseViewController.m
//  JinfengEnergApp
//
//  Created by BlackChen on 15/12/8.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "AllChooseViewController.h"
#import "HomeViewController.h"

@interface AllChooseViewController (){
    RDVTabBarController *tabbarVC;
    //    已选城市
    UIView *selectedView;
    //    市级选项
    NSMutableArray *citysArray;
    NSMutableArray *selectedCityArray;
    //    区选项
    NSMutableArray *areaArray;
    NSMutableArray *selectedAreaArray;
    //    公司选项
    NSMutableArray *companyArray;
    NSMutableArray *selectedCompanyArray;
//    已选数组
    NSMutableArray *selectedArray;
//    滚动视图
    UIScrollView *dataScrollviewView;
//    市／区／企业
    UIScrollView *cityScrollView;
    UIScrollView *areaScrollView;
    UIScrollView *companyScrollView;
    
    //    单选信息
    NSMutableDictionary *dicInfo;
//    省份信息
    NSDictionary *dicInfoo;
//    市,区，企业上一层拼接
    NSString *str00;
    NSString *str11;
    NSString *str22;
    
//    警告
    UIAlertView *alertView;
}

@end

@implementation AllChooseViewController

- (void)viewWillAppear:(BOOL)animated{
    if ([tabbarVC isKindOfClass:[RDVTabBarController class]])
    {
        tabbarVC.tabBar.hidden = YES;
    }
    self.navigationController.navigationBarHidden = YES;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    self.title = @"筛选";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIImageView *loginImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"big_background"]];
    loginImageView.frame = self.view.frame;
    [self.view addSubview:loginImageView];
    [self settabBarButton];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    selectedArray = [userDefaults objectForKey:@"allSelectedCompany"];
    if (selectedArray.count > 0) {
        [self addSelectedViewone];
    }

    [self addChooseOfbusinesss];
}
//导航栏
- (void)settabBarButton{
    NavigationBarView *navigationBarView = [[NavigationBarView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 64)];
    navigationBarView.title_Lable.text = @"筛选";
    [navigationBarView addSubview:navigationBarView.leftButton];
    [navigationBarView.leftButton addTarget:self action:@selector(rightbackClicka) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigationBarView];
    
    UILabel *textLable = [[UILabel alloc]initWithFrame:AdaptCGRectMake(15, 64
                                                                       , 100, 25)];
    textLable.text = @"已选企业";
    textLable.textColor = [UIColor whiteColor];
    textLable.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:textLable];
    selectedView = [[UIView alloc]initWithFrame:AdaptCGRectMake(0, 88, 320, 150)];
    [self.view addSubview:selectedView];
}
//加载数据
- (void)loadData{
    dicInfo = [NSMutableDictionary dictionary];
    dicInfoo = @{@"name":@"市",@"id":JFENERGYMANAGER_ID,@"type":@"0"};

    selectedCityArray = [NSMutableArray array];
    selectedAreaArray = [NSMutableArray array];
    selectedCompanyArray = [NSMutableArray array];
    selectedArray = [NSMutableArray array];
    [self loadCitysDataa];
}
//企业
- (void)loadCompanyDataa{
    NSString *url = [NSString stringWithFormat:@"%@/CenterMain/GetEnterName?",JFENERGYMANAGER_IP];

    NSString *URLTmp = [url stringByAppendingFormat:@"dataid=%@",dicInfo[@"id"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URLTmp]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        requestTmp=[requestTmp stringByReplacingOccurrencesOfString:@"'"withString:@"\""];
        NSError *error;
        SBJSON *sbjson=[[SBJSON alloc]init];
        //用对象解析string
        NSArray *array = [sbjson objectWithString:requestTmp error:&error];
        if (array.count>0) {
            str22 = [NSString stringWithFormat:@"%@-全部",dicInfo[@"name"]];
            companyArray = [NSMutableArray arrayWithObject:@{@"type":@"2",@"name":str22,@"id":dicInfo[@"id"]}];
            for (NSDictionary *dic in array) {
                [dic setValue:@"3" forKey:@"type"];
                [companyArray addObject:dic];
            }
            [self addCompany1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self alertView];
    }];
    [operation start];
}
//市区
- (void)loadAreaDataa{
    NSString *url = [NSString stringWithFormat:@"%@/CenterMain/GetAreaName/?",JFENERGYMANAGER_IP];

    NSString *URLTmp = [url stringByAppendingFormat:@"dataid=%@",dicInfo[@"id"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URLTmp]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        requestTmp=[requestTmp stringByReplacingOccurrencesOfString:@"'"withString:@"\""];
        NSError *error;
        SBJSON *sbjson=[[SBJSON alloc]init];
        //用对象解析string
        NSArray *array = [sbjson objectWithString:requestTmp error:&error];
        if (array.count>0) {
            str11 = [NSString stringWithFormat:@"%@-全部",dicInfo[@"name"]];
            areaArray = [NSMutableArray arrayWithObject:@{@"type":@"1",@"name":str11,@"id":dicInfo[@"id"]}];
            for (NSDictionary *dic in array) {
                [dic setValue:@"2" forKey:@"type"];
                [areaArray addObject:dic];
            }
            [self addArea1];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self alertView];
    }];
    [operation start];}
//城市
- (void)loadCitysDataa{
    NSString *URLTmp = [NSString stringWithFormat:@"%@/CenterMain/GetCityName/?",JFENERGYMANAGER_IP];

    NSString *URL = [URLTmp stringByAppendingFormat:@"dataid=%@",dicInfoo[@"id"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URL]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        requestTmp=[requestTmp stringByReplacingOccurrencesOfString:@"'"withString:@"\""];
        NSError *error;
        SBJSON *sbjson=[[SBJSON alloc]init];
        //用对象解析string
        NSMutableArray *array = [sbjson objectWithString:requestTmp error:&error];
        if (array.count>0) {
            str00 = [NSString stringWithFormat:@"%@-全部",dicInfoo[@"name"]];
          citysArray = [NSMutableArray arrayWithObject:@{@"type":@"0",@"name":str00,@"id":dicInfoo[@"id"]}];
            for (NSDictionary *dic in array) {
                [dic setValue:@"1" forKey:@"type"];
                [citysArray addObject:dic];
            }
            [self addCity1];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self alertView];
    }];
    [operation start];
}

//警告
- (void)alertView{
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络或连接不到服务器！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
}

- (void)addSelectedViewone{
    for (UIView *view in selectedView.subviews) {
        [view removeFromSuperview];
    }
    
    int btag = 0;
    int num = (int)selectedArray.count / 3 + 1; // 循环次数
    for (int i = 0; i < num; i ++) {
        int max = 0;
        if (i == num - 1) {
            max = selectedArray.count % 3;// 如果是最后一个循环，就取余数
        }else {
            max = 3;// 不是最后一个循环，就初始化3个对象
        }
        for (int j = 0; j < max; j ++) {
            // 具体初始化的内容
            UIButton *selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
            selectedButton.frame =  AdaptCGRectMake(10+j * 106, 1+i * (30+6), 87, 30);
            selectedButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
            selectedButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            UILabel *blable = [[UILabel alloc]initWithFrame:AdaptCGRectMake(0, 0, 84, 30)];
            blable.text = selectedArray[btag][@"name"];
            blable.textAlignment = NSTextAlignmentCenter;
            blable.font = [UIFont systemFontOfSize:13.0];
            blable.numberOfLines = 2;
            blable.textColor = [UIColor colorWithRed:53/255.0 green:170/255.0 blue:0.0 alpha:1];
            blable.layer.cornerRadius = blable.frame.size.height/2;
            blable.layer.masksToBounds = YES;
            blable.backgroundColor = [UIColor colorWithRed:206/255.0 green:236/255.0 blue:189/255.0 alpha:1];
            [selectedButton addSubview:blable];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame: AdaptCGRectMake(74, 1, 13, 13)];
            imageView.layer.cornerRadius = imageView.frame.size.height/2;
            imageView.layer.masksToBounds = YES;
            imageView.backgroundColor = [UIColor redColor];
            imageView.image = [UIImage imageNamed:@"close"];
            [selectedButton addSubview:imageView];
            
            [selectedButton setTitle:selectedArray[btag][@"name"] forState:UIControlStateNormal];
            [selectedButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            selectedButton.tag = [selectedArray[btag][@"id"] integerValue];

            [selectedView addSubview:selectedButton];
            btag ++;
        }
    }
}

//    添加已选城市
- (void)addSelectedVieww{
    for (UIView *view in selectedView.subviews) {
        [view removeFromSuperview];
    }
    
    int btag = 0;
    int num = (int)selectedArray.count / 3 + 1; // 循环次数
    for (int i = 0; i < num; i ++) {
        int max = 0;
        if (i == num - 1) {
            max = selectedArray.count % 3;// 如果是最后一个循环，就取余数
        }else {
            max = 3;// 不是最后一个循环，就初始化3个对象
        }
        for (int j = 0; j < max; j ++) {
            // 具体初始化的内容
            UIButton *selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
            selectedButton.frame =  AdaptCGRectMake(10+j * 106, 1+i * (30+6), 87, 30);
            selectedButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
            selectedButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            UILabel *blable = [[UILabel alloc]initWithFrame:AdaptCGRectMake(0, 0, 84, 30)];
            blable.text = selectedArray[btag][@"name"];
            blable.textAlignment = NSTextAlignmentCenter;
            blable.font = [UIFont systemFontOfSize:13.0];
            blable.numberOfLines = 2;
            blable.textColor = [UIColor colorWithRed:53/255.0 green:170/255.0 blue:0.0 alpha:1];
            blable.layer.cornerRadius = blable.frame.size.height/2;
            blable.layer.masksToBounds = YES;
            blable.backgroundColor = [UIColor colorWithRed:206/255.0 green:236/255.0 blue:189/255.0 alpha:1];
            [selectedButton addSubview:blable];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame: AdaptCGRectMake(74, 1, 13, 13)];
            imageView.layer.cornerRadius = imageView.frame.size.height/2;
            imageView.layer.masksToBounds = YES;
            imageView.backgroundColor = [UIColor redColor];
            imageView.image = [UIImage imageNamed:@"close"];
            [selectedButton addSubview:imageView];
            
            [selectedButton setTitle:selectedArray[btag][@"name"] forState:UIControlStateNormal];
            [selectedButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            selectedButton.tag = [selectedArray[btag][@"id"] integerValue];
            [selectedButton addTarget:self action:@selector(moveChoiceButtonItem1:) forControlEvents:UIControlEventTouchUpInside];
            [selectedView addSubview:selectedButton];
            btag ++;
        }
    }
}
//    已选若selectedArray含则移除
- (void)moveChoiceButtonItem1:(UIButton *)sender{
    [sender removeFromSuperview];
    for (NSDictionary *dic in selectedArray) {
        NSInteger tagb = [dic[@"id"] integerValue];
        if (sender.tag == tagb) {
            dicInfo = nil;
            dicInfo = [dic copy];
        }
    }
    
    if ([selectedArray containsObject:dicInfo] == YES) {
        [selectedArray removeObject:dicInfo];
        [self addSelectedVieww];
    }
    if (selectedCompanyArray.count!=0) {
        if ([dicInfo[@"name"] isEqual:str22]) {
            [selectedCompanyArray removeAllObjects];
        }else{
            if ([selectedCompanyArray[0][@"id"] isEqual:dicInfo[@"id"]]) {
                [selectedCompanyArray removeObject:dicInfo];
            }
        }
        
        [self addCompany1];
    }else if (selectedAreaArray.count != 0){
        if ([selectedAreaArray[0][@"id"] isEqual:dicInfo[@"id"]]) {
            [selectedAreaArray removeAllObjects];
            [selectedCompanyArray removeAllObjects];
        }
        [self addArea1];
    }else if (selectedCityArray.count != 0){
        if ([selectedCityArray[0][@"id"] isEqual:dicInfo[@"id"]]) {
            [selectedCityArray removeAllObjects];
            [selectedAreaArray removeAllObjects];
            [selectedCompanyArray removeAllObjects];
        }
        [self addCity1];
    }
}
//添加城市
- (void)addCity1{
    cityScrollView = (UIScrollView *)[self.view viewWithTag:450];
    for (UIView *view  in cityScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < citysArray.count; i ++) {
        UIButton *cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cityButton.frame =  AdaptCGRectMake(10, 3+30*i, 86, 27);
        cityButton.tag = [citysArray[i][@"id"] integerValue];
        [cityButton setTitle:citysArray[i][@"name"] forState:UIControlStateNormal];
        cityButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        cityButton.titleLabel.numberOfLines = 2;
        cityButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);//设置title在button上的位置（上top，左left，下bottom，右right）
        cityButton.layer.cornerRadius= cityButton.frame.size.height/2;
        cityButton.layer.masksToBounds = YES;
        [cityButton addTarget:self action:@selector(allChoiceCityButtonItem1:) forControlEvents:UIControlEventTouchUpInside];
        
        for (NSDictionary *dic in selectedCityArray) {
            if ([dic[@"name"] isEqual:cityButton.titleLabel.text]) {
                [cityButton setBackgroundImage:[UIImage imageNamed:@"select2_bg"] forState:UIControlStateNormal];
                cityButton.selected = YES;
                [cityButton setTitleColor:[UIColor colorWithRed:53/255.0 green:170/255.0 blue:0.0 alpha:1] forState:UIControlStateNormal];
            }
        }
        
        [cityScrollView addSubview:cityButton];
    }}
//添加区域
- (void)addArea1{
    areaScrollView = (UIScrollView *)[self.view viewWithTag:451];
    companyScrollView = (UIScrollView *)[self.view viewWithTag:452];
    
    for (UIView *view in areaScrollView.subviews) {
        [view removeFromSuperview];
        for (UIView *view1 in companyScrollView.subviews) {
            [view1 removeFromSuperview];
        }
    }
    
    for (int i = 0; i < areaArray.count; i ++) {
        UIButton *cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cityButton.frame =  AdaptCGRectMake(10, 3+30*i, 86, 27);
        cityButton.tag = [areaArray[i][@"id"] integerValue];
        cityButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        
        cityButton.layer.cornerRadius = cityButton.frame.size.height/2;
        cityButton.layer.masksToBounds = YES;
        cityButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);//设置title在button上的位置（上top，左left，下bottom，右right）
        cityButton.titleLabel.numberOfLines = 2;
        
        cityButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cityButton setTitle:areaArray[i][@"name"] forState:UIControlStateNormal];
        [cityButton addTarget:self action:@selector(allChoiceAreaButtonItem1:) forControlEvents:UIControlEventTouchUpInside];
        
        
        for (NSDictionary *dic in selectedAreaArray) {
            if ([dic[@"name"] isEqual:cityButton.titleLabel.text]) {
                [cityButton setBackgroundImage:[UIImage imageNamed:@"select2_bg"] forState:UIControlStateNormal];
                
                cityButton.selected = YES;
                [cityButton setTitleColor:[UIColor colorWithRed:53/255.0 green:170/255.0 blue:0.0 alpha:1] forState:UIControlStateNormal];
            }
        }
        
        [areaScrollView addSubview:cityButton];
    }
    
    if (areaScrollView.subviews == 0) {
        for (UIView *view in companyScrollView.subviews) {
            [view removeFromSuperview];
        }
    }
    
}
//添加企业
- (void)addCompany1{
    companyScrollView = (UIScrollView *)[self.view viewWithTag:452];
    for (UIView *view in companyScrollView.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < companyArray.count; i ++) {
        UIButton *cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cityButton.frame =  AdaptCGRectMake(10, 3+30*i, 86, 27);
        cityButton.tag = [companyArray[i][@"id"] integerValue];
        cityButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        cityButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);//设置title在button上的位置（上top，左left，下bottom，右right）
        cityButton.titleLabel.numberOfLines = 2;
        cityButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        cityButton.layer.cornerRadius = cityButton.frame.size.height/2;
        cityButton.layer.masksToBounds = YES;
        [cityButton setTitle:companyArray[i][@"name"] forState:UIControlStateNormal];
        [cityButton addTarget:self action:@selector(allChoiceCompanyButtonItema:) forControlEvents:UIControlEventTouchUpInside];
        [companyScrollView addSubview:cityButton];
        for (NSDictionary *dic in selectedCompanyArray) {
            if ([dic[@"name"] isEqual:cityButton.titleLabel.text]) {
                [cityButton setBackgroundImage:[UIImage imageNamed:@"select_yellow"] forState:UIControlStateNormal];
                
                cityButton.selected = YES;
                [cityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)allChoiceCompanyButtonItema:(UIButton*)sender{
    for (NSDictionary *dic in companyArray) {
        NSInteger tagb = [dic[@"id"] integerValue];
        if (sender.tag == tagb) {
            dicInfo = nil;
            dicInfo = [dic copy];
        }
    }
    if (sender.selected != YES) {
        sender.selected = YES;
        if ([sender.titleLabel.text isEqual:str22]) {
            for (NSDictionary *dic in companyArray) {
                if ([selectedCompanyArray containsObject:dic]!=YES) {
                    [selectedCompanyArray addObject:dic];
                }
            }
            selectedArray = [NSMutableArray arrayWithObject:dicInfo];
            
        }else{
            if ([selectedCompanyArray containsObject:dicInfo]!=YES) {
                [selectedCompanyArray addObject:dicInfo];
            }
            selectedArray = [selectedCompanyArray mutableCopy];
        }
    }else{
        sender.selected = NO;
}
    [self addCompany1];
    
    [self addSelectedVieww];
}

- (void)addChooseOfbusinesss{
    UIView *choiceView = [[UIView alloc]initWithFrame: AdaptCGRectMake(0, 274, 320, 568-274)];
    [self.view addSubview:choiceView];
    
    NSArray *titles = @[@"市",@"区",@"企业"];
    for (int i = 0; i < 3; i ++) {
        UILabel *titleLable = [[UILabel alloc]initWithFrame: AdaptCGRectMake(0+107*i, 244, 106, 30)];
        titleLable.backgroundColor= [UIColor colorWithWhite:1 alpha:0.3];
        titleLable.text = titles[i];
        titleLable.font = [UIFont systemFontOfSize:14];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.textColor = [UIColor whiteColor];
        [self.view addSubview:titleLable];
        
        dataScrollviewView = [[UIScrollView alloc]initWithFrame: AdaptCGRectMake(0+107*i, 274, 106, 240)];
        dataScrollviewView.directionalLockEnabled = YES; //只能一个方向滑动
        dataScrollviewView.pagingEnabled = NO; //是否翻页
        dataScrollviewView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
        dataScrollviewView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
        dataScrollviewView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
        CGSize newSize = CGSizeMake(dataScrollviewView.frame.size.width, dataScrollviewView.frame.size.height*3);
        dataScrollviewView.tag = 450+i;
        [dataScrollviewView setContentSize:newSize];
        [self.view addSubview:dataScrollviewView];
    }
    
    for (int i = 0; i < 2; i ++) {
        UIImageView *lineImageView = [[UIImageView alloc]initWithFrame: AdaptCGRectMake(106+107*i, 244, 1, 270)];
        lineImageView.backgroundColor = [UIColor colorWithRed:53/255.0 green:170/255.0 blue:0.0 alpha:1];
        [self.view addSubview:lineImageView];
    }
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame =  AdaptCGRectMake(20, 248, 280, 28);
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    sureButton.backgroundColor = [UIColor whiteColor];
    sureButton.layer.cornerRadius = sureButton.frame.size.height/2;
    sureButton.layer.masksToBounds = YES;
    [sureButton setTitleColor:[UIColor colorWithRed:53/255.0 green:170/255.0 blue:0.0 alpha:1] forState:UIControlStateNormal];
    
    sureButton.tag = 350;
    
    [sureButton addTarget:self action:@selector(backClicka:) forControlEvents:UIControlEventTouchUpInside];
    [choiceView addSubview:sureButton];
}
//公司选择
- (void)allChoiceAreaButtonItem1:(UIButton *)sender{
    for (NSDictionary *dic in areaArray) {
        NSInteger tagb = [dic[@"id"] integerValue];
        if (sender.tag == tagb) {
            dicInfo = nil;
            dicInfo = [dic copy];
        }
    }
    if (sender.selected != YES) {
        sender.selected = YES;
        [selectedAreaArray removeAllObjects];
        if ([sender.titleLabel.text isEqual:str11]) {
            [selectedCompanyArray removeAllObjects];
            selectedAreaArray = [areaArray mutableCopy];
            selectedArray = [NSMutableArray arrayWithObject:dicInfo];
            [self addSelectedVieww];
            for (UIView *view in companyScrollView.subviews) {
                [view removeFromSuperview];
            }
        }else{
            [selectedAreaArray addObject:dicInfo];
            //    选中就下载数据

            [self loadCompanyDataa];
        }
    }else{
        sender.selected = NO;
       }
    [self addArea1];
}
//市选择
- (void)allChoiceCityButtonItem1:(UIButton *)sender{
    for (NSDictionary *dic in citysArray) {
        NSInteger tagb = [dic[@"id"] integerValue];
        if (sender.tag == tagb) {
            dicInfo = nil;
            dicInfo = [dic copy];
        }
    }
        
    if (sender.selected != YES) {
        sender.selected = YES;
        [selectedCityArray removeAllObjects];
//        选择全部
        if ([sender.titleLabel.text isEqual:str00]) {
            [selectedAreaArray removeAllObjects];
            [selectedCompanyArray removeAllObjects];
            selectedCityArray = [citysArray mutableCopy];
            selectedArray = [NSMutableArray arrayWithObject:dicInfo];
            [self addSelectedVieww];
            
            for (UIView *view in areaScrollView.subviews) {
                [view removeFromSuperview];
            }
            for (UIView *view in companyScrollView.subviews) {
                [view removeFromSuperview];
            }
            
        }else{
            [selectedCityArray addObject:dicInfo];
            //    选中就下载数据
            [selectedAreaArray removeAllObjects];
            for (UIView *view in areaScrollView.subviews) {
                [view removeFromSuperview];
            }
            [self loadAreaDataa];
        }
    }else{
        sender.selected = NO;
        }
    [self addCity1];
    for (UIView *view in companyScrollView.subviews) {
        [view removeFromSuperview];
    }
}
//确定
- (void)backClicka:(UIButton *)sender{
    if (selectedArray.count>0) {
        //将上述数据全部存储到NSUserDefaults中
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
        [userDefaults removeObjectForKey:@"allSelectedCompany"];
        [userDefaults setObject:selectedArray forKey:@"allSelectedCompany"];
        //这里建议同步存储到磁盘中，但是不是必须的
        [userDefaults synchronize];
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:@"allSelectedCompany" object:@"allChoice" userInfo:@{@"allSelectedCompanys":selectedArray}];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
        
        
        //代理
        [self.delegat  businecode:selectedArray];
       [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择您想查看的企业!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertView addAction:cancelAction];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}
//返回
- (void)rightbackClicka{
    NSUserDefaults *dec = [NSUserDefaults standardUserDefaults];
    NSArray *array = [dec objectForKey:@"allSelectedCompany"];
    //创建一个消息对象
    if (array.count!=0) {
        NSNotification * notice = [NSNotification notificationWithName:@"allSelectedCompany" object:@"allChoice" userInfo:@{@"allSelectedCompanys":array}];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    }
   
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
