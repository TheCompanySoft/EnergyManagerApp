//
//  AreaAnalysisViewController.m
//  JinfengEnergApp
//
//  Created by BlackChen on 15/12/11.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "AreaAnalysisViewController.h"
#import "AreaChartListCell.h"
#import "AreaEnergyInfo.h"
#import "EnergyconsumptionAnalysisViewController.h"
@interface AreaAnalysisViewController ()<UITableViewDataSource,UITableViewDelegate,Myprotocol>
{
    MBProgressHUD *_HUD;//提示
   
    UITableView *_tableView;//表
    NSMutableArray*_areaEnergyInfoArray;//区域能耗对象数组
    NSMutableArray*_areaArray;//区域数组
    NSMutableArray*_energymoneyArray;//金额数组
    NSMutableArray*_sumamountArray;//数量
     NSMutableArray*_energystandardArray;//标准能耗
        UIScrollView *_myscrollview;//柱状图所在视图
    UIView *bgview;//背景
    UILabel *lable;//显示标头label
  
    RDVTabBarController *tabbarVC;
    }
@property(nonatomic,assign)int max;
@end

@implementation AreaAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //数组初始化
     _areaArray=[NSMutableArray
            array];
    _energymoneyArray=[NSMutableArray
                array];
    _sumamountArray=[NSMutableArray
                       array];
    _energystandardArray=[NSMutableArray
                     array];
    _areaEnergyInfoArray=[NSMutableArray array];
   //添加背景视图
    UIImageView *loginImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"big_background"]];
    loginImageView.frame = self.view.frame;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
    [self.view addSubview:loginImageView];
    self.view.backgroundColor=[UIColor whiteColor];
    //柱状图的表头
    lable=[[UILabel alloc]initWithFrame:AdaptCGRectMake(0, 68, 320, 15)];
    lable.backgroundColor=[UIColor colorWithWhite:1 alpha:0.2];
    lable.text=@"   能耗:   单位：kWh";
    lable.font=[UIFont systemFontOfSize:10];
    lable.textColor=[UIColor whiteColor];
    [self.view addSubview:lable];
    
    bgview=[[UIView alloc]initWithFrame:AdaptCGRectMake(0, 90, 320, 180)];
    bgview.backgroundColor=[UIColor clearColor];
    [self.view addSubview:bgview];
    if (!_myscrollview) {
        _myscrollview=[[UIScrollView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 180)];
    }
    
    _myscrollview.backgroundColor=[UIColor clearColor];
   //表视图的头
    NSArray *arrcanshu=@[@"",@"企业个数",@"能耗(kWh)",@"成本(元)"];
    for (int i=0;i<4; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:AdaptCGRectMake(320.0/4*i+0.5*i, 290+1, 320.0/4-0.6, 25)];
        label.text=arrcanshu[i];
        label.textColor=[UIColor whiteColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.backgroundColor=[UIColor colorWithRed:137.0/255 green:196/255.0 blue:115/255.0 alpha:1];
        label.font=[UIFont systemFontOfSize:14];
        [self.view addSubview:label];
    }
    //表
    if (!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:AdaptCGRectMake(0, 317, 320, 200) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorColor=[UIColor clearColor];
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.bounces=NO;
        [self.view addSubview:_tableView];
    }
    //设置导航栏
    [self bsetNavigationBar];
    
    }

-(void)setchartView:(NSArray*)areaarr and:(NSArray*)valuearr{
    NSArray *arr=areaarr;
    NSArray *arrvalue=valuearr;
    [bgview addSubview:_myscrollview];
    NSNumber* max1=[valuearr valueForKeyPath:@"@max.floatValue"];
    
//    UIView *xlineview=[[UIView alloc]initWithFrame:AdaptCGRectMake(25, 0,0.5, 165)];
//    xlineview.backgroundColor=[UIColor whiteColor];
//    [bgview addSubview:xlineview];
    UIView *ylineview=[[UIView alloc]initWithFrame:AdaptCGRectMake(25, 165, 320, 0.5)];
    ylineview.backgroundColor=[UIColor whiteColor];    [bgview addSubview:ylineview];
    _max=[max1 intValue];
    for (int i=0; i<4; i++) {
        //y轴label
        UILabel * label = [[UILabel alloc] initWithFrame:AdaptCGRectMake(5,i*50,45, 20)];
        label.textColor=[UIColor whiteColor];
        if (_max%4==0) {
           NSString *str=[NSString stringWithFormat:@"%d",_max-_max/3*i];
            label.text=str;
        }else{
            _max=_max/4*4;
         NSString *str=[NSString stringWithFormat:@"%d",_max-_max/3*i];
            label.text=str;
        }
        label.textAlignment=NSTextAlignmentLeft;
        label.font=[UIFont systemFontOfSize:11];
        label.backgroundColor=[UIColor clearColor];
        [bgview addSubview:label];
    }
    for (UIView*view in [_myscrollview subviews]) {
        [view removeFromSuperview];
    }
    for (int i=0; i<areaarr.count; i++) {
     UILabel *ylabel=[[UILabel alloc]initWithFrame:AdaptCGRectMake( 320/2*i, 165, 320/2, 15)];
       NSString *str=[arr objectAtIndex:i];
        ylabel.text=str;
        ylabel.textAlignment=NSTextAlignmentCenter;
        ylabel.font=[UIFont systemFontOfSize:12];
        ylabel.backgroundColor=[UIColor clearColor];
        
        ylabel.textColor=[UIColor whiteColor];
        [_myscrollview addSubview:ylabel];
        
        _myscrollview.contentSize = CGSizeMake(self.view.frame.size.width/2*(i+1), 180);
        UIImage *image=[UIImage imageNamed:@"pillars"];
        
        UIImageView *view=[[UIImageView alloc]initWithFrame:AdaptCGRectMake(320/4+320/2*i-image.size.width/2, 5, image.size.width, image.size.height-5)];
        [view setImage:image];
        _myscrollview.backgroundColor=[UIColor colorWithWhite:0.2 alpha:0.1];
        [_myscrollview addSubview:view];
        
        UIView *corview=[[UIView alloc]initWithFrame:AdaptCGRectMake(0, 0, 14, 14)];
        corview.backgroundColor=[UIColor purpleColor];
        corview.layer.borderColor=[UIColor whiteColor].CGColor;
        corview.layer.borderWidth=1.5;
        corview.layer.cornerRadius=corview.frame.size.width/2;
        corview.center=CGPointMake(corview.center.x,150*[UIUtils getWindowHeight]/568);
        [view addSubview:corview];
        // 移动kkLayer的position
        [UIView animateWithDuration:2 animations:^{
            //平移
            NSString *strvalue=arrvalue[i];
            float value =[strvalue floatValue];
            float value1=(value-0);
            if (_max%4==0) {
                if (_max==0) {
                    _max=1;
                }
                float grade=value1/_max;
                  float value2=grade*138*[UIUtils getWindowHeight]/568;
                
                corview.layer.transform = CATransform3DMakeTranslation(0, -value2, 0);
            }else{
              _max=_max/4*4;
             float grade=value1/_max;
                  double value2=grade*138*[UIUtils getWindowHeight]/568;
                corview.layer.transform = CATransform3DMakeTranslation(0, -value2, 0);
            }
    }];
    }
}
//加载数据
-(void)loadDate:(NSArray*)array{
     _HUD=[MBProgressHUD show:MBProgressHUDModeIndeterminate message:@"加载中..." customView:self.view];
//POST请求
    NSString *url = [NSString stringWithFormat:@"%@/RegionalEnergyconsumptionAnalysis/GetRegionalEnergyconsumptionAnalysisData/",JFENERGYMANAGER_IP];

 NSArray*dataArray=@[@{@"pagetype":@"",@"parameters":array[0],@"starttime":array[1],@"endtime":array[2],@"savetime":@"",@"scopeday":@"",@"scopehours":@""}];
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataArray options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString* str=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{@"energyid":array[4],@"data":str};
    ////2 创建一个请求管理器
    AFHTTPRequestOperationManager *operationManager=[AFHTTPRequestOperationManager manager];
    //3 设置请求可以接受内容的样式
    operationManager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
    // 4 管理器发送POST请求
    [operationManager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSString *str=[responseObject objectForKey:@"griddata"];
        str=[str stringByReplacingOccurrencesOfString:@"'"withString:@"\""];
       
        NSError*error;
        SBJSON*sbjson=[[SBJSON alloc]init];
        //用对象解析string
        NSArray*array=[sbjson objectWithString:str error:&error];
        
        if (array.count>0) {
            if (_areaEnergyInfoArray.count>0) {
                [_areaEnergyInfoArray removeAllObjects];
                [_areaArray removeAllObjects];
                [_sumamountArray removeAllObjects];
                [_energymoneyArray removeAllObjects];
                [_energystandardArray removeAllObjects];
               
            }
                for (NSDictionary *dic in array) {
            AreaEnergyInfo *areaEnergyinfo=[[AreaEnergyInfo alloc]initWithDictionary:dic];
            [_areaEnergyInfoArray addObject:areaEnergyinfo];
//           //区域
            [_areaArray addObject:areaEnergyinfo.regionalname];
            //数量
            [_sumamountArray addObject:areaEnergyinfo.sumamount];
            //money
            [_energymoneyArray addObject:areaEnergyinfo.energymoney];
            [_energystandardArray addObject:areaEnergyinfo.energysumcoalstandard];
                    
           
        }
            
        for (UIView*view in [bgview subviews]) {
                [view removeFromSuperview];
            }
            //柱状图数据
            [self setchartView:_areaArray and:_sumamountArray];
 [_HUD hide:YES afterDelay:0.3f];
        [_tableView reloadData];
            
        }else{
             [_HUD hide:YES afterDelay:0.3f];
            UIAlertView*_alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前时间没有数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [_alert show];
        }
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [_HUD hide:YES afterDelay:0.3f];
            [self alertView];
    }];
}

//警告
- (void)alertView{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络或连接不到服务器！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}
//设定导航栏
- (void)bsetNavigationBar
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    tabbarVC = (RDVTabBarController *)delegate.window.rootViewController;
    
    NavigationBarView *navigationBarView = [[NavigationBarView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 64)];
    [navigationBarView addSubview:navigationBarView.navigationBarButton];
    navigationBarView.title_Lable.text = @"区域能耗分析";
    [navigationBarView.navigationBarButton addTarget:self action:@selector(ChooseClickb:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigationBarView];
   
    //添加手势
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ViewHidden)];
    [self.view addGestureRecognizer:tap];
    
}

-(void)ViewHidden{
    tabbarVC.viewisHidden = NO;
    [tabbarVC.otherChoiceView removeFromSuperview];
}
#pragma mark UITableViewDataSource,UITableViewDelegate,
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
return _areaEnergyInfoArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 31.0*[UIUtils getWindowHeight]/568;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*cellid=@"cellid";
  AreaChartListCell *cell=[tableView dequeueReusableCellWithIdentifier:nil];
    if (!cell) {
        cell=[[AreaChartListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
  
    AreaEnergyInfo *info=_areaEnergyInfoArray[indexPath.row];
    [cell getareaEnrgeyInfo:info];
   
   // [cell getarray:_arr and:indexPath.row and:_arr1.count];
    return cell;
}

//- (void)addTitleAndButtonView{
//    
//    //返回按钮1
//    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setBackgroundImage:[UIImage imageNamed:@"pic1"] forState:UIControlStateNormal];
//    [btn setFrame:AdaptCGRectMake(0, 0, 25,25)];
//    
//    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
//    [btn addTarget : self action : @selector (ChooseClickb:) forControlEvents : UIControlEventTouchUpInside ];
//    self.navigationItem.rightBarButtonItem= backItem;
//    
//}

//跳转筛选界面
- (void)ChooseClickb:(UIButton *)sender{
    [tabbarVC.otherChoiceView removeFromSuperview];
    tabbarVC.viewisHidden = NO;
    
    EnergyconsumptionAnalysisViewController *coseVC=[[EnergyconsumptionAnalysisViewController alloc]init];
    coseVC.delegat=self;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:coseVC];
    [self presentViewController:nav animated:YES completion:nil];
    
    
}
#pragma mark Myprotocol
-(void)areaArray:(NSArray*)array{
   
    NSString*string=[NSString stringWithFormat:@"   能耗:%@   单位：kWh",array[3]];
     lable.text=string;
  
    [self loadDate:array];
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
