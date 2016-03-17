//
//  MenuView.h
//  scrollMenuView
//
//  Created by johnny_wu on 2016/3/9.
//  Copyright © 2016年 johnny_wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "ScrollMenuView.h"

@class MenuView;

//////////////////////////////////////////////////

@protocol MenuViewDelegate <NSObject>

@required
- (void)endScrollingAction:(MenuView *)menu index:(NSInteger)index;

@end


@interface MenuView : UIView<ScrollMenuViewDataSource, ScrollMenuViewDelegate>

@property (nonatomic, assign) id<MenuViewDelegate> delegate;
@property (nonatomic, strong) ScrollMenuView *scrollMenuView;
@property (nonatomic, retain) NSArray *dataArray; // Model
@property (nonatomic, assign) CGFloat viewInPositionY;
@property (nonatomic, assign) CGFloat scrollViewHeight;

- (void)scrollingPostionWithIndex:(NSInteger)index;

@end