//
//  ScrollMenuCell.h
//  scrollMenuView
//
//  Created by johnny_wu on 2016/3/11.
//  Copyright © 2016年 johnny_wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ScrollMenuCell : NSObject

@property (nonatomic, assign) CGSize sizeOfCell;
@property (nonatomic, assign) NSInteger indexOfCell;
@property (nonatomic, assign) CGFloat leftBoundPosition;
@property (nonatomic, assign) CGFloat rightBoundPosition;

@end
