//
//  ChooseViewController.m
//  JinfengEnergApp
//
//  Created by BlackChen on 15/12/8.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "AnalysisChooseViewController.h"

@interface  AnalysisChooseViewController(){
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
    
    NSMutableArray *selectedArray;
    //区域iD
    NSString *idcode;
    //地视图
    UIScrollView *dataScrollviewView;
    //城市的滚动视图
    UIScrollView *cityScrollView;
    //区域的滚动视图
    UIScrollView *areaScrollView;
    //企业的滚动视图
    UIScrollView *companyScrollView;
    
    //    单选信息
    NSMutableDictionary *dicInfo;
    
//    警告
    UIAlertView *alertView;
}

@end

@implementation AnalysisChooseViewController

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
    UIImageView *loginImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"big_background"]];
    
    loginImageView.frame = self.view.frame;
    [self.view addSubview:loginImageView];
    [self settabBarButton];
    [self addSelectedView];
    
    [self addChooseOfbusiness];
}

//导航栏
- (void)settabBarButton{
    NavigationBarView *navigationBarView = [[NavigationBarView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 64)];
    navigationBarView.title_Lable.text = @"筛选";
    [navigationBarView addSubview:navigationBarView.leftButton];
    [navigationBarView.leftButton addTarget:self action:@selector(rightbackClick11) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigationBarView];
    
    UILabel *textLable = [[UILabel alloc]initWithFrame:AdaptCGRectMake(15, 64, 100, 25)];
    textLable.text = @"已选企业";
    textLable.textColor = [UIColor whiteColor];
    textLable.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:textLable];
    selectedView = [[UIView alloc]initWithFrame:AdaptCGRectMake(0, 88, 320, 150)];
    [self.view addSubview:selectedView];
}
//加载数据
- (void)rightbackClick11{
    //
    [self dismissViewControllerAnimated:YES completion:nil];
}
//数据
- (void)loadData{
    dicInfo = [NSMutableDictionary dictionary];
    selectedCityArray = [NSMutableArray array];
    selectedAreaArray = [NSMutableArray array];
    selectedCompanyArray = [NSMutableArray array];
    selectedArray = [NSMutableArray array];
    [self loadCitysData];
}
//数据请求
- (void)loadCompanyData{
    NSString *url = [NSString stringWithFormat:@"%@/CenterMain/GetEnterName?",JFENERGYMANAGER_IP];

    NSString *URLTmp = [url stringByAppendingFormat:@"dataid=%@",idcode];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URLTmp]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        requestTmp=[requestTmp stringByReplacingOccurrencesOfString:@"'"withString:@"\""];
        NSError *error;
        SBJSON *sbjson=[[SBJSON alloc]init];
        //用对象解析string
        NSArray *array = [sbjson objectWithString:requestTmp error:&error];
        companyArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            [dic setValue:@"3" forKey:@"type"];
            [companyArray addObject:dic];
        }
        
        [self addCompany];
        
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
//区域
- (void)loadAreaData{
    NSString *url = [NSString stringWithFormat:@"%@/CenterMain/GetAreaName/?",JFENERGYMANAGER_IP];

    NSString *URLTmp = [url stringByAppendingFormat:@"dataid=%@",idcode];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URLTmp]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        requestTmp=[requestTmp stringByReplacingOccurrencesOfString:@"'"withString:@"\""];
        NSError *error;
        SBJSON *sbjson=[[SBJSON alloc]init];
        //用对象解析string
        NSArray *array = [sbjson objectWithString:requestTmp error:&error];
        areaArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            [dic setValue:@"2" forKey:@"type"];
            [areaArray addObject:dic];
        }
        
        [self addArea];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self alertView];
    }];
    [operation start];}
//城市
- (void)loadCitysData{
    NSString *URLTmp = [NSString stringWithFormat:@"%@/CenterMain/GetCityName/?",JFENERGYMANAGER_IP];

    idcode = nil;
    idcode = JFENERGYMANAGER_ID;
    NSString *URL = [URLTmp stringByAppendingFormat:@"dataid=%@",idcode];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URL]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        requestTmp=[requestTmp stringByReplacingOccurrencesOfString:@"'"withString:@"\""];
        NSError *error;
        SBJSON *sbjson=[[SBJSON alloc]init];
        //用对象解析string
        citysArray = [NSMutableArray array];
        NSArray *array = [sbjson objectWithString:requestTmp error:&error];
        for (NSDictionary *dic in array) {
            [dic setValue:@"1" forKey:@"type"];
            [citysArray addObject:dic];
        }
        
        [self addCity];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self alertView];
    }];
    [operation start];}

- (void)addSelectedView{
    for (UIView *view in selectedView.subviews) {
        [view removeFromSuperview];
    }
    //    添加已选城市
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
            blable.textColor = [UIColor colorWithRed:53.0/255 green:170/255.0 blue:0 alpha:1];
            blable.layer.cornerRadius = blable.frame.size.height/2;
            blable.layer.masksToBounds = YES;
            blable.backgroundColor = [UIColor colorWithRed:206/255.0 green:236/255.0 blue:189/255.0 alpha:1];
            blable.textColor = [UIColor colorWithRed:53/255.0 green:170/255.0 blue:0.0 alpha:1];
            
            
            //            _businesable.backgroundColor=[UIColor colorWithRed:207.0/255 green:234/255.0 blue:182/255.0 alpha:1];
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
            [selectedButton addTarget:self action:@selector(moveChoiceButtonItem:) forControlEvents:UIControlEventTouchUpInside];
            [selectedView addSubview:selectedButton];
            btag ++;
        }
    }
}

- (void)moveChoiceButtonItem:(UIButton *)sender{
    [sender removeFromSuperview];
    //    已选若selectedArray含则移除
    for (NSDictionary *dic in selectedArray) {
        NSInteger tagb = [dic[@"id"] integerValue];
        if (sender.tag == tagb) {
            dicInfo = nil;
            dicInfo = [dic copy];
        }
    }
    if ([selectedArray containsObject:dicInfo] == YES) {
        [selectedArray removeObject:dicInfo];
        [self addSelectedView];
    }
    if (selectedCompanyArray.count!=0) {
        
        if ([selectedCompanyArray[0][@"id"] isEqual:dicInfo[@"id"]]) {
            [selectedCompanyArray removeObject:dicInfo];
        }
        
        [self addCompany];
    }else if (selectedAreaArray.count != 0){
        
        if ([selectedAreaArray[0][@"id"] isEqual:dicInfo[@"id"]]) {
            [selectedAreaArray removeAllObjects];
        }
        [self addArea];
    }else if (selectedCityArray.count != 0){
        if ([selectedCityArray[0][@"id"] isEqual:dicInfo[@"id"]]) {
            [selectedCityArray removeAllObjects];
        }
        [self addCity];
    }
}
//添加区域
- (void)addCity{
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
        cityButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);//设置title在button上的位置（上top，左left，下bottom，右right）
        cityButton.titleLabel.numberOfLines = 2;
        cityButton.layer.cornerRadius= cityButton.frame.size.height/2;
        cityButton.layer.masksToBounds = YES;
        [cityButton addTarget:self action:@selector(choiceCityButtonItem:) forControlEvents:UIControlEventTouchUpInside];
        
        for (NSDictionary *dic in selectedCityArray) {
            if ([dic[@"name"] isEqual:cityButton.titleLabel.text]) {
                [cityButton setBackgroundImage:[UIImage imageNamed:@"select2_bg"] forState:UIControlStateNormal];
                
                cityButton.selected = YES;
                [cityButton setTitleColor:[UIColor colorWithRed:53/255.0 green:170/255.0 blue:0.0 alpha:1] forState:UIControlStateNormal];
            }
        }
        
        [cityScrollView addSubview:cityButton];
    }}
//区域的添加
- (void)addArea{
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
        cityButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);//设置title在button上的位置（上top，左left，下bottom，右right）
        cityButton.titleLabel.numberOfLines = 2;
        cityButton.layer.cornerRadius = cityButton.frame.size.height/2;
        cityButton.layer.masksToBounds = YES;
        cityButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cityButton setTitle:areaArray[i][@"name"] forState:UIControlStateNormal];
        [cityButton addTarget:self action:@selector(choiceAreaButtonItem:) forControlEvents:UIControlEventTouchUpInside];
        
        
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

- (void)addCompany{
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
        cityButton.layer.cornerRadius = cityButton.frame.size.height/2;
        cityButton.layer.masksToBounds = YES;
        [cityButton setTitle:companyArray[i][@"name"] forState:UIControlStateNormal];
        [cityButton addTarget:self action:@selector(choiceCompanyButtonItem:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)choiceCompanyButtonItem:(UIButton*)sender{
    for (NSDictionary *dic in companyArray) {
        NSInteger tagb = [dic[@"id"] integerValue];
        if (sender.tag == tagb) {
            dicInfo = nil;
            dicInfo = [dic copy];
        }
    }
    
    if (sender.selected != YES) {
        sender.selected = YES;
        [selectedCompanyArray removeAllObjects];
        [selectedCompanyArray addObject:dicInfo];

        selectedArray = [selectedCompanyArray mutableCopy];
        
    }else{
        sender.selected = NO;
    }
    [self addCompany];
    
    
    
    [self addSelectedView];
    
}


- (void)addChooseOfbusiness{
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
    sureButton.frame =  AdaptCGRectMake(20, 248, 280, 25);
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    sureButton.backgroundColor = [UIColor whiteColor];
    sureButton.layer.cornerRadius = sureButton.frame.size.height/2;
    sureButton.layer.masksToBounds = YES;
    [sureButton setTitleColor:[UIColor colorWithRed:53/255.0 green:170/255.0 blue:0.0 alpha:1] forState:UIControlStateNormal];
    
    sureButton.tag = 350;
    
    [sureButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [choiceView addSubview:sureButton];
}

//公司选择
- (void)choiceAreaButtonItem:(UIButton *)sender{
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
        
        [selectedAreaArray addObject:dicInfo];
        //    选中就下载数据
        idcode = nil;
        idcode = dicInfo[@"id"];
        [self loadCompanyData];
        
    }else{
        sender.selected = NO;
    }
    [self addArea];
}
//市选择
- (void)choiceCityButtonItem:(UIButton *)sender{
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
        
        [selectedCityArray addObject:dicInfo];
        
        //    选中就下载数据
        idcode = nil;
        idcode = dicInfo[@"id"];
        [self loadAreaData];
        
    }else{
        sender.selected = NO;
    }
    [self addCity];
    for (UIView *view in companyScrollView.subviews) {
        [view removeFromSuperview];
    }
}

- (void)backClick:(UIButton *)sender{
    if (selectedArray.count>0) {
        tabbarVC.tabBar.hidden = YES;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
