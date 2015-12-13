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

#define YCKScreenW [UIScreen mainScreen].bounds.size.width
#define YCKScreenH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic, weak) UIScrollView *titleScrollView;
@property (nonatomic, weak) UIScrollView *contentScrollView;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTitleScrollView];
    [self setupContentScrollView];
    [self addChildViewController];
    [self setupTitle];
    
}

#pragma mark - 设置头部标题栏
- (void)setupTitleScrollView
{
    // 判断是否存在导航控制器来判断y值
    CGFloat y = self.navigationController ? navBarH : 0;
    CGRect rect = CGRectMake(0, y, YCKScreenW, titleH);
    
    UIScrollView *titleScrollView = [[UIScrollView alloc] initWithFrame:rect];
    titleScrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:titleScrollView];
    
    self.titleScrollView = titleScrollView;
}

#pragma mark - 设置内容
- (void)setupContentScrollView
{
    CGFloat y = CGRectGetMaxY(self.titleScrollView.frame);
    CGRect rect = CGRectMake(0, y, YCKScreenW, YCKScreenH - navBarH);
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:rect];
    contentScrollView.backgroundColor = [UIColor yellowColor];
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
        
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [self.titleScrollView addSubview:btn];
        
    }
    self.titleScrollView.contentSize = CGSizeMake(count * w, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
}



@end
