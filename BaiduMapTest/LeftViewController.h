//
//  LeftViewController.h
//  BaiduMapTest
//
//  Created by ZKR on 5/8/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapPoint.h"
#import "MyCell.h"
#import "ViewController.h"
#import "MMExampleSideDrawerViewController.h"
#define VISIBLE @"可见我的位置"
#define UNVISIBLE @"不可见我的位置"

@interface LeftViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>



@property(strong,nonatomic) NSMutableArray* list;
@property(strong,nonatomic) UITableView* myTable;

@property(strong,nonatomic) NSMutableArray* forbiddenList;

@property(strong,nonatomic) NSMutableArray* cellList;

@property(strong,nonatomic) UIBarButtonItem* hiddenMyselfButton;

@property(weak,nonatomic) ASIFormDataRequest* hideMyLocation;
@property(weak,nonatomic) ASIFormDataRequest* searchMyLocationState;

@property(weak,nonatomic) ASIFormDataRequest* forbiddenRequest;// 不让某人看见我
@property(weak,nonatomic) ASIFormDataRequest* rm_forbiddenRequest;// 让某人看见我




@end
