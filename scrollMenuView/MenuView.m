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
    
    ScrollMenuCell *addMenuCell = [[ScrollMenuCell alloc] init];
    
    addMenuCell.cellTextView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                        0,
                                                                        cellTextSize.width,
                                                                        self.scrollViewHeight)];
    addMenuCell.cellTextView.backgroundColor = [UIColor clearColor];
    UILabel *labelOfCell = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     cellTextSize.width,
                                                                     self.scrollViewHeight)];
    labelOfCell.textAlignment = NSTextAlignmentCenter;
    labelOfCell.text = [self.dataArray objectAtIndex:index];
    labelOfCell.textColor = [UIColor colorWithRed: 102/255.0f green: 102/255.0f blue: 102/255.0f alpha:1.0f];
    [labelOfCell setFont:[UIFont systemFontOfSize:14]];
    
    //////////////////////////////////////////////////
    // 其實寫這樣不太好，應該把label直接寫在scrollMenuCell中當成property，以修改property的方式進行更改 by Johnny
    
    [addMenuCell.cellTextView  addSubview:labelOfCell];
    
    return addMenuCell.cellTextView ;
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
    
    // NSLog(@"click cell at %ld",index);
    [self setCurrentLabelTextBeSelectedWithIndex:scrollMenuView.currentSelectedIndex scrollview:scrollMenuView isSelected:NO];
    [self setCurrentLabelTextBeSelectedWithIndex:index scrollview:scrollMenuView isSelected:YES];
    
    if ([self.delegate respondsToSelector:@selector(endScrollingAction:index:)]) {
        
        [self.delegate endScrollingAction:self index:index];
    }
    
    scrollMenuView.currentSelectedIndex = index;
}





#pragma mark -
#pragma mark - Override ScrollView Method
//================================================================================
//
//================================================================================
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
    [self setCurrentLabelTextBeSelectedWithIndex:self.scrollMenuView.currentSelectedIndex scrollview:scrollView isSelected:NO];
}


//================================================================================
//
//================================================================================
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

    [self setCurrentLabelTextBeSelectedWithIndex:self.scrollMenuView.currentSelectedIndex scrollview:scrollView isSelected:NO];
}


//================================================================================
// 處理滑動後的事件
//================================================================================
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = [self.scrollMenuView moveToPositionWithEndScrollEvent:scrollView];
    
    [self setCurrentLabelTextBeSelectedWithIndex:index scrollview:scrollView isSelected:YES];
    
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
    
    [self setCurrentLabelTextBeSelectedWithIndex:index scrollview:scrollView  isSelected:YES];
    
    if ([self.delegate respondsToSelector:@selector(endScrollingAction:index:)]) {
        
        [self.delegate endScrollingAction:self index:index];
    }
    
}


//================================================================================
//
//================================================================================
- (void)scrollingPostionWithIndex:(NSInteger)index
{
    [self.scrollMenuView goToPositionWithIndex:index];
}


//================================================================================
//
//================================================================================
- (void)setLeftRightWithGradientImage:(UIImage *)leftImage rightImage:(UIImage *)rightImage {
    
    UIImageView *leftImageView = [[UIImageView alloc]initWithImage:leftImage];
    leftImageView.frame = CGRectMake(0,
                                     0,
                                     leftImage.size.width,
                                     leftImage.size.height);
    [self addSubview:leftImageView];
    
    UIImageView *rightImageView = [[UIImageView alloc]initWithImage:rightImage];
    rightImageView.frame = CGRectMake(self.frame.size.width - rightImage.size.width,
                                      0,
                                      rightImage.size.width,
                                      rightImage.size.height);
    [self addSubview:rightImageView];
}


//================================================================================
//
//================================================================================
- (void)setCurrentLabelTextBeSelectedWithIndex:(NSInteger)index scrollview:(UIScrollView *)scrollView isSelected:(BOOL)isSelected{
    
    
    ScrollMenuCell *cell = [self.scrollMenuView.arrayOfCell objectAtIndex:index];
        
    for(UIView *textView in cell.cellTextView.subviews) {
        
        if([textView isKindOfClass:[UILabel class]]) {
            
            if (isSelected) {
                
                ((UILabel *)textView).textColor = [UIColor colorWithRed: 199/255.0f green: 0/255.0f blue: 0/255.0f alpha:1.0f];
            }
            else {
            
                ((UILabel *)textView).textColor = [UIColor colorWithRed: 102/255.0f green: 102/255.0f blue: 102/255.0f alpha:1.0f];
            }
           
        }
    }

}

@end


