//
//  AppDelegate.h
//  BaiduMapTest
//
//  Created by ZKR on 5/6/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,weak) ASIFormDataRequest* updateReq;
@property(nonatomic,weak) ASIFormDataRequest* uploadDevice;
@end
