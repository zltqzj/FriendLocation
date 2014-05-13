//
//  LoginViewController.m
//  IphoneMapSdkDemo
//
//  Created by ZKR on 5/6/14.
//  Copyright (c) 2014 Baidu. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "MMDrawerBarButtonItem.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize login_request = _login_request;
@synthesize textfield = _textfield;
@synthesize loginBtn = _loginBtn;
@synthesize label = _label;
@synthesize indicator;
-(IBAction)regist:(id)sender
{
    UIStoryboard* sb  = nil;
    if (IS_IPAD) {
       sb = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    }
    else if(IS_IPHONE){
        sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];

    }
    RegistViewController* regist = [sb instantiateViewControllerWithIdentifier:@"regist"];
    UINavigationController* registNav = [[UINavigationController alloc] initWithRootViewController:regist];
    [self presentViewController:registNav animated:YES completion:nil];
    

}




-(IBAction)login:(id)sender
{
    if ([_textfield.text isEqualToString:@""]||_textfield.text == nil || _textfield.text ==NULL || [_textfield.text isKindOfClass:[NSNull class]] || [[_textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
            
        }];
    }
    
    else{
        NSString* url = [NSString stringWithFormat:@"%@%@",LOGIN,self.textfield.text];
        NSLog(@"%@",url);
        ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        _login_request = request;
    
        if (_login_request) {
            [_login_request startAsynchronous];
            
            [_login_request setTimeOutSeconds:10];
            [ProgressHUD show:@"正在登陆"];
            [_login_request setCompletionBlock:^{
                //  NSLog(@"登陆返回值%@",[_login_request responseString]);
                NSString* resp = [_login_request responseString];
                if ([resp isEqualToString:@"wrong"]||[resp isEqualToString:@"niubi"]|| [resp isEqualToString:@"0"]) {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登陆失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    [ProgressHUD dismiss];
                }else{
                    SBJsonParser* sb = [[SBJsonParser alloc] init];
                    NSArray* list = [sb objectWithString:resp];
                    NSDictionary* dict = [list objectAtIndex:0];
                    NSString* id = [dict objectForKey:@"id"];
                    //   NSLog(@"id:%@",resp);
                    // 将返回值存储为userid  nsuserdeafault
                    NSUserDefaults* userD = [NSUserDefaults standardUserDefaults];
                    [userD setValue:id forKey:@"id"];
                    [userD setValue:self.textfield.text forKey:@"currentPerson"];
                    
                    // 跳转
                    UIStoryboard* sbd = nil;
                    if (IS_IPHONE) {
                        sbd  = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
                    }
                    if (IS_IPAD) {
                        sbd = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
                    }
                    [ProgressHUD showSuccess:@"登陆成功"];
                    ViewController* view =  [sbd instantiateViewControllerWithIdentifier:@"map"];
                    UINavigationController* centerView = [[UINavigationController alloc] initWithRootViewController:view];
                    
                    

                    
                    LeftViewController* left = [sbd instantiateViewControllerWithIdentifier:@"left"];
                    UINavigationController* leftView = [[UINavigationController alloc] initWithRootViewController:left];
                    
                    
                    MMDrawerController* draw= [[MMDrawerController alloc] initWithCenterViewController:centerView rightDrawerViewController:leftView];
                    if (IS_IPAD) {
                        [draw setMaximumRightDrawerWidth:600.0];

                    }
                    else
                        [draw setMaximumRightDrawerWidth:280.0];
                    [draw setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
                    [draw setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
                    [draw setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
                        MMDrawerControllerDrawerVisualStateBlock block;
                        block = [[MMExampleDrawerVisualStateManager sharedManager]
                                 drawerVisualStateBlockForDrawerSide:drawerSide];
                        if(block){
                            block(drawerController, drawerSide, percentVisible);
                        }
                    }];
                    [self.navigationController pushViewController:draw animated:YES];
                    [self.navigationItem.backBarButtonItem setTintColor:[UIColor blackColor]];
                    [self.navigationController.navigationBar setHidden:YES];
                    
                    if ([self.navigationController.navigationBar respondsToSelector:@selector(setTintColor:)]) {
                      [self.navigationController.navigationBar setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav.png"]]];

                    }
//                    [self.navigationController pushViewController:view animated:YES];
                    
                  // 修改导航栏返回按钮
                    
                }
                
            }];
            [_login_request setFailedBlock:^{
                NSLog(@"返回值%@",[_login_request responseString]);
                [ProgressHUD showError:@"请检查网络"];
            }];

        }
    }
    
}

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
    _textfield.delegate = self;
    
    self.title = @"登陆";
    
    if (SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"7")&&[self.navigationController.navigationBar respondsToSelector:@selector(setTintColor:)]) {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav.png"]]];
    }
    
   
    
   
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:@"currentPerson"]) {
        self.textfield.text = [user objectForKey:@"currentPerson"];
    }
    else
        self.textfield.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_textfield resignFirstResponder];
    return  YES;
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textfield resignFirstResponder];
}


@end
