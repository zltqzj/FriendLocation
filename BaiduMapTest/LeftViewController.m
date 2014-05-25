//
//  LeftViewController.m
//  BaiduMapTest
//
//  Created by ZKR on 5/25/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController
@synthesize list = _list;
@synthesize myTable  = _myTable;

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
    self.title = @"个人设置";
    _myTable  = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    //  [_mytable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    _myTable.delegate = self;
    _myTable.dataSource = self;
    _list = [[NSMutableArray alloc] initWithCapacity:10];
    [self.view addSubview:_myTable];
    
    _list = [[NSMutableArray alloc] initWithCapacity:10];
    
    [_list addObject:@"添加好友"];
     [_list addObject:@"我的足迹"];
    [_list addObject:@"我的周边"];
    [_list addObject:@"清除我的位置"];
    [_list addObject:@"高级设置"]; // 头像，昵称，反馈，分享
     [_list addObject:@"关注微信"];
     [_list addObject:@"分享APP"];
    [_list addObject:@"退出账号"];


	// Do any additional setup after loading the view.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text =  [_list objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
