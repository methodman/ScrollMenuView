//
//  ViewController.h
//  scrollMenuView
//
//  Created by johnny_wu on 2016/3/9.
//  Copyright © 2016年 johnny_wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuView.h"
#import "TestViewController.h"

@interface ViewController : UIViewController <MenuViewDelegate, UIScrollViewDelegate>

@property (nonatomic, retain) MenuView *menuView;
@property (nonatomic, retain) UIScrollView *mainScrollView;
@property (nonatomic, retain) TestViewController *testViewController;

@end

