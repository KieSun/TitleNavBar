//
//  ViewController.m
//  TitleNavBar
//
//  Created by 俞诚恺 on 15/12/13.
//  Copyright © 2015年 sun. All rights reserved.
//

#import "ViewController.h"
#import "TopLineViewController.h"
#import "HotViewController.h"
#import "VideoViewController.h"
#import "SocietyViewController.h"
#import "ReaderViewController.h"
#import "ScienceViewController.h"

static CGFloat const titleH = 44;
static CGFloat const navBarH = 64;
static CGFloat const maxTitleScale = 1.3;

#define YCKScreenW [UIScreen mainScreen].bounds.size.width
#define YCKScreenH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *titleScrollView;
@property (nonatomic, weak) UIScrollView *contentScrollView;
// 选中按钮
@property (nonatomic, weak) UIButton *selTitleButton;

@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation ViewController

- (NSMutableArray *)buttons
{
    if (!_buttons)
    {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTitleScrollView];
    [self setupContentScrollView];
    [self addChildViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setupTitle];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * YCKScreenW, 0);
        self.contentScrollView.pagingEnabled = YES;
        self.contentScrollView.showsHorizontalScrollIndicator = NO;
        self.contentScrollView.delegate = self;

    });
}

#pragma mark - 设置头部标题栏
- (void)setupTitleScrollView
{
    // 判断是否存在导航控制器来判断y值
    CGFloat y = self.navigationController ? navBarH : 0;
    CGRect rect = CGRectMake(0, y, YCKScreenW, titleH);
    
    UIScrollView *titleScrollView = [[UIScrollView alloc] initWithFrame:rect];
    titleScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleScrollView];
    
    self.titleScrollView = titleScrollView;
}

#pragma mark - 设置内容
- (void)setupContentScrollView
{
    CGFloat y = CGRectGetMaxY(self.titleScrollView.frame);
    CGRect rect = CGRectMake(0, y, YCKScreenW, YCKScreenH - navBarH);
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:rect];
//    contentScrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:contentScrollView];
    
    self.contentScrollView = contentScrollView;
}

#pragma mark - 添加子控制器
- (void)addChildViewController
{
    TopLineViewController *vc = [[TopLineViewController alloc] init];
    vc.title = @"头条";
    [self addChildViewController:vc];
    
    HotViewController *vc1 = [[HotViewController alloc] init];
    vc1.title = @"热点";
    [self addChildViewController:vc1];
    
    VideoViewController *vc2 = [[VideoViewController alloc] init];
    vc2.title = @"视频";
    [self addChildViewController:vc2];
    
    SocietyViewController *vc3 = [[SocietyViewController alloc] init];
    vc3.title = @"社会";
    [self addChildViewController:vc3];
    
    ReaderViewController *vc4 = [[ReaderViewController alloc] init];
    vc4.title = @"订阅";
    [self addChildViewController:vc4];
    
    ScienceViewController *vc5 = [[ScienceViewController alloc] init];
    vc5.title = @"科技";
    [self addChildViewController:vc5];
}

#pragma mark - 设置标题
- (void)setupTitle
{
    NSUInteger count = self.childViewControllers.count;
    
    CGFloat x = 0;
    CGFloat w = 100;
    CGFloat h = titleH;
    
    for (int i = 0; i < count; i++)
    {
        UIViewController *vc = self.childViewControllers[i];
        
        x = i * w;
        CGRect rect = CGRectMake(x, 0, w, h);
        UIButton *btn = [[UIButton alloc] initWithFrame:rect];
        
        btn.tag = i;
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [btn addTarget:self action:@selector(chick:) forControlEvents:UIControlEventTouchDown];
        
        [self.buttons addObject:btn];
        [self.titleScrollView addSubview:btn];
        
        if (i == 0)
        {
            [self chick:btn];
        }
        
    }
    self.titleScrollView.contentSize = CGSizeMake(count * w, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
}

// 按钮点击
- (void)chick:(UIButton *)btn
{
    [self selTitleBtn:btn];
    
    NSUInteger i = btn.tag;
    
    [self setUpOneChildViewController:i];
    
    
}
// 选中按钮
- (void)selTitleBtn:(UIButton *)btn
{
    [self.selTitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.selTitleButton.transform = CGAffineTransformIdentity;
    
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.transform = CGAffineTransformMakeScale(maxTitleScale, maxTitleScale);
    
    self.selTitleButton = btn;
    [self setupTitleCenter:btn];
}

- (void)setUpOneChildViewController:(NSUInteger)i
{
    CGFloat x = i * YCKScreenW;
    
    UIViewController *vc = self.childViewControllers[i];
    
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = CGRectMake(x, 0, YCKScreenW, YCKScreenH - self.contentScrollView.frame.origin.y);
    
    [self.contentScrollView addSubview:vc.view];
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
}

- (void)setupTitleCenter:(UIButton *)btn
{
    CGFloat offset = btn.center.x - YCKScreenW * 0.5;
    
    if (offset < 0)
    {
        offset = 0;
    }
    
    CGFloat maxOffset = self.titleScrollView.contentSize.width - YCKScreenW;
    if (offset > maxOffset)
    {
        offset = maxOffset;
    }
    
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger i = self.contentScrollView.contentOffset.x / YCKScreenW;
    [self selTitleBtn:self.buttons[i]];
    [self setUpOneChildViewController:i];
}

// 只要滚动UIScrollView就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger leftIndex = offsetX / YCKScreenW;
    NSInteger rightIndex = leftIndex + 1;
    
//    NSLog(@"%zd,%zd",leftIndex,rightIndex);

    UIButton *leftButton = self.buttons[leftIndex];
    
    UIButton *rightButton = nil;
    if (rightIndex < self.buttons.count) {
        rightButton = self.buttons[rightIndex];
    }
    
    CGFloat scaleR = offsetX / YCKScreenW - leftIndex;
    
    CGFloat scaleL = 1 - scaleR;
    

    CGFloat transScale = maxTitleScale - 1;
    leftButton.transform = CGAffineTransformMakeScale(scaleL * transScale + 1, scaleL * transScale + 1);
    
    rightButton.transform = CGAffineTransformMakeScale(scaleR * transScale + 1, scaleR * transScale + 1);
    
    
    UIColor *rightColor = [UIColor colorWithRed:scaleR green:0 blue:0 alpha:1];
    UIColor *leftColor = [UIColor colorWithRed:scaleL green:0 blue:0 alpha:1];

    [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
    [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
    
    
}






@end
