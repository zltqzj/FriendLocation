//
//  RegistViewController.m
//  BaiduMapTest
//
//  Created by ZKR on 5/8/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()

@end

@implementation RegistViewController
@synthesize textfield = _textfield;
@synthesize regist_request = _regist_request;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(IBAction)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}





-(IBAction)regist:(id)sender
{
    
    if ([_textfield.text isEqualToString:@""]||_textfield.text == nil || _textfield.text ==NULL || [_textfield.text isKindOfClass:[NSNull class]] || [[_textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
            
        }];
    }
    else if([_textfield.text rangeOfString:@"|"].location  || [_textfield.text rangeOfString:@" "].location ){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"输入格式不正确" message:@"不能输入‘|’或空格" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
            if (buttonIndex ==0) {
                _textfield.text = @"";
            }
        }];
    }
    
    else{
    
    NSString* url = [NSString stringWithFormat:@"%@%@&latitude=-1&longitude=-1",REGIST,self.textfield.text];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSLog(@"%@",url);
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    _regist_request = request;
    [_regist_request setResponseEncoding:NSUTF8StringEncoding];
        
        if (_regist_request) {
            [_regist_request startAsynchronous];
            [ProgressHUD show:@"正在注册……"];
            [_regist_request setCompletionBlock:^{
                
            
            NSUserDefaults* currentPerson = [NSUserDefaults standardUserDefaults];
             //   [ProgressHUD dismiss];
            
            NSLog(@"注册返回值：%@",[_regist_request responseString]);
            NSData* response1 = [_regist_request responseData];
            NSString* response = [[NSString alloc] initWithBytes:[response1 bytes]length:[response1 length]encoding:NSUTF8StringEncoding];
            [ProgressHUD dismiss];
            
            if ([response isEqualToString:@"用户已注册"]) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户已注册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                    
                }];
            }
            else{
                [currentPerson setValue:self.textfield.text forKey:@"currentPerson"];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
            }
        }];
        [_regist_request setFailedBlock:^{
                   [ProgressHUD dismiss];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                
            }];
        }];

        
     }
   
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _textfield.delegate = self;
    _textfield.clearButtonMode = UITextFieldViewModeAlways;
    

    self.title = @"注册";
    // 导航栏左侧按钮
    UIBarButtonItem* f = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    [f setTintColor:[UIColor blackColor]];
    
    self.navigationItem.leftBarButtonItems = @[f];
    
    if (SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"7")&&[self.navigationController.navigationBar respondsToSelector:@selector(setTintColor:)]) {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav.png"]]];
    }
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_textfield resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [_textfield resignFirstResponder];
    
    
}


@end
