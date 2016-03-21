//
//  ViewController.m
//  scrollMenuView
//
//  Created by johnny_wu on 2016/3/9.
//  Copyright © 2016年 johnny_wu. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end


@implementation ViewController





#pragma mark - 
#pragma mark - init & dealloc
//================================================================================
//
//================================================================================
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //////////////////////////////////////////////////
    // 1. (View) 初始化menuView，設置frame大小
    // 目前切圖預設高度為44，Y位置貼齊navgation bar
    CGRect menuViewRect = CGRectMake(0,
                                     200,
                                     [[UIScreen mainScreen] bounds].size.width,
                                     44);
    _menuView = [[MenuView alloc] initWithFrame:menuViewRect];
    
    //////////////////////////////////////////////////
    // 2. aceept protocol
    self.menuView.delegate = self;
    
    //////////////////////////////////////////////////
    // 3. (Model) 填入欲顯示的字串
    self.menuView.dataArray = [NSArray arrayWithObjects:
                               @"全部",
                               @"天天夜市-天天一元搶購",
                               @"飲料甜點",
                               @"主題特色",
                               @"假日可用",
                               @"早午餐",
                               @"午晚餐",
                               @"早晚餐",
                               @"餐餐麥當勞省更多",
                               @"End",
                               nil];
    
    //////////////////////////////////////////////////
    // 4. ********* 必須call一次reloadData，將整個scrollview設置完成  *********
    [self.menuView.scrollMenuView reloadData];
    
    //////////////////////////////////////////////////
    // 5.setting left and right gradient image
    UIImage *leftImage = [UIImage imageNamed:@"shadow_left"];
    UIImage *rightImage = [UIImage imageNamed:@"shadow_right"];
    [self.menuView setLeftRightWithGradientImage:leftImage rightImage:rightImage];
    
    [self.view addSubview:self.menuView];
    
    //////////////////////////////////////////////////
    // 中央錨點，實作時不用加這段
    UIView *arrowView = [[UIView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width / 2,
                                                                 menuViewRect.origin.y + menuViewRect.size.height,
                                                                 1,
                                                                 10)];
    arrowView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:arrowView];
    
    //////////////////////////////////////////////////
    // 移動到指定的index
    [self.menuView scrollingPostionWithIndex:3];
}





#pragma mark - 
#pragma mark - Menu Delegate
//================================================================================
//
//================================================================================
- (void)endScrollingAction:(MenuView *)menu index:(NSInteger)index {
    
    NSLog(@"這裡實作滑動或按下 %ld的動作", (long)index);
}

@end
