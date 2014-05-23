//
//  AppDelegate.m
//  BaiduMapTest
//
//  Created by ZKR on 5/6/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//   秘钥  CF7d38a52d4e9a6cf1a00befc440e430

#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "LoginViewController.h"

@implementation AppDelegate
@synthesize updateReq = _updateReq;
@synthesize uploadDevice = _uploadDevice;
@synthesize hostReach = _hostReach;

-(void)GetUpdate
{
    NSString* str = UPDATE;
    NSURL* url = [NSURL URLWithString:str];
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setStringEncoding:NSUTF8StringEncoding];
    
    _updateReq = request;
    
    
    
    if (_updateReq) {
        [_updateReq startAsynchronous];
        
        [_updateReq setCompletionBlock:^{
            
            NSString* str = [_updateReq responseString];
            
            SBJsonParser* sbjsonparser = [[SBJsonParser alloc] init];
            NSDictionary* dict = [sbjsonparser objectWithString:str];
            
            NSString* verCode = [dict objectForKey:@"verCode"];
            
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *nowVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
            
            NSURL* url = [NSURL URLWithString:DOWNLOAD];
            
            if (![verCode isEqualToString:nowVersion] &&verCode ) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"版本更新" delegate:self cancelButtonTitle:@"暂不升级" otherButtonTitles:@"马上升级", nil];
                [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                    switch (buttonIndex) {
                        case 0:
                            NSLog(@"暂不升级");
                            break;
                        case 1:
                            NSLog(@"马上升级");
                            
                            [[UIApplication sharedApplication] openURL:url];
                            break;
                        default:
                            break;
                    }
                }];
            }
            
        }];
        [_updateReq setFailedBlock:^{
            //  [ProgressHUD showError:@"请检查网络"];
            NSLog(@"%@",[_updateReq responseString]);
        }];

    }
}

- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"网络出错了……"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (ISIOS7) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav.png"] forBarMetrics:UIBarMetricsDefault];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
  
    _hostReach  = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [_hostReach startNotifier];
 

    // 推送内容有关
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];

    return YES;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAll;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self GetUpdate]; // 检查更新
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"one_la"];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString* newToken = [[[NSString stringWithFormat:@"%@",deviceToken]
                           stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"nsdata:%@\n 字符串token: %@",deviceToken, newToken);
    
    // 上传到服务器
    NSString* str1 = UPLOAD_DEVICE;
    NSString* str = [NSString stringWithFormat:@"%@&token=%@",str1,newToken];
    NSURL* url = [NSURL URLWithString:str];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setStringEncoding:NSUTF8StringEncoding];
    
    [request setTimeOutSeconds:10.0];
    
    
    _uploadDevice = request;
    
    if (_uploadDevice) {
        [_uploadDevice startAsynchronous];
        
        [_uploadDevice setFailedBlock:^{
            // [ProgressHUD showError:@"请检查网络"];
            
        }];
        
        [_uploadDevice setCompletionBlock:^{
            
            NSString* str = [_uploadDevice responseString];
            str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSLog(@"返回值：%@",str);
            
            if ([str isEqualToString:@"success"]) {
                // NSLog(@"success");
                // [ProgressHUD showSuccess:@"upload device token success"];
                
            }
            else if([str isEqualToString:@"failed"]){
                // NSLog(@"数据库插入错误");
                //  [ProgressHUD showError:@"upload device token failed"];
            }
            else{
                
            }
            
        }];
        
    }
    
    
    
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"RegistFail%@",error);
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // 处理推送消息
    NSLog(@"userinfo:%@",userInfo);
    
    NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    
}

@end
