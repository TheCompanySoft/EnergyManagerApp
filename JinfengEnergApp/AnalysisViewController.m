//
//  AnalysisViewController.m
//  JinfengEnergApp
//
//  Created by BlackChen on 15/12/8.
//  Copyright © 2015年 BlackChen. All rights reserved.
//

#import "AnalysisViewController.h"
#import "TrendanalysisView.h"
#import "BusinessnalysisCell.h"
#import "TrendanalysisViewController.h"
#import "HeaderchartcolorView.h"
#import "Businesstrendinfo.h"

@interface AnalysisViewController ()
<UITableViewDataSource,UITableViewDelegate,Myprotocol>
{
     UITableView *_tableView;
     MBProgressHUD *_HUD;//提示
      HeaderchartcolorView *_headerView;//曲线视图上方的能源标示
   
    TrendanalysisView *_myView;//数量曲线所在视图
  
    NSMutableArray *_dateArray;//日期数组
    NSMutableArray *_waterArray;//水量
    NSMutableArray*_waterPriceArray;//水价
    NSMutableArray*_heatArray;//热力
    NSMutableArray*_heatPriceArray;//热力价
    NSMutableArray*_electricPowerArray;//电量
    NSMutableArray*_electricPriceArray;//电价
    
    NSMutableArray*_jinwaterPowerArray;//井水量
    NSMutableArray*_jinwaterPriceArray;//井水价
    NSMutableArray*_aerPowerArray;//蒸汽量
    NSMutableArray*_aerPriceArray;//蒸汽价
    NSMutableArray*_businesstrenInfoArray;
    
    NSMutableArray*_allcountArray;//存放所有能源数量数组
     NSMutableArray*_allpriceArray;//存放所有能源价格数组
    NSMutableArray*_allnameArray;//存放能源的名称
    NSMutableArray*_allColors;//存放能源的对应的颜色
    NSString*_watername;//水
    NSString*_electricname;//电
    NSString*_heatname;//热力
    NSString*_jinwatername;//井水
    NSString*_jinwatwrccolor;//井水颜色

    NSString*_watercolor;//水的颜色
    NSString*_electriccolor;//电力的颜色
    NSString*_heatcolor;//热力的颜色
    UILabel *arealabel;//企业名所在Label
    NSString*_aerrname;//企业名
    NSString*_aertriccolor;//蒸汽颜色
    
    NSMutableArray*_waterunitArray;//水单位
    NSMutableArray*_heatunitArray;//热力单位
    NSMutableArray*_jinwaterunitArray;//井水的单位
    NSMutableArray*_electunitArray;//电力单位
    NSMutableArray*_aerunitArray;//蒸汽单位
    NSMutableArray*_allunitcountArray;//存放所有能源单位数组
    
    RDVTabBarController *tabbarVC;
}
@end

@implementation AnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        //加载数据
  //  [self loadDate];
    //数组的初始化
    _aerPowerArray=[NSMutableArray array];
    _aerPriceArray=[NSMutableArray array];
     _aerunitArray=[NSMutableArray array];
    _jinwaterPowerArray=[NSMutableArray array];
    _jinwaterPriceArray=[NSMutableArray array];
    _jinwaterunitArray=[NSMutableArray array];
    _businesstrenInfoArray=[NSMutableArray array];
    _dateArray=[NSMutableArray array];
    _waterArray=[NSMutableArray array];
    _waterPriceArray=[NSMutableArray array];
    _waterunitArray=[NSMutableArray array];
    _heatArray=[NSMutableArray array];
    _heatPriceArray=[NSMutableArray array];
    _heatunitArray=[NSMutableArray array];
    _electunitArray=[NSMutableArray array];
    _electricPowerArray=[NSMutableArray array];
    _electricPriceArray=[NSMutableArray array];   _allcountArray=[NSMutableArray array];
     _allpriceArray=[NSMutableArray array];
    _allnameArray=[NSMutableArray array];
    _allColors=[NSMutableArray array];
    _allunitcountArray=[NSMutableArray array];
    //添加背景视图
    UIImageView *loginImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"big_background"]];
    loginImageView.frame = self.view.frame;
    [self.view addSubview:loginImageView];
//曲线视图上方的能源标示
   _headerView =[[HeaderchartcolorView alloc]initWithFrame:AdaptCGRectMake(0, 68, 320, 18)];
   _myView=[[TrendanalysisView alloc]init];
    [self.view addSubview:_headerView];
    //设定导航栏
    [self asetNavigationBar];
  //能源曲线所在View
     _myView.frame=AdaptCGRectMake(0, 90, 320, 200);
    _myView.backgroundColor=[UIColor colorWithWhite:0.1 alpha:0.2];
    
    [self.view addSubview:_myView];
    
    
    //企业名
   arealabel=[[UILabel alloc]initWithFrame:AdaptCGRectMake(0, 315,320, 25)];
    arealabel.text=@"企业";
    arealabel.textColor=[UIColor whiteColor];
    arealabel.textAlignment=NSTextAlignmentCenter;
    arealabel.backgroundColor=[UIColor colorWithWhite:1 alpha:0.2];
    arealabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:arealabel];
    //表头
    NSArray *arrcanshu=@[@"能源类型",@"数量",@"金额(元)"];
    for (int i=0;i<3; i++) {
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake([UIUtils getWindowWidth]/3*i+0.5*i, 341*[UIUtils getWindowHeight]/568, [UIUtils getWindowWidth]/3-0.6, 25*[UIUtils getWindowHeight]/568)];
       label.text=arrcanshu[i];
        label.textColor=[UIColor whiteColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.backgroundColor=[UIColor colorWithRed:137.0/255 green:196/255.0 blue:115/255.0 alpha:1];
        label.font=[UIFont systemFontOfSize:14];
        [self.view addSubview:label];
    }
    //表
    _tableView =[[UITableView alloc]initWithFrame:AdaptCGRectMake(0, 340+26, 320, 200) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.backgroundColor=[UIColor clearColor];
   _tableView.bounces=NO;
    [self.view addSubview:_tableView];
   
    
    //添加手势
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ViewHidden)];
    [self.view addGestureRecognizer:tap];
   
}

-(void)ViewHidden{

}
////加载数据
-(void)loadDate:(NSArray*)array{
    _HUD=[MBProgressHUD show:MBProgressHUDModeIndeterminate message:@"加载中..." customView:self.view];
    //POST请求
    NSString *url = [NSString stringWithFormat:@"%@/InputEnergyMeasuretool/GetEnergyTrendStatisticsDataForPhone/",JFENERGYMANAGER_IP];

    NSDictionary *parameters=@{@"enterid":array[0],@"datetypeindex":array[1],@"starttime":array[2],@"endtime":array[3]};
    ////2 创建一个请求管理器
    AFHTTPRequestOperationManager *operationManager=[AFHTTPRequestOperationManager manager];
    //3 设置请求可以接受内容的样式
    operationManager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
    // 4 管理器发送POST请求
    [operationManager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str=[responseObject objectForKey:@"chartdata"];
        str=[str stringByReplacingOccurrencesOfString:@"'"withString:@"\""];
        NSError*error;
        SBJSON*sbjson=[[SBJSON alloc]init];
        //用对象解析string
        NSArray*array=[sbjson objectWithString:str error:&error];
       //若数组中有参数将参数移除
        if (array.count>0) {
            if (_businesstrenInfoArray.count>0) {
                [_waterunitArray removeAllObjects];
                [_electunitArray removeAllObjects];
                [_jinwaterunitArray removeAllObjects];
                [_aerunitArray removeAllObjects];
                [_heatunitArray removeAllObjects];
                [_businesstrenInfoArray removeAllObjects];
                [_dateArray removeAllObjects];
                [_waterArray removeAllObjects];
                [_waterPriceArray removeAllObjects];
                [_heatArray removeAllObjects];
                [_heatPriceArray removeAllObjects];
                [_electricPowerArray removeAllObjects];
                [_electricPriceArray removeAllObjects];
                [_aerPriceArray removeAllObjects];
                [_aerPowerArray removeAllObjects];
                [_jinwaterPowerArray removeAllObjects];
                [_jinwaterPriceArray removeAllObjects];
                [_allcountArray removeAllObjects];
                [_allpriceArray removeAllObjects];
                [_allnameArray removeAllObjects];
                [_allColors removeAllObjects];
                [_allunitcountArray removeAllObjects];
                
            }
            //从数组中获取对象
            for (NSDictionary *dic in array) {
                
                Businesstrendinfo *businessStrendinfo=[[Businesstrendinfo alloc]initWithDictionary:dic];
                
                //对象数组
                [_businesstrenInfoArray addObject:businessStrendinfo];
                //水
                if ([businessStrendinfo.energyid isEqualToString:@"100001"]) {
                    //数量
                    if ([businessStrendinfo.varid isEqualToString:@"0"])
                    {
                        //时间
                        [_dateArray addObject:businessStrendinfo.dtsdate];
                        //水量
                        [_waterArray addObject:businessStrendinfo.varvalue];
                        NSString *str=[NSString stringWithFormat:@"%@m³",businessStrendinfo.varvalue];
                        [_waterunitArray addObject:str];
                    }
                    //金额
                    if ([businessStrendinfo.varid isEqualToString:@"1"]) {
                        [_waterPriceArray addObject:businessStrendinfo.varvalue];
                    }
                     NSString *str=[NSString stringWithFormat:@"%@(m³)",businessStrendinfo.energyname];
                    _watername=str;
                    
                    // [热力 0.00%, 蒸汽 0.00%, 电力 99.98%, 水 0.02%, 井水 0.00%]我是名字
                    // [#FF0000 , #FF00FF , #8B008B, #00BFFF, #00FF00 ]我是颜色
                    _watercolor=@"#00BFFF";
                }
                
                //热力
                if ([businessStrendinfo.energyid isEqualToString:@"100023"]){
                    //数量
                    if ([businessStrendinfo.varid isEqualToString:@"0"]) {
                        [_heatArray addObject:businessStrendinfo.varvalue];
                        NSString *str=[NSString stringWithFormat:@"%@GJ",businessStrendinfo.varvalue];
                        [_heatunitArray addObject:str];

                    }
                    //金额
                    if ([businessStrendinfo.varid isEqualToString:@"1"]) {
                        [_heatPriceArray addObject:businessStrendinfo.varvalue];
                        
                    }
                    NSString *str=[NSString stringWithFormat:@"%@(GJ)",businessStrendinfo.energyname];
                    _heatname=str;
                   
                    _heatcolor=@"#FF0000";
                }
                //电力
                if ([businessStrendinfo.energyid isEqualToString:@"100024"]) {
                    //数量
                    if ([businessStrendinfo.varid isEqualToString:@"0"]) {
                        [_electricPowerArray addObject:businessStrendinfo.varvalue];
                        NSString *str=[NSString stringWithFormat:@"%@kWh",businessStrendinfo.varvalue];
                        [_electunitArray addObject:str];

                    }
                    //金额
                    if ([businessStrendinfo.varid isEqualToString:@"1"]) {
                        
                        [_electricPriceArray addObject:businessStrendinfo.varvalue];
                    }
                    NSString *str=[NSString stringWithFormat:@"%@(kWh)",businessStrendinfo.energyname];
                    _electricname=str;

                    _electriccolor=@"#8B008B";
                }
                //井水
                if ([businessStrendinfo.energyid isEqualToString:@"100091"]) {
                    //数量
                    if ([businessStrendinfo.varid isEqualToString:@"0"]) {
                        [_jinwaterPowerArray addObject:businessStrendinfo.varvalue];
                        NSString *str=[NSString stringWithFormat:@"%@m³",businessStrendinfo.varvalue];
                        [_jinwaterunitArray addObject:str];

                    }
                    //金额
                    if ([businessStrendinfo.varid isEqualToString:@"1"]) {
                        
                        [_jinwaterPriceArray addObject:businessStrendinfo.varvalue];
                    }
                    NSString *str=[NSString stringWithFormat:@"%@(m³)",businessStrendinfo.energyname];
                    _jinwatername=str;
                  
                    _jinwatwrccolor=@"#00FF00";
                }
                
                //蒸汽
                if ([businessStrendinfo.energyid isEqualToString:@"100025"]) {
                    //数量
                    if ([businessStrendinfo.varid isEqualToString:@"0"]) {
                        [_aerPowerArray addObject:businessStrendinfo.varvalue];
                        NSString *str=[NSString stringWithFormat:@"%@m³",businessStrendinfo.varvalue];
                        [_aerunitArray addObject:str];

                    }
                    //金额
                    if ([businessStrendinfo.varid isEqualToString:@"1"]) {
                        
                        [_aerPriceArray addObject:businessStrendinfo.varvalue];
                    }
                    NSString *str=[NSString stringWithFormat:@"%@(m³)",businessStrendinfo.energyname];
                    _aerrname=str;
                    _aertriccolor=@"#00FF00";
                }
            }
            //若存在能源水
            if (_watername.length>0) {
                [_allnameArray addObject:_watername];
                [_allColors addObject:_watercolor];
                [_allcountArray addObject:_waterArray];
                [_allpriceArray addObject:_waterPriceArray];
                [_allunitcountArray addObject:_waterunitArray];
            }
            //若存在能源电
            if (_electricname.length>0) {
                [_allnameArray addObject:_electricname];
                [_allColors addObject:_electriccolor];
                [_allcountArray addObject:_electricPowerArray];
                [_allpriceArray addObject:_electricPriceArray];
                [_allunitcountArray addObject:_electunitArray];
            }
            //若存在能源热力
            if (_heatname.length>0) {
                [_allnameArray addObject:_heatname];
                [_allColors addObject:_heatcolor];
                [_allcountArray addObject:_heatArray];
                [_allpriceArray addObject:_heatPriceArray];
                [_allunitcountArray addObject:_electunitArray];
            }
            //若存在能源井水
            if (_jinwatername.length>0) {
                [_allnameArray addObject:_jinwatername];
                [_allColors addObject:_jinwatwrccolor];
                [_allcountArray addObject:_jinwaterPowerArray];
                [_allpriceArray addObject:_jinwaterPriceArray];
                [_allunitcountArray addObject:_jinwaterunitArray];
            }
        //若存在能源蒸汽

            if (_aerrname.length>0) {
                [_allnameArray addObject:_aerrname];
                [_allColors addObject:_aertriccolor];
                [_allcountArray addObject:_aerPowerArray];
                [_allpriceArray addObject:_aerPriceArray];
                [_allunitcountArray addObject:_aerunitArray];
            }
           //能源数量曲线视图调用参数
            [_myView getAllArray:_allcountArray andDate:_dateArray andColors:_allColors];
            //调用名字和颜色
            [_headerView getArray:_allnameArray and:_allColors];
            [_HUD hide:YES afterDelay:0.3f];
            [_tableView reloadData];
        }else{
            UIAlertView*_alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前时间没有数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [_alert show];
             [_HUD hide:YES afterDelay:0.3f];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_HUD hide:YES afterDelay:0.0f];
        [self alertView];
    }];
    
}

//警告
- (void)alertView{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络或连接不到服务器！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

//设定导航栏
- (void)asetNavigationBar
{ AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    tabbarVC = (RDVTabBarController *)delegate.window.rootViewController;

    NavigationBarView *navigationBarView = [[NavigationBarView alloc]initWithFrame:AdaptCGRectMake(0, 0, 320, 64)];
    navigationBarView.title_Lable.text = @"企业趋势分析";
    [navigationBarView addSubview:navigationBarView.navigationBarButton];
    [navigationBarView.navigationBarButton addTarget:self action:@selector(ChooseClicka:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigationBarView];

}
#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allnameArray.count;
}
#pragma mark UITableViewdelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 31.0*[UIUtils getWindowHeight]/568;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*cellid=@"cellid";
    BusinessnalysisCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell=[[BusinessnalysisCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.userInteractionEnabled=NO;
 
    [cell getenergytypeArray:_allnameArray and:_allunitcountArray and:_allpriceArray and:indexPath.row];
    return cell;
}
//调用加载数据方法
-(void)businessArray:(NSArray *)array{
   
    arealabel.text=array[4];
    [self loadDate:array];

}
//进入筛选界面
- (void)ChooseClicka:(UIButton *)sender{
    
    [tabbarVC.otherChoiceView removeFromSuperview];
    tabbarVC.viewisHidden = NO;
    
    TrendanalysisViewController *coseVC=[[TrendanalysisViewController alloc]init];
    coseVC.delegat=self;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:coseVC];
    [self presentViewController:nav animated:YES completion:nil];
    
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
