//
//  SettingViewController.m
//  BaiduMapTest
//
//  Created by ZKR on 5/26/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor]}];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setFrame:CGRectMake(0, 0, 320, 40)];
    [btn setTitle:@"返回 " forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
