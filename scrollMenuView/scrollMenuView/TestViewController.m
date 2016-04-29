//
//  TestViewController.m
//  scrollMenuView
//
//  Created by johnny_wu on 2016/4/26.
//  Copyright © 2016年 johnny_wu. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //////////////////////////////////////////////////
    
    _testTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.testTableView.dataSource = self;
    self.testTableView.delegate = self;
    
    //////////////////////////////////////////////////
    
    _testDataArray = [NSMutableArray array];
    
    for(NSInteger i = 0; i < 120; i++) {
        NSString *itemName = [NSString stringWithFormat: @"%ld", (long)i];
        [self.testDataArray addObject:itemName];
    }
    
    //////////////////////////////////////////////////
    
    [self.view addSubview:self.testTableView];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.testDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = (NSString *)[self.testDataArray  objectAtIndex:indexPath.row];
    return cell;
    
}

@end
