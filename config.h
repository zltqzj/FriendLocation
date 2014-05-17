//
//  config.h
//  BaiduMapTest
//
//  Created by ZKR on 5/7/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#ifndef BaiduMapTest_config_h
#define BaiduMapTest_config_h

// 数值转为字符串
#define valueToString(_value) [@(_value) stringValue]

#define PI 3.14159265358979323846264338327950288

#pragma mark - 判断设备
// 屏幕高度
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width

// IPHONE
#define IS_IPHONE [ [ UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPhone

// IPAD
#define IS_IPAD [ [ UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPad

// 判断是否为IPHONE5
# define IS_IPHONE5  ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

// 判断设备版本
// 版本等于
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

// 版本高于
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

// 版本高于等于
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

// 版本小于
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

// 版本小于等于
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// 判断是否大于7
#define ISIOS7  [[[UIDevice currentDevice] systemVersion] floatValue]>=7

// 上传设备
#define UPLOAD_DEVICE @"http://weixin.jsptz.com/map.php?action=uploadDeviceToken&username=zhaojian"

// 下载IPA
#define DOWNLOAD @"itms-services://?action=download-manifest&url=https://dl.dropboxusercontent.com/s/hnu4brntx7eeoig/location.plist"

// 检查是否有更新
#define UPDATE @"http://weixin.jsptz.com/map/app/ipa_version.php"

// 注册
#define REGIST @"http://weixin.jsptz.com/map.php?action=reg&username="

// 登陆
#define LOGIN @"http://weixin.jsptz.com/map.php?action=login&username="

// 改变自己可视权限
#define CHANGE_MYSELF @"http://weixin.jsptz.com/map.php?action=changeMyPermission&userid="

// 查询自己可视权限
#define SEARCH_MY_PERMISSON @"http://weixin.jsptz.com/map.php?action=getMyPermisson&userid="

// 不让好友看到我
#define FORBIDDEN @"http://weixin.jsptz.com/map.php?action=forbidden&userid="

// 让好友看到我
#define RM_FORBIDDEN @"http://weixin.jsptz.com/map.php?action=rmForbidden&userid="

// 查询所有人的坐标
#define ALL_LOCATION @"http://weixin.jsptz.com/map.php?action=getAllUserLocaltion&userid=45"

// 上传我的坐标
#define  UPLOAD_LOCATION @"http://weixin.jsptz.com/map.php?action=uploadMyLocation"

#define VISIBLE @"可见我的位置"
#define UNVISIBLE @"不可见我的位置"





#endif
