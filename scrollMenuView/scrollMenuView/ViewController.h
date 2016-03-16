//
//  ViewController.h
//  scrollMenuView
//
//  Created by johnny_wu on 2016/3/9.
//  Copyright © 2016年 johnny_wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuView.h"

@interface ViewController : UIViewController <MenuViewDelegate>

@property (nonatomic, retain) MenuView *menuView;

@end

