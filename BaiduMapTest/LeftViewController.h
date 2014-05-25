//
//  LeftViewController.h
//  BaiduMapTest
//
//  Created by ZKR on 5/25/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) NSMutableArray* list;

@property(strong,nonatomic)UITableView* myTable;

@end
