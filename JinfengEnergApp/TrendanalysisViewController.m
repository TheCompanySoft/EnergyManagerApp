//
//  ChoseOfAnalysisViewController.m
//  JinfengEnergApp
//
//  Created by HKsoft on 15/12/15.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "TrendanalysisViewController.h"
#import "ChangeWeekView.h"
#import "DateView.h"
#import "EnddateView.h"
#import "AnalysisChooseViewController.h"
@interface TrendanalysisViewController ()<ChangeweekViewdelegate,DateViewdelegate,EnddateViewdelegate,Myprotocol>
{
    NSMutableArray*_weekDataArray;//周期
    NSMutableArray*_weekvalueArray;//周期对应的tag
    NSString*_weektest;//周期tag
    UILabel *_weeklable;//周期按钮上的Label
    UILabel *_startlable;//开始时间label
    UILabel *_endlable;//结束时间label
   
    ChangeWeekView*_changeWeekView;//周期所在View
    DateView*_dateView;//开始日期选择器
    EnddateView*_endView;//结束日期选择器
    AnalysisChooseViewController*_chose;//筛选界面
    UIView *_editTileOpaqueView;//背影
}
@property(nonatomic,strong) UILabel *businesable;//企业名Label
@property(nonatomic,strong) NSString*codeStr;//获取的编码
@property(nonatomic,strong) NSString*nameStr;//获取的企业名

@end

@implementation TrendanalysisViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数组
    _weekDataArray=[NSMutableArray array];
    _weekvalueArray=[NSMutableArray array];
    //弹出日历的背景
    _editTileOpaqueView =[[UIView alloc]initWithFrame:self.view.frame];
    _editTileOpaqueView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.4];
    //手势隐藏视图
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ViewHidden)];
    [self.view addGestureRecognizer:tap];
    //界面背景图
    UIImageView *loginImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"big_background"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    loginImageView.frame = self.view.frame;
    [self.view addSubview:loginImageView];
    //导航栏
    [self setnavigationbar];
    //日期选择器开始
    _dateView=[[DateView alloc]initWithFrame:AdaptCGRectMake(40, 150, 240, 220)];
    _dateView.layer.shadowOffset=CGSizeMake(-3, 0);
    //日期选择器结束
    _dateView.layer.shadowColor=[UIColor redColor].CGColor;
    _endView=[[EnddateView alloc]initWithFrame:AdaptCGRectMake(40, 150, 240, 220)];
}
//设置navigationBar
-(void)setnavigationbar{
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 64)];
    navigationBarView.title_Lable.text = @"筛选";
    [navigationBarView addSubview:navigationBarView.leftButton];
    [navigationBarView.leftButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigationBarView];
    
    //已选企业
    UILabel *placeholdlable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(15, 68,60, 25)];
    placeholdlable.text=@"已选企业";
    placeholdlable.font=[UIFont systemFontOfSize:12];
    placeholdlable.textColor=[UIColor whiteColor];
    [self.view addSubview:placeholdlable];
  
    //已选企业label
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
    //选择部分
    NSArray *titletextArr=@[@"企       业:",@"周       期:",@"开始日期:",@"结束日期:"];
    for (int i=0; i<4; i++) {
        UILabel *arealabel=[[UILabel alloc]initWithFrame:AdaptCGRectMake(15, 185+35*i,60, 30)];
        arealabel.text=titletextArr[i];
        arealabel.font=[UIFont systemFontOfSize:13];
        arealabel.textColor=[UIColor whiteColor];
        arealabel.backgroundColor=[UIColor clearColor];
        [self.view addSubview:arealabel];
    }
//企业选择
    UIButton *areabtn=[UIButton buttonWithType:UIButtonTypeCustom];
    areabtn.frame=AdaptCGRectMake(80,190, 220, 25);
    areabtn.layer.cornerRadius = areabtn.frame.size.height/2;
    areabtn.layer.masksToBounds = YES;
    areabtn.backgroundColor=[UIColor whiteColor];
    [areabtn addTarget:self action:@selector(movetomainchose) forControlEvents:UIControlEventTouchUpInside];
    UILabel *areaable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(20, 0, 160, 25)];
    areaable.text=@"请选择企业";
    areaable.font=[UIFont systemFontOfSize:13];
    areaable.textAlignment=NSTextAlignmentCenter;
    areaable.textColor=[UIColor lightGrayColor];
    [areabtn addSubview:areaable];
    [self.view addSubview:areabtn];
    UIImage *rightarrow=[UIImage imageNamed:@"arrow"];
    UIImageView *areaimage=[[UIImageView alloc]initWithFrame:AdaptCGRectMake(195, 5, 14, 14)];
    [areaimage setImage:rightarrow];
    [areabtn addSubview:areaimage];
   
    //周期选择
    UIButton *weekbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    weekbtn.frame=AdaptCGRectMake(80,190+35, 220, 25);
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
    //开始
    UIButton *startbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    startbtn.frame=AdaptCGRectMake(80,190+35*2, 220, 25);
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
    NSString *diff = [newFormatter stringFromDate:yesterday];
     NSString *difftd = [newFormatter stringFromDate:todayDate];
    _startlable.text=diff;
    _startlable.font=[UIFont systemFontOfSize:13];
    _startlable.textAlignment=NSTextAlignmentCenter;
    _startlable.textColor=[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0 alpha:1];
    [startbtn addSubview:_startlable];
    [self.view addSubview:startbtn];
    [startbtn addSubview:startimage];
    //结束
    UIButton *endbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [endbtn addTarget:self action:@selector(endtime) forControlEvents:UIControlEventTouchUpInside];
    endbtn.frame=AdaptCGRectMake(80,190+35*3, 220, 25);
    endbtn.layer.cornerRadius = endbtn.frame.size.height/2;
    endbtn.layer.masksToBounds = YES;
    endbtn.backgroundColor=[UIColor whiteColor];
    _endlable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(20, 0, 160, 25)];
    
    UIImageView *endimage=[[UIImageView alloc]initWithFrame:AdaptCGRectMake(195, 5, 14, 14)];
    [endimage setImage:calimage];
    _endlable.text=difftd;
    _endlable.font=[UIFont systemFontOfSize:13];
    _endlable.textAlignment=NSTextAlignmentCenter;
    _endlable.textColor=[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0 alpha:1];
    [endbtn addSubview:_endlable];
    [self.view addSubview:endbtn];
    [endbtn addSubview:endimage];
    //底部确定按钮
    UIButton *bottomBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame=AdaptCGRectMake(20, 508, 280, 25);
    [bottomBtn setTitle:@"确定" forState:UIControlStateNormal];
    bottomBtn.layer.cornerRadius = bottomBtn.frame.size.height/2;
    bottomBtn.layer.masksToBounds = YES;
   
    bottomBtn.backgroundColor=[UIColor whiteColor];
    [bottomBtn addTarget:self action:@selector(backClick1) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [bottomBtn setTitleColor:[UIColor colorWithRed:53/255.0 green:170/255.0 blue:0.0 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:bottomBtn];
    
}

//加载数据
-(void)loadDate2{
    NSString *url = [NSString stringWithFormat:@"%@/ReportBaseInfo/GetDateType?",JFENERGYMANAGER_IP];
//2 创建一个请求管理器
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
        //加载数据初始化赋值
        _weeklable.text=_weekDataArray[0];
        _weektest=_weekvalueArray[0];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
    }];
    
}
//进入筛选界面
-(void)movetomainchose{
    if (!_chose) {
        _chose =[[AnalysisChooseViewController alloc]init];
    }
    _chose.delegat=self;
    _chose.modalTransitionStyle=2;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:_chose];
    [self presentViewController:nav animated:YES completion:nil];
    
}
//开始时间
-(void)starttime{

    [_changeWeekView removeFromSuperview];
    _dateView.delegate=self;
    [_editTileOpaqueView addSubview:_dateView];
    [self.view addSubview:_editTileOpaqueView];
    
}
//结束时间
-(void)endtime{
   
    [_changeWeekView removeFromSuperview];
    _endView.delegate=self;
    [_editTileOpaqueView addSubview:_endView];
    [self.view addSubview:_editTileOpaqueView];
}

//手势
-(void)ViewHidden{
    
    [_changeWeekView removeFromSuperview];
}

#pragma mark DateViewdelegate
//日历取消
-(void)cancelBtnDelegate{
    [_editTileOpaqueView removeFromSuperview];
    
}
#pragma mark ChangeweekViewdelegate
-(void)ChangeweekBuuton:(UIButton *)btn{
   
    [_changeWeekView removeFromSuperview];
    [self changeweekView:btn];
}
//取消
-(void)endcancleBtndelegate{
    [_editTileOpaqueView removeFromSuperview];
}
#pragma mark EnddateViewdelegate
-(void)dateView:(NSString *)string{
   
    [_changeWeekView removeFromSuperview];
    _startlable.text=string;
    [_editTileOpaqueView removeFromSuperview];
    
}
#pragma mark DateViewdelegate
-(void)enddateView:(NSString *)string{
   
    [_changeWeekView removeFromSuperview];
    _endlable.text=string;
    [_editTileOpaqueView removeFromSuperview];
}
//能源按钮内部选择方法
-(void)changeweekView:(UIButton *)sender {
    if (_weeklable.text!=nil) {
        _weeklable.text=nil;
    }
    if (_changeWeekView) {
        [_changeWeekView removeFromSuperview];
    }
    
    NSString *strvalue=_weekDataArray[sender.tag];
    
    _weeklable.text=strvalue;
    _weektest=_weekvalueArray[sender.tag];
    
}
-(void)weakChoose{
    
    // [_changeView removeFromSuperview];
    if (!_changeWeekView) {
        _changeWeekView =[[ChangeWeekView alloc]init];
    }
    _changeWeekView.delegate=self;
    
    for (UIView* view in [_changeWeekView subviews]) {
        [view removeFromSuperview];
    }
    _changeWeekView.frame=AdaptCGRectMake(80, 245, 190, 31.5*_weekDataArray.count);
    [_changeWeekView getmoveArray:_weekDataArray];
    [self.view addSubview:_changeWeekView];
}
//确定按钮方法
-(void)backClick1{
    
    if (_codeStr.length>0) {
        NSArray*arr=@[_codeStr,_weektest,_startlable.text,_endlable.text,_nameStr];
        [self.delegat  businessArray:arr];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"还没选择要查看的企业！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView1 show];
    }
    
}
//返回
-(void)backClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark Myprotocol
-(void)businecode:(NSArray*)array{
    NSDictionary*dic=array[0];
    _codeStr=[dic objectForKey:@"id"];
    _nameStr=[dic objectForKey:@"name"];
    _businesable.text=_nameStr;
    [self.view addSubview:_businesable];
    [self loadDate2];
   }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
