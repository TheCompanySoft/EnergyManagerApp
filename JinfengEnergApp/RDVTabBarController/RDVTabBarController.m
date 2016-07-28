// RDVTabBarController.m
// RDVTabBarController
//
// Copyright (c) 2013 Robert Dimitrov
//
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "AnalysisViewController.h"
#import "AreaAnalysisViewController.h"
#import "EnergyAnalysisViewController.h"
#import "ProductAnalysisViewController.h"
#import "HomeViewController.h"
#import "MonitorViewController.h"
#import <objc/runtime.h>

@interface UIViewController (RDVTabBarControllerItemInternal)

- (void)rdv_setTabBarController:(RDVTabBarController *)tabBarController;

@end

@interface RDVTabBarController () {
    UIView *_contentView;
    UIViewController *analysisViewController,*areaAnalysisViewController,*energyAnalysisViewController,*productAnalysisViewController,*homeViewController,*monitorViewController;
}

@property (nonatomic, readwrite) RDVTabBar *tabBar;

@end

@implementation RDVTabBarController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _idChoice = NO;
    [self.view addSubview:[self contentView]];
    [self.view addSubview:[self tabBar]];
    [self addOtherchoice];
    //    找到第三个,重写点击方法
    UIButton *myButton = (UIButton *)[self.view viewWithTag:(11115)];
    //    myButton.backgroundColor = [UIColor redColor];
    [myButton addTarget:self action:@selector(ChoiceOtherView:) forControlEvents:UIControlEventTouchUpInside];
    analysisViewController = [[AnalysisViewController alloc]init];
    areaAnalysisViewController = [[AreaAnalysisViewController alloc]init];
    energyAnalysisViewController = [[EnergyAnalysisViewController alloc]init];
    productAnalysisViewController = [[ProductAnalysisViewController alloc]init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setSelectedIndex:[self selectedIndex]];
    
    [self setTabBarHidden:self.isTabBarHidden animated:NO];
}

- (NSUInteger)supportedInterfaceOrientations {
    UIInterfaceOrientationMask orientationMask = UIInterfaceOrientationMaskAll;
    for (UIViewController *viewController in [self viewControllers]) {
        if (![viewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
            return UIInterfaceOrientationMaskPortrait;
        }
        
        UIInterfaceOrientationMask supportedOrientations = [viewController supportedInterfaceOrientations];
        
        if (orientationMask > supportedOrientations) {
            orientationMask = supportedOrientations;
        }
    }
    
    return orientationMask;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    for (UIViewController *viewCotroller in [self viewControllers]) {
        if (![viewCotroller respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)] ||
            ![viewCotroller shouldAutorotateToInterfaceOrientation:toInterfaceOrientation]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Methods

- (UIViewController *)selectedViewController {
    return [[self viewControllers] objectAtIndex:[self selectedIndex]];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex >= self.viewControllers.count) {
        return;
    }
    _selectedIndex = selectedIndex;
    [[self tabBar] setSelectedItem:[[self tabBar] items][selectedIndex]];
    if(selectedIndex==2){
              return;
    }else{
        _viewisHidden = NO;
        [self.otherChoiceView removeFromSuperview];
    }
#pragma mark ---------终于找到重点了---------
     if ([self selectedViewController]) {
        [[self selectedViewController] willMoveToParentViewController:nil];
        [[[self selectedViewController] view] removeFromSuperview];
        [[self selectedViewController] removeFromParentViewController];
    }
    
    
    [self setSelectedViewController:[[self viewControllers] objectAtIndex:selectedIndex]];
    [self addChildViewController:[self selectedViewController]];
    [[[self selectedViewController] view] setFrame:[[self contentView] bounds]];
    [[self contentView] addSubview:[[self selectedViewController] view]];
    [[self selectedViewController] didMoveToParentViewController:self];

}



- (void)setViewControllers:(NSArray *)viewControllers {
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        _viewControllers = [viewControllers copy];
        
        NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];
        
        for (UIViewController *viewController in viewControllers) {
            RDVTabBarItem *tabBarItem = [[RDVTabBarItem alloc] init];
            //            title赋值给 item
            //            [tabBarItem setTitle:viewController.title];
            [tabBarItems addObject:tabBarItem];
            [viewController rdv_setTabBarController:self];
        }
        
        [[self tabBar] setItems:tabBarItems];
    } else {
        for (UIViewController *viewController in _viewControllers) {
            [viewController rdv_setTabBarController:nil];
        }
        
        _viewControllers = nil;
    }
}

- (NSInteger)indexForViewController:(UIViewController *)viewController {
    UIViewController *searchedController = viewController;
    if ([searchedController navigationController]) {
        searchedController = [searchedController navigationController];
    }
    return [[self viewControllers] indexOfObject:searchedController];
}

#pragma mark ----添加 整个 tabBar
- (RDVTabBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[RDVTabBar alloc] init];
        [_tabBar setBackgroundColor:[UIColor clearColor]];
        [_tabBar setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                      UIViewAutoresizingFlexibleTopMargin|
                                      UIViewAutoresizingFlexibleLeftMargin|
                                      UIViewAutoresizingFlexibleRightMargin|
                                      UIViewAutoresizingFlexibleBottomMargin)];
        [_tabBar setDelegate:self];
    }
    
    return _tabBar;
}

- (void)addOtherchoice{
    self.otherChoiceView = [[UIView alloc]initWithFrame:CGRectMake(180*(SCREEN_WIDTH/320), SCREEN_HEIGHT-160*(SCREEN_WIDTH/320)-45, 100*(SCREEN_WIDTH/320), 160*(SCREEN_WIDTH/320))];
    UIImage *image = [UIImage imageNamed:@"analysis_bg"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:AdaptCGRectMake(0, 0, 100, 160)];
    imageView.image = image;
    [self.otherChoiceView addSubview:imageView];
    self.otherChoiceView.tag = 300;
    NSArray *name = @[@"企业趋势分析",@"区域能耗分析",@"能耗构成分析",@"产品能耗分析"];
    self.buttons =[NSMutableArray array];
    for (int i = 0; i < 4; i ++) {
        UIButton *choiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        choiceButton.frame = AdaptCGRectMake(0, 0 + i * 38, 100, 36);
        [choiceButton setTitle:name[i] forState:UIControlStateNormal];
        choiceButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        choiceButton.tag = i;
        
        [choiceButton addTarget:self action:@selector(choiceAnatherVC:) forControlEvents:UIControlEventTouchUpInside];
        [self.otherChoiceView addSubview:choiceButton];
        [self.buttons addObject:choiceButton];
        if (i < 3) {
            UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"green_heng"]];
            line.frame = AdaptCGRectMake(10, 36, 80, 1);
            [choiceButton addSubview:line];
        }
    }
}

- (void)choiceAnatherVC:(UIButton *)button{
    
    if ([self selectedViewController]) {
        [[self selectedViewController] willMoveToParentViewController:nil];
        [[[self selectedViewController] view] removeFromSuperview];
        [[self selectedViewController] removeFromParentViewController];
    }
    
    [[self selectedViewController] didMoveToParentViewController:self];
    [button setTitleColor:[UIColor colorWithRed:53.0/255 green:170/255.0 blue:0 alpha:1] forState:UIControlStateNormal];
    
    for (UIButton *temp in _buttons) {
        if (temp.tag !=button.tag) {
            temp.selected =NO;
            [temp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    button.selected =YES;
    
    [self.otherChoiceView removeFromSuperview];
    self.viewisHidden = NO;

    _idChoice = YES;
    _selectedIndex = 2;
    [[self tabBar] setSelectedItem:[[self tabBar] items][2]];
    [self setSelectedViewController:[[self viewControllers] objectAtIndex:2]];
    
    switch (button.tag) {
        case 0:
        {
            [self addChildViewController:analysisViewController];
            [[analysisViewController view] setFrame:[[self contentView] bounds]];
            [[self contentView] addSubview:[analysisViewController view]];
        }
            break;
        case 1:
        {
            [self addChildViewController:areaAnalysisViewController];
            [[areaAnalysisViewController view] setFrame:[[self contentView] bounds]];
            [[self contentView] addSubview:[areaAnalysisViewController view]];
        }
            break;
        case 2:
        {
            [self addChildViewController:energyAnalysisViewController];
            [[energyAnalysisViewController view] setFrame:[[self contentView] bounds]];
            [[self contentView] addSubview:[energyAnalysisViewController view]];
        }
            break;
        case 3:
        {
            [self addChildViewController:productAnalysisViewController];
            [[productAnalysisViewController view] setFrame:[[self contentView] bounds]];
            [[self contentView] addSubview:[productAnalysisViewController view]];
        }
            break;
        default:
            break;
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.otherChoiceView removeFromSuperview];
    
}

- (void)ChoiceOtherView:(UIButton*)sender{
    
    if (self.viewisHidden != YES) {
        self.viewisHidden = YES;
        [self.view addSubview:self.otherChoiceView];
    }else{
        self.viewisHidden = NO;
        [self.otherChoiceView removeFromSuperview];
    }
    
}



#pragma mark ----添加内容视图
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor  whiteColor]];
        [_contentView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                           UIViewAutoresizingFlexibleHeight)];
    }
    return _contentView;
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
    _tabBarHidden = hidden;
    
    __weak RDVTabBarController *weakSelf = self;
    
    void (^block)() = ^{
        CGSize viewSize = weakSelf.view.bounds.size;
        CGFloat tabBarStartingY = viewSize.height;
        CGFloat contentViewHeight = viewSize.height;
        CGFloat tabBarHeight = CGRectGetHeight([[weakSelf tabBar] frame]);
        
        if (!tabBarHeight) {
            tabBarHeight = 49;
        }
        
        if (!hidden) {
            tabBarStartingY = viewSize.height - tabBarHeight;
            if (![[weakSelf tabBar] isTranslucent]) {
                contentViewHeight -= ([[weakSelf tabBar] minimumContentHeight] ?: tabBarHeight);
            }
            [[weakSelf tabBar] setHidden:NO];
        }
        
        [[weakSelf tabBar] setFrame:CGRectMake(0, tabBarStartingY, viewSize.width, tabBarHeight)];
        [[weakSelf contentView] setFrame:CGRectMake(0, 0, viewSize.width, contentViewHeight)];
    };
    
    void (^completion)(BOOL) = ^(BOOL finished){
        if (hidden) {
            [[weakSelf tabBar] setHidden:YES];
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:0.24 animations:block completion:completion];
    } else {
        block();
        completion(YES);
    }
}

- (void)setTabBarHidden:(BOOL)hidden {
    [self setTabBarHidden:hidden animated:NO];
}

#pragma mark - RDVTabBarDelegate

- (BOOL)tabBar:(RDVTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index {
    if ([[self delegate] respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        if (![[self delegate] tabBarController:self shouldSelectViewController:[self viewControllers][index]]) {
            return NO;
        }
    }
    
    if ([self selectedViewController] == [self viewControllers][index]) {
        if ([[self selectedViewController] isKindOfClass:[UINavigationController class]]) {
            UINavigationController *selectedController = (UINavigationController *)[self selectedViewController];
            
            if ([selectedController topViewController] != [selectedController viewControllers][0]) {
                [selectedController popToRootViewControllerAnimated:YES];
            }
        }
        
        return NO;
    }
    
    return YES;
}



- (void)tabBar:(RDVTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index {
#pragma mark ----键点击第三个按钮出现,不是消失
    
    if (index < 0 || index >= [[self viewControllers] count]) {
        return;
    }
    
    [self setSelectedIndex:index];
    
    if ([[self delegate] respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
        [[self delegate] tabBarController:self didSelectViewController:[self viewControllers][index]];
    }
    
    
    
    
    
    
}

@end

#pragma mark - UIViewController+RDVTabBarControllerItem

@implementation UIViewController (RDVTabBarControllerItemInternal)

- (void)rdv_setTabBarController:(RDVTabBarController *)tabBarController {
    objc_setAssociatedObject(self, @selector(rdv_tabBarController), tabBarController, OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation UIViewController (RDVTabBarControllerItem)

- (RDVTabBarController *)rdv_tabBarController {
    RDVTabBarController *tabBarController = objc_getAssociatedObject(self, @selector(rdv_tabBarController));
    
    if (!tabBarController && self.parentViewController) {
        tabBarController = [self.parentViewController rdv_tabBarController];
    }
    
    return tabBarController;
}

- (RDVTabBarItem *)rdv_tabBarItem {
    RDVTabBarController *tabBarController = [self rdv_tabBarController];
    NSInteger index = [tabBarController indexForViewController:self];
    return [[[tabBarController tabBar] items] objectAtIndex:index];
}

- (void)rdv_setTabBarItem:(RDVTabBarItem *)tabBarItem {
    RDVTabBarController *tabBarController = [self rdv_tabBarController];
    
    if (!tabBarController) {
        return;
    }
    
    RDVTabBar *tabBar = [tabBarController tabBar];
    NSInteger index = [tabBarController indexForViewController:self];
    
    NSMutableArray *tabBarItems = [[NSMutableArray alloc] initWithArray:[tabBar items]];
    [tabBarItems replaceObjectAtIndex:index withObject:tabBarItem];
    [tabBar setItems:tabBarItems];
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
