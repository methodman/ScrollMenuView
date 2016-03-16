//
//  MenuView.m
//  scrollMenuView
//
//  Created by johnny_wu on 2016/3/9.
//  Copyright © 2016年 johnny_wu. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView





#pragma mark - 
#pragma mark - init & dealloc
//================================================================================
//
//================================================================================
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    //////////////////////////////////////////////////
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        _scrollMenuView = [[ScrollMenuView alloc] init];
        self.scrollMenuView.dataSource = self;
        self.scrollMenuView.delegate = self;
        self.scrollMenuView.frame = self.frame;
        self.viewInPositionY = self.scrollMenuView.frame.origin.y;
        self.scrollViewHeight = self.frame.size.height;
        [self addSubview:self.scrollMenuView];
        
    }
    
    return self;
}





#pragma mark -
#pragma mark - Override Method
//================================================================================
//
//================================================================================
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    point.y += self.viewInPositionY;
    
    if (CGRectContainsPoint(self.frame, point)) {
        
        return self.scrollMenuView;
    }
    
    UIView *returnView = [super hitTest:point withEvent:event];
    return returnView;
}





#pragma mark -
#pragma mark - ScrollMenuView DataSource
//================================================================================
//
//================================================================================
- (UIView *)scrollMenuView:(ScrollMenuView *)scrollMenuView viewForRowAtIndex:(NSInteger)index {
    
    NSString *contentString = [self.dataArray objectAtIndex:index];
    CGSize cellTextSize = [scrollMenuView currentSizeOfCellWithString:contentString];
    
    //////////////////////////////////////////////////
    
    UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            cellTextSize.width,
                                                            self.scrollViewHeight)];
    cell.backgroundColor = [UIColor clearColor];
    UILabel *celllabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   cellTextSize.width,
                                                                   self.scrollViewHeight)];
    celllabel.textAlignment = NSTextAlignmentCenter;
    celllabel.text = [self.dataArray objectAtIndex:index];
    celllabel.textColor = [UIColor colorWithRed: 199/255.0f green: 0/255.0f blue: 0/255.0f alpha:1.0f];
    [celllabel setFont:[UIFont systemFontOfSize:14]];
    [cell addSubview:celllabel];
    
    return cell;
}




#pragma mark -
#pragma mark - ScrollMenuView Delegate
//================================================================================
//
//================================================================================
- (NSInteger)numberOfPageInScrollMenuView:(ScrollMenuView *)scrollMenuView {
    
    NSInteger itemCount = [self.dataArray count];
    return itemCount;
}


//================================================================================
//
//================================================================================
- (CGSize)sizeCellForScrollMenuView:(ScrollMenuView *)scrollMenuView index:(NSInteger)index {
    
    NSString *contentString = [self.dataArray objectAtIndex:index];
    CGSize sizeOfCell = [scrollMenuView currentSizeOfCellWithString:contentString];
    sizeOfCell = CGSizeMake(sizeOfCell.width, self.scrollMenuView.frame.size.height);
    
    return sizeOfCell;
}

//================================================================================
// 點擊某個item後的事件
//================================================================================
- (void)scrollMenuView:(ScrollMenuView *)scrollMenuView didTapPageAtIndex:(NSInteger)index {
    
    NSLog(@"click cell at %ld",index);
    
    if ([self.delegate respondsToSelector:@selector(endScrollingAction:index:)]) {
        
        [self.delegate endScrollingAction:self index:index];
    }
}





#pragma mark -
#pragma mark - Override ScrollView Method
//================================================================================
// 處理滑動後的事件
//================================================================================
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = [self.scrollMenuView moveToPositionWithEndScrollEvent:scrollView];
    
    if ([self.delegate respondsToSelector:@selector(endScrollingAction:index:)]) {
        
        [self.delegate endScrollingAction:self index:index];
    }
}


//================================================================================
// 處理拖曳後的事件
//================================================================================
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSInteger index = [self.scrollMenuView moveToPositionWithEndScrollEvent:scrollView];
    
    if ([self.delegate respondsToSelector:@selector(endScrollingAction:index:)]) {
        
        [self.delegate endScrollingAction:self index:index];
    }
}
@end


