//
//  TestViewController.h
//  scrollMenuView
//
//  Created by johnny_wu on 2016/4/26.
//  Copyright © 2016年 johnny_wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *testTableView;
@property (nonatomic, retain) NSMutableArray *testDataArray;

@end
