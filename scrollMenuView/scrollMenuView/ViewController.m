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


#define self_Width CGRectGetWidth([UIScreen mainScreen].bounds)
#define self_Height CGRectGetHeight([UIScreen mainScreen].bounds)


#pragma mark - 
#pragma mark - init & dealloc
//================================================================================
//
//================================================================================
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //////////////////////////////////////////////////
    // UISegmentedControl
    NSArray *mySegments = [[NSArray alloc] initWithObjects: @"一般頻道頁", @"品生活", @"熟客卡", nil];
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:mySegments];
    segmentControl.frame = CGRectMake(30,
                                      40,
                                      self.view.frame.size.width - 60,
                                      36);
    [segmentControl setSelectedSegmentIndex:1];
    [segmentControl addTarget:self action:@selector(switchStyle:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentControl];
    
    //////////////////////////////////////////////////
    // 1. (View) 初始化menuView，設置frame大小
    // 目前切圖預設高度為44，Y位置貼齊navgation bar
    CGRect menuViewRect = CGRectMake(0,
                                     80,
                                     [[UIScreen mainScreen] bounds].size.width,
                                     44);
    _menuView = [[MenuView alloc] initWithFrame:menuViewRect andMenuViewType:MenuViewPiinLifeType];
    
    //////////////////////////////////////////////////
    // 2. aceept protocol
    self.menuView.delegate = self;
    
    //////////////////////////////////////////////////
    // 3. (Model) 填入欲顯示的字串
    NSArray *dataArray = [NSArray arrayWithObjects:
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
    [self.menuView prepareDataModelWithArray:dataArray assignIndex:4];
    [self.view addSubview:self.menuView];
    
    //////////////////////////////////////////////////
    // 中央錨點，實作時不用加這段
    UIView *arrowView = [[UIView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width / 2,
                                                                 menuViewRect.origin.y + menuViewRect.size.height,
                                                                 3,
                                                                 10)];
    arrowView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:arrowView];
    
    //////////////////////////////////////////////////
    // 移動到指定的index
    [self.menuView scrollingPostionWithIndex:0];
    
    //////////////////////////////////////////////////
    // 以下是實作下方的slide page
    [self createSlidePageView];
}


//================================================================================
//
//================================================================================
- (void)createSlidePageView {
    
    if (self.mainScrollView) {
        
        [self.mainScrollView removeFromSuperview];
    }
    
    CGFloat begainScrollViewY = self.menuView.frame.origin.y + self.menuView.frame.size.height - 6;
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,
                                                                        begainScrollViewY,
                                                                        self_Width,
                                                                        (self_Height - begainScrollViewY))];
    self.mainScrollView.backgroundColor = [UIColor cyanColor];
    self.mainScrollView.bounces = NO;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.contentSize = CGSizeMake(self_Width * [self.menuView.dataArray count], (self_Height - begainScrollViewY));
    self.mainScrollView.delegate = self;
    
    [self selectPageViewControllerWithIndex:0];
    
    [self.view addSubview:self.mainScrollView];
}


//================================================================================
//
//================================================================================
- (void)selectPageViewControllerWithIndex:(NSInteger)index {
    
    //////////////////////////////////////////////////
    
    //for (NSInteger i = 0; i < [self.menuView.dataArray count]; i++) {
        
        _testViewController = [[TestViewController alloc] init];
        self.testViewController.view.frame = CGRectMake(self_Width * 0,
                                                        0,
                                                        self_Width,
                                                        self_Height);
        self.testViewController.view.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0)
                                                                       green:((float)arc4random_uniform(256) / 255.0)
                                                                        blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
        
        [self.mainScrollView addSubview:self.testViewController.view];
    //}

}





#pragma mark - 
#pragma mark - UISegmentedControl Action
//================================================================================
//
//================================================================================
- (void)switchStyle:(UISegmentedControl *)sender {

    NSInteger selectedIndex = [sender selectedSegmentIndex];
    NSArray *dataDefaultArray = [NSArray arrayWithObjects:
                          @"一般001",
                          @"一般002",
                          @"一般003",
                          @"一般004",
                          @"一般005",
                          @"一般006",
                          @"一般007",
                          @"一般008",
                          @"一般009",
                          nil];
    
    NSArray *dataPiinLifeArray = [NSArray arrayWithObjects:
                          @"品生活001",
                          @"品生活002",
                          @"品生活003",
                          @"品生活004",
                          @"品生活005",
                          @"品生活006",
                          nil];
    
    NSArray *dataRegularsArray = [NSArray arrayWithObjects:
                          @"熟客卡001",
                          @"熟客卡002",
                          @"熟客卡003",
                          @"熟客卡004",
                          @"熟客卡005",
                          @"熟客卡006",
                          @"熟客卡007",
                          nil];
    
    switch (selectedIndex) {
            
        case 0:
            [self.menuView setViewStyleByMenuViewType:MenuViewDefaultType];
            [self.menuView prepareDataModelWithArray:dataDefaultArray assignIndex:0];
            break;
        
        case 1:
            [self.menuView setViewStyleByMenuViewType:MenuViewPiinLifeType];
            [self.menuView prepareDataModelWithArray:dataPiinLifeArray assignIndex:0];
            break;
            
        case 2:
            [self.menuView setViewStyleByMenuViewType:MenuViewRegularsType];
            [self.menuView prepareDataModelWithArray:dataRegularsArray assignIndex:0];
            break;
            
        default:
            break;
    }
    
    for (ScrollMenuCell *scrollMenuCell in self.menuView.dataArray) {
        
        if((scrollMenuCell.cellIndex % 2) == 0) {
            
            scrollMenuCell.cellTextView.hasLevel0ChildToExpand = YES;
        }
    }
    
    [self.menuView setNeedsLayout];
    [self createSlidePageView];
}





#pragma mark -
#pragma mark - MenuView Delegate
//================================================================================
//
//================================================================================
- (void)endScrollingAction:(MenuView *)menu index:(NSInteger)index {
    
    NSLog(@"這裡實作滑動或按下 %ld的動作", (long)index);
    
    [UIView animateWithDuration:.2 animations:^{
        
        [self.mainScrollView setContentOffset:CGPointMake(self_Width * index, 0)];
    }];
}


//================================================================================
//
//================================================================================
- (void)tapTheSameMenuCell:(MenuView *)menu index:(NSInteger)index {
    
}





#pragma mark -
#pragma mark - UIScrollView Delegate
//================================================================================
//
//================================================================================
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger pageIndex = (NSInteger)(scrollView.contentOffset.x / self_Width + 0.5);
    [self.menuView  scrollingPostionWithIndex:pageIndex];
}

@end
