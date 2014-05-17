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

@interface LeftViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property(strong,nonatomic) NSMutableArray* list;
@property(strong,nonatomic) UITableView* myTable;

@property(strong,nonatomic) NSMutableArray* forbiddenList;

@property(strong,nonatomic) NSMutableArray* cellList;
@property(strong,nonatomic) NSMutableArray* friendIDs;

@property(strong,nonatomic) NSString* fobiddenInMyItem;

@property(strong,nonatomic) UIBarButtonItem* hiddenMyselfButton;

@property(weak,nonatomic) ASIFormDataRequest* hideMyLocation; // 暂时不用了
@property(weak,nonatomic) ASIFormDataRequest* searchMyLocationState;  // 查询我位置的状态

@property(weak,nonatomic) ASIFormDataRequest* forbiddenRequest;// 不让某人看见我
@property(weak,nonatomic) ASIFormDataRequest* rm_forbiddenRequest;// 让某人看见我




@end
