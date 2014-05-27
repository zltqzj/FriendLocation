//
//  MyCell.h
//  BaiduMapTest
//
//  Created by ZKR on 5/8/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJSwitch.h"
@interface MyCell : UITableViewCell

@property(strong,nonatomic) IBOutlet UILabel* name;

@property(strong,nonatomic) IBOutlet UISwitch* state;

@property(strong,nonatomic) IBOutlet UIButton* onlyAppear;

@property(strong,nonatomic) IBOutlet UIButton* forbidden;

@property(strong,nonatomic) IBOutlet ZJSwitch* appear_on_map_switch;

@property(strong,nonatomic) IBOutlet ZJSwitch* hide_me_to_him;



@property(strong,nonatomic) IBOutlet UIImageView* portrait;

@end
