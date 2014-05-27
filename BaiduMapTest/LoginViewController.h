//
//  LoginViewController.h
//  IphoneMapSdkDemo
//
//  Created by ZKR on 5/6/14.
//  Copyright (c) 2014 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJSON.h"
#import "ViewController.h"
#import "RightViewController.h"
#import "LeftViewController.h"
#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property(weak,nonatomic) ASIFormDataRequest* login_request;

@property(strong,nonatomic) IBOutlet UITextField* textfield;

@property(strong,nonatomic) IBOutlet UILabel* label;

@property(strong,nonatomic) IBOutlet UIButton* loginBtn;

@property(strong,nonatomic) UIActivityIndicatorView * indicator;


-(IBAction)login:(id)sender;

-(IBAction)regist:(id)sender;


@end
