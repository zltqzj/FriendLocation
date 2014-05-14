//
//  MyCell.h
//  BaiduMapTest
//
//  Created by ZKR on 5/8/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell : UITableViewCell

@property(strong,nonatomic) IBOutlet UILabel* name;

@property(strong,nonatomic) IBOutlet UISwitch* state;

@property(strong,nonatomic) IBOutlet UIButton* onlyAppear;

@property(strong,nonatomic) IBOutlet UIButton* forbidden;



@end
