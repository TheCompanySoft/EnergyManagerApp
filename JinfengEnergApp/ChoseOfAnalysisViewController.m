//
//  ChoseOfAnalysisViewController4.m
//  JinfengEnergApp
//
//  Created by HKsoft on 15/12/15.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "ChoseOfAnalysisViewController.h"
#import "ChangeValueView.h"
#import "ChangeWeekView.h"
#import "DateView.h"
#import "EnddateView.h"
#import "ProductTestView.h"
#import "AnalysisChooseViewController.h"
@interface ChoseOfAnalysisViewController ()<ChangeValueViewdelegate,ChangeweekViewdelegate,DateViewdelegate,EnddateViewdelegate,ProductTestViewdelegate,Myprotocol>
{
     MBProgressHUD *_HUD;//提示
    //企业按钮以及Label
    UIButton *areabtn;
    UILabel *areaable;
    //标准按钮
    UIButton *_energyabtn;
    //周期label
    UILabel *_weeklable;
    UILabel *_testlable;
    //开始时间Label
    UILabel *_startlable;
    //结束时间Label
    UILabel *_endlable;
    //周期按钮
    UIButton *weekbtn;
//    NSArray *_changearr;
//    NSArray *_changetimearr;//
    ChangeValueView*_changeView;
    //周期View
    ChangeWeekView*_changeWeekView;
    //产品View
    ProductTestView*_productTestView;
    //开始时间View
    DateView*_dateView;
    //结束时间View
    EnddateView*_endView;
    UIView *_editTileOpaqueView;//背影
    //周期数组
    NSMutableArray*_weekDataArray;
    //
    NSMutableArray*_weekvalueArray;
    NSMutableArray*_testdataArray;
    NSMutableArray*_testvalueArray;
    //对应的索引
    NSString*_weektype;
    NSString*_testtype;
    NSString*_producttype;
    //数组id/内容
    NSMutableArray*_productidArray;
    NSMutableArray*_producttextArray;
}
//能源
@property(nonatomic,strong) UILabel *energyable;
//codeid
@property(nonatomic,strong) NSString *codeStr;
//名字
@property(nonatomic,strong) NSString *nameStr;
//已选企业label
@property(nonatomic,strong) UILabel *businesable;
@end

@implementation ChoseOfAnalysisViewController


- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _productidArray=[NSMutableArray array];
    _producttextArray=[NSMutableArray array];
    _weekDataArray=[NSMutableArray array];
    _weekvalueArray=[NSMutableArray array];
    _testdataArray=[NSMutableArray array];
    _testvalueArray=[NSMutableArray array];
    _editTileOpaqueView =[[UIView alloc]initWithFrame:self.view.frame];
    _editTileOpaqueView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.4];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ViewHidden)];
    [self.view addGestureRecognizer:tap];
    UIImageView *loginImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"big_background"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    loginImageView.frame = self.view.frame;
    [self.view addSubview:loginImageView];
    [self setnavigationbar];
    _dateView=[[DateView alloc]initWithFrame:AdaptCGRectMake(40, 150, 240, 220)];
    
    _dateView.layer.shadowColor=[UIColor redColor].CGColor;
    _dateView.layer.shadowOffset=CGSizeMake(-3, -10);
    
    _endView=[[EnddateView alloc]initWithFrame:AdaptCGRectMake(40, 150, 240, 220)];
    
}
//设置navigationBar
-(void)setnavigationbar{
    if (!_changeWeekView) {
        _changeWeekView =[[ChangeWeekView alloc]init];
    }
//    self.title=@"筛选";
//    //设置navigationBar的属性
//    [self.navigationController.navigationBar setTitleTextAttributes:@{
//                                                                      NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]
//                                                                      }];
//    //返回按钮1
//    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setBackgroundImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
//    [btn setFrame:AdaptCGRectMake(0, 0, 10,15)];
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
//    [btn addTarget : self action : @selector (backClick) forControlEvents : UIControlEventTouchUpInside ];
//    self.navigationItem.leftBarButtonItem= backItem;
    NavigationBarView *navigationBarView = [[NavigationBarView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 64)];
    navigationBarView.title_Lable.text = @"筛选";
    [navigationBarView addSubview:navigationBarView.leftButton];
    [navigationBarView.leftButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigationBarView];
    
    UILabel *placeholdlable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(15, 68,60, 25)];
    placeholdlable.text=@"已选企业";
    placeholdlable.font=[UIFont systemFontOfSize:12];
    placeholdlable.textColor=[UIColor whiteColor];
    [self.view addSubview:placeholdlable];
    _businesable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(13, 90,80, 24)];
    _businesable.text=@"";
    _businesable.layer.cornerRadius=12*[UIUtils getWindowHeight]/568;
    _businesable.textAlignment=NSTextAlignmentCenter;
    _businesable.layer.masksToBounds=YES;
    _businesable.font=[UIFont systemFontOfSize:12];
    _businesable.textColor=[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0 alpha:1];
    _businesable.backgroundColor=[UIColor colorWithRed:207.0/255 green:234/255.0 blue:182/255.0 alpha:1];
    //添加视图
    UIView *lineView=[[UIView alloc]initWithFrame:AdaptCGRectMake(0, 180, 320, 1)];
    lineView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:lineView];
    NSArray *titletextArr=@[@"企       业:",@"标       准:",@"产       品:",@"开始日期:",@"结束日期:",@"周       期:",];
    for (int i=0; i<6; i++) {
        UILabel *arealabel=[[UILabel alloc]initWithFrame:AdaptCGRectMake(15, 185+35*i, 60, 40)];
        arealabel.text=titletextArr[i];
        arealabel.font=[UIFont systemFontOfSize:13];
        arealabel.textColor=[UIColor whiteColor];
        [self.view addSubview:arealabel];
    }
//企业按钮
    areabtn=[UIButton buttonWithType:UIButtonTypeCustom];
    areabtn.frame=AdaptCGRectMake(80,190, 220, 25);
    areabtn.layer.cornerRadius = areabtn.frame.size.height/2;
    areabtn.layer.masksToBounds = YES;
    areabtn.backgroundColor=[UIColor whiteColor];
    [areabtn addTarget:self action:@selector(movetomainchose) forControlEvents:UIControlEventTouchUpInside];
    areaable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(20, 0, 160, 25)];
    areaable.text=@"请选择企业";
    areaable.font=[UIFont systemFontOfSize:13];
    areaable.textAlignment=NSTextAlignmentCenter;
    areaable.textColor=[UIColor lightGrayColor];
    [areabtn addSubview:areaable];
    [self.view addSubview:areabtn];
    //按钮右边的图标
    UIImage *rightarrow=[UIImage imageNamed:@"arrow"];
    
    
    UIImageView *areaimage=[[UIImageView alloc]initWithFrame:AdaptCGRectMake(195, 5, 14, 14)];
    [areaimage setImage:rightarrow];
    [areabtn addSubview:areaimage];
    //标准
    _energyabtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _energyabtn.frame=AdaptCGRectMake(80,190+35, 220, 25);
    _energyabtn.layer.cornerRadius = _energyabtn.frame.size.height/2;
    _energyabtn.layer.masksToBounds = YES;
    _energyabtn.backgroundColor=[UIColor whiteColor];
    
    [_energyabtn addTarget:self
                    action:@selector(chooseView) forControlEvents:UIControlEventTouchUpInside];
    _energyable =[[UILabel alloc]initWithFrame:AdaptCGRectMake(20, 0, 160, 25)];
    _energyable.text=@"";
    _energyable.font=[UIFont systemFontOfSize:13];
    _energyable.textAlignment=NSTextAlignmentCenter;
    UIImageView *energyaimage=[[UIImageView alloc]initWithFrame:AdaptCGRectMake(195, 5, 14, 14)];
    [energyaimage setImage:rightarrow];
    [_energyabtn addSubview:energyaimage];
    _energyable.textColor=[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0 alpha:1];
    [_energyabtn addSubview:_energyable];
    [self.view addSubview:_energyabtn];
    //产品
    UIButton *productbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    productbtn.frame=AdaptCGRectMake(80,190+35*2, 220, 25);
    productbtn.layer.cornerRadius = productbtn.frame.size.height/2;
    productbtn.layer.masksToBounds = YES;
    productbtn.backgroundColor=[UIColor whiteColor];
    [productbtn addTarget:self action:@selector(productChoose) forControlEvents:UIControlEventTouchUpInside];
    _testlable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(20, 0, 160, 25)];
    UIImageView *productimage=[[UIImageView alloc]initWithFrame:AdaptCGRectMake(195, 5, 14, 14)];
    [productimage setImage:rightarrow];
    _testlable.text=@"";
    _testlable.font=[UIFont systemFontOfSize:13];
    _testlable.textAlignment=NSTextAlignmentCenter;
    _testlable.textColor=[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0 alpha:1];
    [productbtn addSubview:_testlable];
    
    [productbtn addSubview:productimage];
    [self.view addSubview:productbtn];
    
    
    //周期
    weekbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    weekbtn.frame=AdaptCGRectMake(80,190+35*5, 220, 25);
    weekbtn.layer.cornerRadius = weekbtn.frame.size.height/2;
    weekbtn.layer.masksToBounds = YES;
    weekbtn.backgroundColor=[UIColor whiteColor];
    [weekbtn addTarget:self action:@selector(weakChoose) forControlEvents:UIControlEventTouchUpInside];
    _weeklable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(20, 0, 160, 25)];
    UIImageView *weekimage=[[UIImageView alloc]initWithFrame:AdaptCGRectMake(195, 5, 14, 14)];
    [weekimage setImage:rightarrow];
    _weeklable.text=@"";
    _weeklable.font=[UIFont systemFontOfSize:13];
    _weeklable.textAlignment=NSTextAlignmentCenter;
    _weeklable.textColor=[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0 alpha:1];
    [weekbtn addSubview:_weeklable];
    [self.view addSubview:weekbtn];
    [weekbtn addSubview:weekimage];
    //开始时间
    UIButton *startbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    startbtn.frame=AdaptCGRectMake(80,190+35*3, 220, 25);
    startbtn.layer.cornerRadius = startbtn.frame.size.height/2;
    startbtn.layer.masksToBounds = YES;
    startbtn.backgroundColor=[UIColor whiteColor];
    [startbtn addTarget:self action:@selector(starttime) forControlEvents:UIControlEventTouchUpInside];
       _startlable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(20, 0, 160, 25)];
    UIImage *calimage=[UIImage imageNamed:@"time"];
    UIImageView *startimage=[[UIImageView alloc]initWithFrame:AdaptCGRectMake(195, 5, 14, 14)];
    [startimage setImage:calimage];
    //现在的时间todayDate
    NSDate*todayDate = [NSDate date];
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSDateFormatter*newFormatter = [[NSDateFormatter alloc] init];
    //设置时区
    NSTimeZone*timeZone = [NSTimeZone localTimeZone];
    [newFormatter setTimeZone:timeZone];
    //设置时间显示格式
    [newFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *diff = [newFormatter stringFromDate:todayDate];
     NSString *diffye = [newFormatter stringFromDate:yesterday];
    _startlable.text=diffye;
    _startlable.font=[UIFont systemFontOfSize:13];
    _startlable.textAlignment=NSTextAlignmentCenter;
    _startlable.textColor=[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0 alpha:1];
    [startbtn addSubview:_startlable];
    [self.view addSubview:startbtn];
    [startbtn addSubview:startimage];
    //结束时间
    UIButton *endbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [endbtn addTarget:self action:@selector(endtime) forControlEvents:UIControlEventTouchUpInside];
    endbtn.frame=AdaptCGRectMake(80,190+35*4, 220, 25);
    endbtn.layer.cornerRadius = endbtn.frame.size.height/2;
    endbtn.layer.masksToBounds = YES;
    endbtn.backgroundColor=[UIColor whiteColor];
    _endlable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(20, 0, 160, 25)];
    
    UIImageView *endimage=[[UIImageView alloc]initWithFrame:AdaptCGRectMake(195, 5, 14, 14)];
    [endimage setImage:calimage];
    _endlable.text=diff;
    _endlable.font=[UIFont systemFontOfSize:13];
    _endlable.textAlignment=NSTextAlignmentCenter;
    _endlable.textColor=[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0 alpha:1];
    [endbtn addSubview:_endlable];
    [self.view addSubview:endbtn];
    [endbtn addSubview:endimage];
//底部的确定按钮
    UIButton *bottomBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame=AdaptCGRectMake(20, 508, 280, 25);
    [bottomBtn setTitle:@"确定" forState:UIControlStateNormal];
    bottomBtn.layer.cornerRadius = bottomBtn.frame.size.height/2;
    bottomBtn.layer.masksToBounds = YES;
    bottomBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    bottomBtn.backgroundColor=[UIColor whiteColor];
    [bottomBtn addTarget:self action:@selector(backClick1) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomBtn setTitleColor:[UIColor colorWithRed:53/255.0 green:170/255.0 blue:0.0 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:bottomBtn];
}
//跳到筛选界面二
-(void)movetomainchose{
    AnalysisChooseViewController *chose=[[AnalysisChooseViewController alloc]init];
    chose.modalTransitionStyle=2;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:chose];
    chose.delegat=self;
    [self presentViewController:nav animated:YES completion:nil];
    
}
//开始时间
-(void)starttime{
    [_changeView removeFromSuperview];
    [_changeWeekView removeFromSuperview];
    [_productTestView removeFromSuperview];
    _dateView.delegate=self;
    [_editTileOpaqueView addSubview:_dateView];
    [self.view addSubview:_editTileOpaqueView];
}
//结束时间
-(void)endtime{
    [_changeView removeFromSuperview];
    [_changeWeekView removeFromSuperview];
    [_productTestView removeFromSuperview];
    
    _endView.delegate=self;
    [_editTileOpaqueView addSubview:_endView];
    [self.view addSubview:_editTileOpaqueView];
}
//手势
-(void)ViewHidden{
    [_changeView removeFromSuperview];
    [_changeWeekView removeFromSuperview];
    [_productTestView removeFromSuperview];
}
//daili
-(void)ChangeValueBuuton:(UIButton*)btn{
    [_changeView removeFromSuperview];
    [_changeWeekView removeFromSuperview];
    [_productTestView removeFromSuperview];
    [self changeView:btn];
    
}
//日历取消
-(void)cancelBtnDelegate{
    
    [_editTileOpaqueView removeFromSuperview];
    
}
//daili
-(void)ChangeweekBuuton:(UIButton *)btn{
    [_changeView removeFromSuperview];
    [_changeWeekView removeFromSuperview];
    [_productTestView removeFromSuperview];
    [self changeweekView:btn];
}
-(void)endcancleBtndelegate{
    [_editTileOpaqueView removeFromSuperview];
}
//daili
-(void)dateView:(NSString *)string{
    [_changeView removeFromSuperview];
    [_changeWeekView removeFromSuperview];
    [_productTestView removeFromSuperview];
    _startlable.text=string;
    
    [_editTileOpaqueView removeFromSuperview];
}

//结束
-(void)enddateView:(NSString *)string{
    [_changeView removeFromSuperview];
    [_changeWeekView removeFromSuperview];
    [_productTestView removeFromSuperview];
    _endlable.text=string;
    [_editTileOpaqueView removeFromSuperview];
}
//能源按钮内部选择方法
-(void)changeView:(UIButton *)sender {
    if (_energyable.text!=nil) {
        _energyable.text=nil;
    }
    if (_changeView) {
        [_changeView removeFromSuperview];
    }
    [_productTestView removeFromSuperview];
    
    
    NSString *strvalue=_testdataArray[sender.tag];
    _energyable.text=strvalue;
    
}
//标准
-(void)chooseView{
    [_changeWeekView removeFromSuperview];
    [_productTestView removeFromSuperview];
    if (!_changeView) {
        _changeView =[[ChangeValueView alloc]init];
    }
    
    _changeView.delegate=self;
    
    for (UIView* view in [_changeView subviews]) {
        [view removeFromSuperview];
    }
    _changeView.frame=AdaptCGRectMake(80, 247, 190, 32*_testdataArray.count);
    
    [_changeView getmoveArray:_testdataArray];
    [self.view addSubview:_changeView];
    
}
////加载数据
-(void)loadDate2{
    NSString *url = [NSString stringWithFormat:@"%@/ReportBaseInfo/GetNXZXDateTypeForStandard",JFENERGYMANAGER_IP];

     _HUD=[MBProgressHUD show:MBProgressHUDModeIndeterminate message:@"加载中..." customView:self.view];
    ////2 创建一个请求管理器
    AFHTTPRequestOperationManager *operationManager=[AFHTTPRequestOperationManager manager];
    //3 设置请求可以接受内容的样式
    operationManager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
    // 4 管理器发送POST请求
    [operationManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (_weekDataArray.count>0) {
            [_weekDataArray removeAllObjects];
            [_weekvalueArray removeAllObjects];
        }
        for (NSDictionary *dic in responseObject) {
            
            [_weekDataArray addObject:[dic objectForKey:@"Text"]];
            [_weekvalueArray addObject:[dic objectForKey:@"Value"]];
        }
        _weeklable.text=_weekDataArray[0];
        _weektype=_weekvalueArray[0];
         [_HUD hide:YES afterDelay:0.3f];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [_HUD hide:YES afterDelay:0.3f];
       
    }];
    
}
//加载数据
-(void)loadDate:(NSString*)ate{
    NSString *url = [NSString stringWithFormat:@"%@/ReportBaseInfo/GetEnergyInfobyInOuttypeByAnalysis?inouttype=1&subjecttype=0&isaAdTotalEnergy=1&isgetenerid=2&enterids=%@",JFENERGYMANAGER_IP,ate];

    ////2 创建一个请求管理器
    AFHTTPRequestOperationManager *operationManager=[AFHTTPRequestOperationManager manager];
    //3 设置请求可以接受内容的样式
    operationManager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
    // 4 管理器发送POST请求
    [operationManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (_productidArray.count>0) {
            [_productidArray removeAllObjects];
            [_producttextArray removeAllObjects];
        }
        for (NSDictionary *dic in responseObject) {
            
            [_productidArray addObject:[dic objectForKey:@"id"]];
            [_producttextArray addObject:[dic objectForKey:@"text"]];
            
        }
        _testlable.text=_producttextArray[0];
        _producttype=_productidArray[0];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
//选择方式一样。2为get请求：“”。XXXXX为选择企业时候联动获得。3标准类型的接口“/NxzxProductsConsumecontrastStandard/SearchAllEnergyStandardList”。4周期的接口：“http://localhost:1572/ReportBaseInfo/GetNXZXDateTypeForStandard”

////加载数据
-(void)loadDate3{
    NSString *urltmp = [NSString stringWithFormat:@"%@/NxzxProductsConsumecontrastStandard/SearchAllEnergyStandardList",JFENERGYMANAGER_IP];

    NSURL *url=[NSURL URLWithString:urltmp];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        requestTmp=[requestTmp stringByReplacingOccurrencesOfString:@"'"withString:@"\""];
        NSError *error;
        SBJSON *sbjson=[[SBJSON alloc]init];
        //用对象解析string
        NSArray *array = [sbjson objectWithString:requestTmp error:&error];
        if (_testvalueArray.count>0) {
            [_testvalueArray removeAllObjects];
            [_testdataArray removeAllObjects];
        }
        for (NSDictionary *dic in array) {
            [_testvalueArray addObject:[dic objectForKey:@"id"]];
            [_testdataArray addObject:[dic objectForKey:@"text"]];
        }
        _energyable.text=_testdataArray[0];
        _testtype=_testvalueArray[0];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    [operation start];
}
//能源按钮内部选择方法
-(void)changeweekView:(UIButton *)sender {
    [_productTestView removeFromSuperview];
    if (_weeklable.text!=nil) {
        _weeklable.text=nil;
    }
    if (_changeWeekView) {
        [_changeWeekView removeFromSuperview];
    }
    
    NSString *strvalue=_weekDataArray[sender.tag];
    
    _weeklable.text=strvalue;
    _weektype=_weekvalueArray[sender.tag];
    
    
}
//设置按钮点击方法
-(void)ProductTestViewBuuton:(UIButton*)btn;
{
    
    if (_productTestView) {
        [_productTestView removeFromSuperview];
    }
    
    NSString *strvalue=_producttextArray[btn.tag];
    
    _testlable.text=strvalue;
}
//标准视图
-(void)productChoose{
    [_changeView removeFromSuperview];
    [_changeWeekView removeFromSuperview];
    if (!_productTestView) {
        _productTestView =[[ProductTestView alloc]init];
    }
    _productTestView.delegate=self;
    
    for (UIView* view in [_productTestView subviews]) {
        [view removeFromSuperview];
    }
    _productTestView.frame=AdaptCGRectMake(80, 283, 190, 32*_producttextArray.count);
    [_productTestView getmoveArray:_producttextArray];
    [self.view addSubview:_productTestView];
    
}
//标准的选择
-(void)weakChoose{
    [_changeView removeFromSuperview];
    [_productTestView removeFromSuperview];
    if (!_changeWeekView) {
        _changeWeekView =[[ChangeWeekView alloc]init];
    }
    _changeWeekView.delegate=self;
    
    for (UIView* view in [_changeWeekView subviews]) {
        [view removeFromSuperview];
    }
    _changeWeekView.frame=AdaptCGRectMake(80,190+32*6, 190, _weekvalueArray.count*32);
    
    [_changeWeekView getmoveArray:_weekDataArray];
    
    [self.view addSubview:_changeWeekView];
}
//返回
-(void)backClick{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//通过确定传值返回
-(void)backClick1{
    if (_codeStr.length>0) {
        
        [self loadDate:_codeStr];
        
        NSString*st=[NSString stringWithFormat:@"x_%@",_codeStr];
        
        NSString*strall=[NSString stringWithFormat:@"%@;%@;%@;%@",st,_producttype,_testtype,_weektype];
        
        NSArray*arr=@[_startlable.text,_endlable.text,strall,_nameStr];
        [self.delegat  productArray:arr];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"还没选择要查看的企业！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView1 show];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//获取筛选界面二传过来的企业数据
-(void)businecode:(NSArray *)array{
    
    [self loadDate2];
    [self loadDate3];
    NSDictionary*dic=array[0];
    
    _nameStr=[dic objectForKey:@"name"];
    _codeStr=[dic objectForKey:@"id"];
    _businesable.text=_nameStr;
    [self.view addSubview:_businesable];
    [self loadDate:_codeStr];
    
}

@end
