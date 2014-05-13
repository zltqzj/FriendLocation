//
//  LeftViewController.m
//  BaiduMapTest
//
//  Created by ZKR on 5/8/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController
@synthesize list = _list;
@synthesize myTable = _myTable;
@synthesize cellList = _cellList;
@synthesize hiddenMyselfButton = _hiddenMyselfButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initTable{
    
    self.title = @"朋友列表";
    _cellList  = [[NSMutableArray alloc] initWithCapacity:10];
    
    [self.view setBackgroundColor:[UIColor orangeColor]];
    
    if (IS_IPHONE5||IS_IPAD) {
          _myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _myTable.autoresizingMask = UIViewAutoresizingFlexibleHeight;
       // NSLog(@"TABLE高度%f",self.view.bounds.size.height);
    }
    else{
        _myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _myTable.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
  
    _myTable.delegate = self;
    _myTable.dataSource = self;
 
    [self.view addSubview:_myTable];
    
    
    if (SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"7")&&[self.navigationController.navigationBar respondsToSelector:@selector(setTintColor:)]) {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav.png"]]];
    }
    
    
    
    // 倒数第二个按钮
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    NSString* user_id = [user objectForKey:@"id"];
    NSString* per_key  =[NSString stringWithFormat:@"%@_permission",user_id];

    UIBarButtonItem* hiddenMyself = [[UIBarButtonItem alloc] initWithTitle:@"隐藏我" style:UIBarButtonItemStyleBordered target:self action:@selector(hiddenMyself)];
    [hiddenMyself setTintColor:[UIColor blackColor]];
    _hiddenMyselfButton = hiddenMyself;
    
    if ([user objectForKey:per_key]) {
        NSLog(@"已经设置");
        [hiddenMyself setTitle:[user objectForKey:per_key]];
    }else{
        
    }
        
    [self.navigationItem setLeftBarButtonItems:@[hiddenMyself] animated:YES];
}


// 点击隐藏（打开）按钮触发事件
-(void)hiddenMyself{
    
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    NSString* user_id = [user objectForKey:@"id"];
    NSString* per_key  =[NSString stringWithFormat:@"%@_permission",user_id];
    
    // 判断按钮的title
    NSString *url = nil;
    if ([_hiddenMyselfButton.title isEqualToString:@"隐藏我"]) {
        url = [NSString stringWithFormat:@"%@%@&enable=2",CHANGE_MYSELF,user_id];
        
    }
    else{
        url = [NSString stringWithFormat:@"%@%@&enable=1",CHANGE_MYSELF,user_id];
        
    }
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    NSLog(@"藏住(打开)我自己url%@",url);
    _hideMyLocation = request;
    [_hideMyLocation setTimeOutSeconds:10];
    [_hideMyLocation startAsynchronous];
    if ([_hiddenMyselfButton.title isEqualToString:@"隐藏我"]) {
        [ProgressHUD show:@"正在隐藏我的位置……"];
    }
    else{
        [ProgressHUD show:@"正在打开我的位置……"];
    }
    
    [_hideMyLocation setCompletionBlock:^{
        [ProgressHUD dismiss];
        NSString* response = [_hideMyLocation responseString];
        if ([response isEqualToString:@"1"]) { // 说明现在是打开状态
            if ([_hiddenMyselfButton.title isEqualToString:@"打开我"]) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经打开我的位置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [user setValue:@"隐藏我" forKey:per_key];
                [_hiddenMyselfButton setTitle:@"隐藏我"];
                
                
                // 给列表一个通知，未完待续
            }
            else{
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经隐藏我的位置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [user setValue:@"打开我" forKey:per_key];
                [_hiddenMyselfButton setTitle:@"打开我"];
                // 给列表一个通知，未完待续
            }
            UIStoryboard* sbd = nil;
            if (IS_IPHONE) {
                sbd  = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            }
            if (IS_IPAD) {
                sbd = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
            }
            
            
            
            
        }
        else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"操作失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                // 寻找我的坐标状态（是否开启）
                NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
                NSString* id = [user objectForKey:@"id"];
                NSString* url = [NSString stringWithFormat:@"%@%@",SEARCH_MY_PERMISSON,id];
                 ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL  URLWithString:url]];
                _searchMyLocationState = request;
                [_searchMyLocationState startAsynchronous];
                [_searchMyLocationState setCompletionBlock:^{
                    NSLog(@"查询自己状态返回值：%@",[_searchMyLocationState responseString]);
                    if ([[_searchMyLocationState responseString] isEqualToString:@"1"]) { // 说明现在是不可见状态
                         [_hiddenMyselfButton setTitle:@"隐藏我"];
                    }else{// 说明现在是可见状态
                      
                        [_hiddenMyselfButton setTitle:@"打开我"];

                    }
                }];
                [_searchMyLocationState setFailedBlock:^{
                    NSLog(@"查询自己状态返回值：%@",[_searchMyLocationState responseString]);
                    [ProgressHUD showError:@"请检查网络"];
                }];
                
                
            }];
        }
        
    }];
    [_hideMyLocation setFailedBlock:^{
        [ProgressHUD showError:@"请检查网络"];
    }];
    
}



-(void)refreshFriends:(NSNotification*)info  {
   
    NSDictionary* dict = info.userInfo;
    NSLog(@"字典：%@",dict);
    _list= [dict objectForKey:@"list"];
    NSLog(@"数组：%@",_list);
 
    if (_list) {
        [ProgressHUD dismiss];
         [self.myTable reloadData];
    }
    else{
        [ProgressHUD show:@"正在查询好友列表……"];
    }
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTable]; // 初始化列表
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFriends:) name:@"refreshFriends" object:nil];
    
    
    
    MapPoint* map = [[ MapPoint alloc] init];
    map = [_list objectAtIndex:0];
    NSLog(@"数组第一项：latitude：%f,longitude%f,titile:%@",map.coordinate.latitude, map.coordinate.longitude,map.title);
    
    
}


// 点击开关事件
-(void)switch:(id)sender{
    UISwitch* switchControl = sender;
    
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    MapPoint* map = [[ MapPoint alloc] init];
    map = [_list objectAtIndex:switchControl.tag];
    
    NSUserDefaults* user  = [NSUserDefaults standardUserDefaults];
    
    NSDictionary* userinfo = [NSDictionary dictionaryWithObject:map.title forKey:@"name"];
    
    
    if(switchControl.on ){
        [user setValue:@"YES" forKey:map.title];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"add" object:self userInfo:userinfo];
    }
    else {
        [user setValue:@"NO" forKey:map.title];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"remove" object:self userInfo:userinfo];
    }
    
}

#pragma mark - UITableViewDataSouce


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CustomCellIdentifier = @"cell";
    MyCell* cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (cell == nil) {
        cell = [[MyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier];
    }
   
        NSString* str =[[_list objectAtIndex:indexPath.row] title];
        NSLog(@"%@",str);
        cell.name.text =str ;
    
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
   
    if ([[user objectForKey:str] isEqualToString:@"YES"]) {
        [cell.state setOn:YES];
    }else{
        [cell.state setOn:NO];
    }
   
    [_cellList addObject:cell];// 所有cell添加到数组中
    
    cell.state.tag = indexPath.row;  // 给每行设置tag值，第0行的tag为0
    [cell.state addTarget:self action:@selector(switch:) forControlEvents:UIControlEventValueChanged];
    // 点击只显示
    [cell.onlyAppear handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        NSLog(@"点击"); // 遍历数组，将所有开关关闭。
        for (MyCell* item in _cellList) {
            [item.state setOn:NO];// 列表中的显示
           
            [user setValue:@"NO" forKey:item.name.text]; // 保存起来
             NSDictionary* userinfo = [NSDictionary dictionaryWithObject:item.name.text forKey:@"name"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"remove" object:self userInfo:userinfo];// 地图中的显示

        }
        [cell.state setOn:YES];
        [user setValue:@"YES" forKey:cell.name.text];
         NSDictionary* userinfo = [NSDictionary dictionaryWithObject:cell.name.text forKey:@"name"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"add" object:self userInfo:userinfo];// 地图中的显示

    }];
    
    return cell;
    
}



-(void)dealloc
{
    // [super dealloc];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}



 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
