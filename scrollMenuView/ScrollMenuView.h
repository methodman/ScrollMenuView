//
//  ScrollMenuView.h
//  scrollMenuView
//
//  Created by johnny_wu on 2016/3/9.
//  Copyright © 2016年 johnny_wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "ScrollMenuCell.h"

@class ScrollMenuView;

//////////////////////////////////////////////////

@protocol ScrollMenuViewDelegate <UIScrollViewDelegate>

@required
- (NSInteger)numberOfPageInScrollMenuView:(ScrollMenuView *)scrollMenuView;

@optional
- (CGSize)sizeCellForScrollMenuView:(ScrollMenuView *)scrollMenuView index:(NSInteger)index;
- (void)scrollMenuView:(ScrollMenuView *)scrollMenuView didTapPageAtIndex:(NSInteger)index;

@end

//////////////////////////////////////////////////

@protocol ScrollMenuViewDataSource <UIScrollViewDelegate>

@required
- (UIView *)scrollMenuView:(ScrollMenuView *)scrollMenuView viewForRowAtIndex:(NSInteger)index;

@end

//////////////////////////////////////////////////

@interface ScrollMenuView : UIScrollView

@property (nonatomic, assign) id<ScrollMenuViewDataSource> dataSource;
@property (nonatomic, assign) id<ScrollMenuViewDelegate> delegate;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, retain) NSMutableArray *arrayOfCell;
@property (nonatomic, assign) NSInteger numberOfCell;
@property (nonatomic, assign) CGFloat padding;

- (void)reloadData;
- (NSInteger)moveToPositionWithEndScrollEvent:(UIScrollView *)scrollView;
- (CGSize)currentSizeOfCellWithString:(NSString *)contentString;
- (void)goToPositionWithIndex:(NSInteger)index;

@end
