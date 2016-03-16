//
//  ScrollMenuView.m
//  scrollMenuView
//
//  Created by johnny_wu on 2016/3/9.
//  Copyright © 2016年 johnny_wu. All rights reserved.
//

#import "ScrollMenuView.h"


@interface ScrollMenuView()

@end


@implementation ScrollMenuView

@dynamic delegate;

const CGFloat paddigSize = 30.0f;

#pragma mark -
#pragma mark - init & dealloc
//================================================================================
//
//================================================================================
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    //////////////////////////////////////////////////
    
    if (self) {
        
        [self initializeSetup];
        //[self reloadData];
    }
    
    return self;
}





#pragma mark - 
#pragma mark - Class Method
//================================================================================
//
//================================================================================
- (void)initializeSetup
{
    self.clipsToBounds = NO;
    self.pagingEnabled = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.autoresizesSubviews = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.multipleTouchEnabled = NO;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    
    //////////////////////////////////////////////////
    
    _arrayOfCell = [NSMutableArray array];
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.tapGesture setNumberOfTapsRequired:1];
    [self.tapGesture setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:self.tapGesture];
}





#pragma mark -
#pragma mark - Instance Method
//================================================================================
//
//================================================================================
- (void)reloadData {
    
    if (!self.delegate || ![self.delegate respondsToSelector:@selector(numberOfPageInScrollMenuView:)]) {
        
        return;
    }
    
    if (!self.dataSource || ![self.dataSource respondsToSelector:@selector(scrollMenuView:viewForRowAtIndex:)]) {
        
        return;
    }
    
    _padding = paddigSize;
    
    _numberOfCell = [self.delegate numberOfPageInScrollMenuView:self];
    
    float startX = 0;
    
    [[self subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    
    for (NSInteger i = 0; i < self.numberOfCell; i++) {
        
        ScrollMenuCell *scrollMenuCell = [[ScrollMenuCell alloc] init];
        
        if ([self.delegate respondsToSelector:@selector(sizeCellForScrollMenuView:index:)]) {
            
            scrollMenuCell.sizeOfCell = [self.delegate sizeCellForScrollMenuView:self index:i];
        }
        
        scrollMenuCell.indexOfCell = i;
        
        //////////////////////////////////////////////////
        
        float topY = (self.frame.size.height - scrollMenuCell.sizeOfCell.height);
        
        UIView *cellView = [self.dataSource scrollMenuView:self viewForRowAtIndex:i];
        cellView.frame = CGRectMake(startX,
                                    topY,
                                    scrollMenuCell.sizeOfCell.width,
                                    scrollMenuCell.sizeOfCell.height);
        [self addSubview:cellView];
        
        //////////////////////////////////////////////////
        
        if (i == 0) {
            // 這邊特別在index = 0時減去寬度的1/2作為left bound是因為初始位置0位於第一個menu cell的中間
            scrollMenuCell.leftBoundPosition = startX - (scrollMenuCell.sizeOfCell.width / 2);
        }
        else {
            
            scrollMenuCell.leftBoundPosition = startX;
        }
        
        startX += scrollMenuCell.sizeOfCell.width;
        scrollMenuCell.rightBoundPosition = startX;
        startX += self.padding;
        
        [self.arrayOfCell addObject:scrollMenuCell];
    }
    
    //////////////////////////////////////////////////
    
    ScrollMenuCell *initMenuCell = [self.arrayOfCell objectAtIndex:0];
    self.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - initMenuCell.sizeOfCell.width) / 2,
                            0,
                            initMenuCell.sizeOfCell.width,
                            44);
    
    CGFloat scrollViewSizeWith = startX - self.padding; // 扣除最後一格無須padding
    self.contentSize = CGSizeMake(scrollViewSizeWith, 1);
}


//================================================================================
// 移動scroll到滑動/拖曳後的位置 (不可使用系統預設的paging效果)
//================================================================================
- (NSInteger)moveToPositionWithEndScrollEvent:(UIScrollView *)scrollView
{
    CGFloat detectedLeftBound = 0;
    CGFloat detectedRightBound = 0;
    ScrollMenuCell *initMenuCell = [self.arrayOfCell objectAtIndex:0];
    CGFloat initPosition = initMenuCell.sizeOfCell.width / 2;
    
    for (NSInteger i = 0; i < self.numberOfCell; i++) {
        
        ScrollMenuCell *currentMenuCell = [self.arrayOfCell objectAtIndex:i];
        detectedLeftBound = currentMenuCell.leftBoundPosition - initPosition - (self.padding / 2);
        detectedRightBound = currentMenuCell.rightBoundPosition - initPosition + (self.padding / 2);
        
        if (scrollView.contentOffset.x > detectedLeftBound && scrollView.contentOffset.x <= detectedRightBound) {
            
            [UIView animateWithDuration:0.3 animations:^{
                // 用右邊界來算比較簡潔，不要用左邊界，會有起始位置的問題
                [self setContentOffset:CGPointMake(detectedRightBound - (self.padding / 2) - (currentMenuCell.sizeOfCell.width / 2) , 0)];
            }];
            return i;
        }
    }
    return 0;
}


//================================================================================
// 以字數來計算該cell需要多少寬度
//================================================================================
- (CGSize)currentSizeOfCellWithString:(NSString *)contentString {
    
    UIFont *font = [UIFont systemFontOfSize:14];
    NSDictionary *textAttributes = @{NSFontAttributeName: font,
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    const CGSize cellTextSize = [contentString sizeWithAttributes:textAttributes];
    return cellTextSize;
}


#pragma mark -
#pragma mark - Gesture Action
//================================================================================
// 判斷是否點擊在menu item內
//================================================================================
- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture
{
    CGPoint tapPoint = [tapGesture locationInView:self];
    
    CGFloat forwardPosition = 0;
    
    //////////////////////////////////////////////////
    
    CGFloat frameHeight = self.frame.size.height;
    
    for (ScrollMenuCell *menuCell in self.arrayOfCell) {
    
        CGFloat topY = (frameHeight - menuCell.sizeOfCell.height) / 2;
        
        BOOL yInCell = NO;
        
        if (tapPoint.y > topY && tapPoint.y < frameHeight - topY) {
            
            yInCell = YES;
        }
        
        //////////////////////////////////////////////////
        
        NSInteger xInCellNumber = 0;
        
        BOOL xInCell = NO;
        
        if (tapPoint.x > menuCell.leftBoundPosition && tapPoint.x < menuCell.rightBoundPosition) {
            
            xInCell = YES;
        }
        
        if (xInCellNumber < 0 || xInCellNumber >= self.numberOfCell) {
            
            xInCell = NO;
        }
        
        //////////////////////////////////////////////////
        
        if (yInCell && xInCell) {
        
            if (menuCell.indexOfCell - 1 < 0) {
                
                forwardPosition = 0;
            }
            else
            {
                ScrollMenuCell *initMenuCell = [self.arrayOfCell objectAtIndex:0];
                ScrollMenuCell *currentMenuCell = [self.arrayOfCell objectAtIndex:menuCell.indexOfCell];
                
                if (menuCell.indexOfCell > 0) {
                    
                    forwardPosition = initMenuCell.sizeOfCell.width / 2 + self.padding * menuCell.indexOfCell + currentMenuCell.sizeOfCell.width / 2;
                    
                    for (NSInteger i = 1; i <= (currentMenuCell.indexOfCell - 1); i++) {
                        
                        ScrollMenuCell *middleMenuCell = [self.arrayOfCell objectAtIndex:i];
                        forwardPosition += middleMenuCell.sizeOfCell.width;
                    }
                }
                else {
                    
                    forwardPosition = 0;
                }
            }
            
            xInCellNumber = menuCell.indexOfCell;
            
            if ([self.delegate respondsToSelector:@selector(scrollMenuView:didTapPageAtIndex:)]) {
                
                [self.delegate scrollMenuView:self didTapPageAtIndex:xInCellNumber];
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                [self setContentOffset:CGPointMake(forwardPosition, 0)];
            }];
            return;
        }
    }
}

@end
