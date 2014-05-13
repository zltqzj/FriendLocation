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
@interface LeftViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>



@property(strong,nonatomic) NSMutableArray* list;
@property(strong,nonatomic) UITableView* myTable;


@property(strong,nonatomic) NSMutableArray* cellList;

@property(strong,nonatomic) UIBarButtonItem* hiddenMyselfButton;
@property(weak,nonatomic) ASIFormDataRequest* hideMyLocation;
@property(weak,nonatomic) ASIFormDataRequest* searchMyLocationState;


@end
