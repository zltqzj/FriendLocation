//
//  RegistViewController.h
//  BaiduMapTest
//
//  Created by ZKR on 5/8/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistViewController : UIViewController <UITextFieldDelegate>

@property(strong,nonatomic) IBOutlet UITextField* textfield;
@property(weak,nonatomic) ASIFormDataRequest* regist_request;

-(IBAction)back:(id)sender;

-(IBAction)regist:(id)sender;

@end
