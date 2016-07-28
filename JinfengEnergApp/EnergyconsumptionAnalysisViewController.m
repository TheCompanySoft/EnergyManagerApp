//
//  ChoseOfAnalysisViewController2.m
//  JinfengEnergApp
//
//  Created by HKsoft on 15/12/15.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "EnergyconsumptionAnalysisViewController.h"
#import "ChangeValueView.h"
#import "ChooseOfEnergyViewController.h"
#import "DateView.h"
#import "EnddateView.h"
@interface EnergyconsumptionAnalysisViewController ()<ChangeValueViewdelegate,DateViewdelegate,EnddateViewdelegate,Myprotocol>
{
    NSMutableArray*_energyDataArray;//能源数组
    NSMutableArray*_energytypeArray;//能源对应的tag数组
    NSString*_energyText;//添加在能源按钮上的label
    UIButton *_energyabtn;//能源按钮
    UILabel *_startlable;//开始时间上的label
    UILabel *_endlable;//结束时间按钮上的label
     MBProgressHUD *_HUD;//提示
    ChangeValueView*_changeView;//弹出视图
    
    DateView*_dateView;//开始时间选择器
    EnddateView*_endView;//结束时间选择器
    UIView *_editTileOpaqueView;//背影
}
@property(nonatomic,strong) UILabel *businesable;//企业label
@property(nonatomic,strong) UILabel *energyable;//能源label
@property(nonatomic,strong) NSString *codeStr;//获取的编码
@property(nonatomic,strong) NSMutableArray *nameArr;//
@property(nonatomic,strong) NSMutableArray *codearray;
@end

@implementation EnergyconsumptionAnalysisViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //数组初始化
    _energytypeArray=[NSMutableArray array];
    _energyDataArray=[NSMutableArray array];
    _nameArr=[NSMutableArray array];
    _codearray=[NSMutableArray array];
    //设置导航栏
   
    //日期选择器的背景
    _editTileOpaqueView =[[UIView alloc]initWithFrame:self.view.frame];
    _editTileOpaqueView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.4];
    //添加手势
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
    
    //添加视图
    UIView *lineView=[[UIView alloc]initWithFrame:AdaptCGRectMake(0, 180, 320, 1)];
    lineView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:lineView];
    NSArray *titletextArr=@[@"企       业:",@"能       源:",@"开始日期:",@"结束日期:"];
    for (int i=0; i<4; i++) {
        UILabel *arealabel=[[UILabel alloc]initWithFrame:AdaptCGRectMake(15, 185+35*i, 60, 40)];
        arealabel.text=titletextArr[i];
        arealabel.font=[UIFont systemFontOfSize:13];
        arealabel.textColor=[UIColor whiteColor];
        [self.view addSubview:arealabel];
    }
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
    //
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
    //
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
    NSString *diff = [newFormatter stringFromDate:todayDate];
     NSString *diffye = [newFormatter stringFromDate:yesterday];
    _startlable.text=diffye;
    _startlable.font=[UIFont systemFontOfSize:13];
    _startlable.textAlignment=NSTextAlignmentCenter;
    _startlable.textColor=[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0 alpha:1];
    [startbtn addSubview:_startlable];
    [self.view addSubview:startbtn];
    [startbtn addSubview:startimage];
    //
    UIButton *endbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [endbtn addTarget:self action:@selector(endtime) forControlEvents:UIControlEventTouchUpInside];
    endbtn.frame=AdaptCGRectMake(80,190+35*3, 220, 25);
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
////加载数据
-(void)loadDate3{
     _HUD=[MBProgressHUD show:MBProgressHUDModeIndeterminate message:@"加载中..." customView:self.view];
    NSString *url = [NSString stringWithFormat:@"%@/ReportBaseInfo/GetEnergyInfobyInOuttype?inouttype=0&isaAdTotalEnergy=0",JFENERGYMANAGER_IP];

    ////2 创建一个请求管理器
    AFHTTPRequestOperationManager *operationManager=[AFHTTPRequestOperationManager manager];
    //3 设置请求可以接受内容的样式
    operationManager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
    // 4 管理器发送POST请求
    [operationManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (_energyDataArray.count>0) {
            [_energyDataArray removeAllObjects];
            [_energytypeArray removeAllObjects];
        }
        
        for (NSDictionary *dic in responseObject) {
            [_energyDataArray addObject:[dic objectForKey:@"text"]];
            [_energytypeArray addObject:[dic objectForKey:@"id"]];
        }
        _energyable.text=_energyDataArray[0];
        _energyText=_energytypeArray[0];
        [_HUD hide:YES afterDelay:0.3f];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_HUD hide:YES afterDelay:0.3f];
    }];
    
}
//开始时间
-(void)starttime{
    [_changeView removeFromSuperview];
    
    _dateView.delegate=self;
    [_editTileOpaqueView addSubview:_dateView];
    [self.view addSubview:_editTileOpaqueView];
    
}
//跳转到选择界面
-(void)movetomainchose{
    ChooseOfEnergyViewController*chose=[[ChooseOfEnergyViewController alloc]init];
    chose.delegat=self;
    chose.modalTransitionStyle=2;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:chose];
    [self presentViewController:nav animated:YES completion:nil];
    
}
//结束时间
-(void)endtime{
    [_changeView removeFromSuperview];
    _endView.delegate=self;
    [_editTileOpaqueView addSubview:_endView];
    [self.view addSubview:_editTileOpaqueView];
}
//日历取消
-(void)cancelBtnDelegate{
    [_editTileOpaqueView removeFromSuperview];
}
//手势
-(void)ViewHidden{
    [_changeView removeFromSuperview];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RDVTabBarController *tabbarVC;
    tabbarVC = (RDVTabBarController *)delegate.window.rootViewController;
    tabbarVC.viewisHidden = NO;
    [tabbarVC.otherChoiceView removeFromSuperview];
}
//取消
-(void)endcancleBtndelegate{
    [_editTileOpaqueView removeFromSuperview];
}

//参数改变
-(void)ChangeValueBuuton:(UIButton*)btn{
    [_changeView removeFromSuperview];
    [self changeView:btn];
    
}

//开始日期代理
-(void)dateView:(NSString *)string{
    [_changeView removeFromSuperview];
    
    _startlable.text=string;
    [_editTileOpaqueView removeFromSuperview];
    
}
//结束日期代理
-(void)enddateView:(NSString *)string{
    [_changeView removeFromSuperview];
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
    
    [_changeView getmoveArray:_energyDataArray];
    NSString *strvalue=_energyDataArray[sender.tag];
    _energyable.text=strvalue;
    _energyText=_energytypeArray[sender.tag];
    
}
//选择参数Veiw
-(void)chooseView{
    if (!_changeView) {
        _changeView =[[ChangeValueView alloc]init];
    }
    _changeView.delegate=self;
    for (UIView* view in [_changeView subviews]) {
        [view removeFromSuperview];
    }
    _changeView.frame=AdaptCGRectMake(80, 247, 190,_energyDataArray.count*33);
    [_changeView getmoveArray:_energyDataArray];
    [self.view addSubview:_changeView];
    
}
//确定
-(void)backClick1{
   
    if (_codeStr.length>0 ) {
       
        NSArray*arr=@[_codeStr,_startlable.text,_endlable.text,_energyable.text,_energyText];
        [self.delegat  areaArray:arr];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Mark Myprotocol
-(void)businecode:(NSArray *)array{
     [self loadDate3];
    if (_nameArr.count>0) {
        [_nameArr removeAllObjects];
        [_codearray removeAllObjects];
    }
    if (array.count==1) {
        NSDictionary*dic=array[0];
        NSString*odeStr=[dic objectForKey:@"id"];
        NSString*string=[dic objectForKey:@"type"];
        [self loadDate:odeStr and:string];
        [_nameArr addObject:[dic objectForKey:@"name"]];
        
        [self.view addSubview:_businesable];
    }else{
       
        for (NSDictionary*dic in array) {
            [_nameArr addObject:[dic objectForKey:@"name"]];
            NSString*codeStr=[NSString stringWithFormat:@"x_%@",[dic objectForKey:@"id"]];
             [_codearray addObject:codeStr];
        }
         _codeStr=[_codearray componentsJoinedByString:@","];
        
    }
#pragma mark ------九宫格
     int count=0;
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
            
            _businesable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(13 + j * 106, 90 + i * (24+6), 80, 24)];
            _businesable.text=_nameArr[count];
            _businesable.layer.cornerRadius=12.5*[UIUtils getWindowHeight]/568;
            _businesable.textAlignment=NSTextAlignmentCenter;
            _businesable.layer.masksToBounds=YES;
            _businesable.font=[UIFont systemFontOfSize:12];
            _businesable.textColor=[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0 alpha:1];
            _businesable.backgroundColor=[UIColor colorWithRed:207.0/255 green:234/255.0 blue:182/255.0 alpha:1];
            [self.view addSubview:_businesable];
            count++;
        }
    }
    
   
}
//加载数据
-(void)loadDate:(NSString*)str and:(NSString*)type{

    //POST请求
    NSString *url = [NSString stringWithFormat:@"%@/ReportBaseInfo/GetEnteridByType",JFENERGYMANAGER_IP];

    NSDictionary*dic1=@{@"typeid":type,@"selectid":str};
    
    ////2 创建一个请求管理器
    AFHTTPRequestOperationManager *operationManager=[AFHTTPRequestOperationManager manager];
    //3 设置请求可以接受内容的样式
    operationManager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
    operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 4 管理器发送POST请求
    [operationManager POST:url parameters:dic1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
       
        _codeStr=string;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
    }];
  
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
