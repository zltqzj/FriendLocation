//
//  ViewController.m
//  BaiduMapTest
//
//  Created by ZKR on 5/6/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//  百度坐标与火星坐标转换网址：http://www.cnblogs.com/ios8/archive/2013/12/09/ios-gps.html

#import "ViewController.h"
#import "JSON.h"
#import "MMDrawerBarButtonItem.h"
#import "RightViewController.h"
#import "LoginViewController.h"

typedef NS_ENUM(NSInteger, MMCenterViewControllerSection){
    MMCenterViewControllerSectionLeftViewState,
    MMCenterViewControllerSectionLeftDrawerAnimation,
    MMCenterViewControllerSectionRightViewState,
    MMCenterViewControllerSectionRightDrawerAnimation,
};


const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;

@interface ViewController ()
@property (nonatomic,assign) CGRect openFrame;
@property (nonatomic,assign) CGRect closeFrame;
@property (nonatomic,assign) CGRect openFrameBottom;
@property (nonatomic,assign) CGRect closeFrameBottom;
@end

@implementation ViewController
@synthesize friendIDs = _friendIDs;
@synthesize fobiddenInMyItem = _fobiddenInMyItem;
@synthesize zoom_level = _zoom_level;
@synthesize list = _list;
@synthesize upload_location_request = _upload_location_request;
@synthesize all_location_request = _all_location_request;
@synthesize m_timer;
@synthesize manager = _manager;
@synthesize getMyPermisson = _getMyPermisson;
@synthesize uploadGPS_timer = _uploadGPS_timer;
@synthesize forbiddenList = _forbiddenList;


#pragma mark - FUNCTIONS

-(void)refresh{
    NSLog(@"刷新");
  
    [self deleteAnnos];// 删除所有标注
    
    [self addAnnos]; // 添加所有标注
    [ProgressHUD show:@"正在刷新所有人的位置……"];
    NSMutableDictionary* dict2 = [[NSMutableDictionary alloc] initWithCapacity:10];
    if (_list.count!=0) {
        [dict2 setObject:_list forKey:@"list"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFriends" object:self userInfo:dict2];
    }
    else
        [self refresh];
    
}


// 是否wifi
- (BOOL) IsEnableWIFI{
    return([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}
// 是否3G
- (BOOL) IsEnable3G{
    return([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

// 地图上的按钮
-(void)initButtonOnMap
{
    UIButton* gps_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [gps_btn setImage:[UIImage imageNamed:@"location_point.png"] forState:UIControlStateNormal];
    [gps_btn setFrame:CGRectMake(self.view.bounds.size.width-48, 10, 38, 38)];
    [_mapView addSubview:gps_btn];
    
    [gps_btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        [ProgressHUD show:@"定位中……"];
        
        if (_manager.location.coordinate.latitude > 1) {
            MKCoordinateRegion theRegion = { {0.0, 0.0 }, { 0.0, 0.0 } };
            theRegion.span.longitudeDelta = 0.01f;
            theRegion.span.latitudeDelta = 0.01f;
            MKCoordinateSpan theSpan;
            theSpan.latitudeDelta=0.05;
            theSpan.longitudeDelta=0.05;
            theRegion.center=[_manager.location coordinate];
            theRegion.span=theSpan;
            [_mapView setRegion:[_mapView regionThatFits:theRegion] animated:TRUE];
            [_mapView setDelegate:self];
            [_mapView setShowsUserLocation:YES];
            
            [_mapView setRegion:theRegion animated:YES];
            // 这里是不是不准确  判断一下
            if ([self IsEnableWIFI]) { // wifi
                 [_mapView setCenterCoordinate: _manager.location.coordinate animated:YES];
            }
            else{ // 3g
                 [_mapView setCenterCoordinate:[self hhTrans_bdGPS:_manager.location.coordinate] animated:YES];
            }
            
           // [_mapView setCenterCoordinate:[self hhTrans_bdGPS:_manager.location.coordinate] animated:YES];
            [ProgressHUD showSuccess:@"定位成功"];
        }
        else{
            [ProgressHUD dismiss];
            //请打开系统设置中“隐私->定位服务”，允许“朋友定位”使用您的位置
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert  show];
            
        }
        
        
    }];
    
    UIButton* add_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [add_btn setImage:[UIImage imageNamed:@"btn_zoom_normal.png"] forState:UIControlStateNormal];
    [add_btn setImage:[UIImage imageNamed:@"btn_zoom_pressed.png"] forState:UIControlStateSelected];
    [add_btn setFrame:CGRectMake(self.view.bounds.size.width-48, self.view.bounds.size.height-200, 38, 38)];
    [_mapView addSubview:add_btn];
    [add_btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        NSLog(@"放大");
        MKCoordinateRegion region = _mapView.region;
        region.span.latitudeDelta=region.span.latitudeDelta * 0.4;
        region.span.longitudeDelta=region.span.longitudeDelta * 0.4;
        [_mapView setRegion:region animated:YES];
    }];
    
    UIButton* min_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [min_btn setImage:[UIImage imageNamed:@"btn_narrow_normal.png"] forState:UIControlStateNormal];
    [min_btn setImage:[UIImage imageNamed:@"btn_narrow_pressed.png"] forState:UIControlStateSelected];
    [min_btn setFrame:CGRectMake(self.view.bounds.size.width-48, self.view.bounds.size.height-162, 38, 38)];
    [_mapView addSubview:min_btn];
    [min_btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        NSLog(@"缩小");
        MKCoordinateRegion region = _mapView.region;
        region.span.latitudeDelta=region.span.latitudeDelta * 2.0;
        region.span.longitudeDelta=region.span.longitudeDelta * 2.0;
        [_mapView setRegion:region animated:YES];
    }];
    

}


// 初始化地图
-(void)initMap{
    _zoom_level = 1;
     self.title = @"朋友定位";
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setTintColor:)]) {
         [self.navigationController.navigationBar setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav.png"]]];
    }
    _list = [[NSMutableArray alloc] initWithCapacity:10];
    _forbiddenList = [[NSMutableArray alloc] initWithCapacity:10];
    _friendIDs = [[NSMutableArray alloc] initWithCapacity:10];
    
    // 添加地图
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _mapView.mapType = MKMapTypeStandard;

    [self.view addSubview:_mapView];
    if ([CLLocationManager locationServicesEnabled]) {
        _mapView.showsUserLocation = YES;
        _mapView.delegate = self;
        [_mapView setUserTrackingMode:MKUserTrackingModeNone animated:YES];
    }
   
    [self initButtonOnMap];// 地图上 的按钮
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"id"]) {
         [self addAnnos]; // 添加所有标注
        [self setupRightMenuButton];  // 显示导航栏右侧按钮
    }
    
    
    [self showUserLocation];  //zoom到四环效果
    
    [NSThread detachNewThreadSelector:@selector(loadGPS) toTarget:self withObject:nil];
    
}


-(void)zoomMap
{

    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[user objectForKey:@"one_la"]);
    if ([user objectForKey:@"one_la"]) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[user objectForKey:@"one_la"] doubleValue],[[user objectForKey:@"one_lo"] doubleValue]);
        MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.2);
            //确定要显示的区域
        MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
        NSLog(@"level%d",_zoom_level);
        [_mapView  setCenterCoordinate:coordinate zoomLevel:_zoom_level animated:NO];
            //让地图显示这个区域
        [_mapView setRegion:region animated:YES];
            
        [m_timer invalidate];

        }
        
    else{
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(39.915352,116.397105);
    //缩放比例
        MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.2);
    //确定要显示的区域
        MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
        NSLog(@"level%d",_zoom_level);
        [_mapView  setCenterCoordinate:coordinate zoomLevel:_zoom_level animated:NO];
    //让地图显示这个区域
        [_mapView setRegion:region animated:YES];

        [m_timer invalidate];
    }
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
     [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor]}];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAnno:) name:@"remove" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAnno:) name:@"add" object:nil];
    
    [self initMap]; // 初始化地图
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}


-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    
    for (id mpAno in views) {
        
        if ([mpAno isKindOfClass:[MKAnnotationView class]]) {
           
        }
        
    }
    
    for(MKAnnotationView *view in views)
    {
        if (view.annotation == mapView.userLocation)
        {
            view.canShowCallout = YES;
            view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            break;
        }
    }
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"region changed");
}


#pragma mark - 自己定义的方法

// 定时器、zoom效果，定时上传GPS
-(void)showUserLocation
{
    
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(zoomMap) userInfo:nil repeats:YES];
    
    _uploadGPS_timer= [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(loadGPS) userInfo:nil repeats:YES];
    
        
}

#pragma mark - MKMapViewDelegate

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]] ){
            
        ((MKUserLocation *)annotation).title = @"我的位置";
        //  ((MKUserLocation *)annotation).subtitle = @"中关村东路66号";
        return nil;  //return nil to use default blue dot view
    }
   
    if ([annotation isKindOfClass:[MapPoint class]]) {
       
        
        static NSString* MapPointAnnoationIdentifer = @"mapPointAnnoationIdentifer";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:MapPointAnnoationIdentifer];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:MapPointAnnoationIdentifer];
           // one_la
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"one_name"] isEqualToString:annotation.title]) {
              //  customPinView.pinColor = MKPinAnnotationColorRed;
                customPinView.pinColor = MKPinAnnotationColorRed;

            }else{
            customPinView.pinColor = MKPinAnnotationColorPurple;
            
            }
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
           // NSLog(@"副标题%@",[annotation subtitle]);
            
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
          //  [rightButton addTarget:self action:@selector(showDetail)forControlEvents:UIControlEventTouchUpInside];
            [rightButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
                NSLog(@"*********%@",[annotation title]);
                UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
                UILabel* name = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, 44)];
                name.text = [annotation title];
                name.font = [UIFont  systemFontOfSize:19];
                name.textColor = [UIColor whiteColor];
                [contentView addSubview:name];
                
                UILabel* location = [[UILabel alloc] initWithFrame:CGRectMake(30, 45, contentView.bounds.size.width,44)];
                location.font = [UIFont systemFontOfSize:16];
                location.textColor = [UIColor whiteColor];
                location.text = @"中关村东路66号";
                [contentView addSubview:location];
                
                
                UIButton* chat_btn = [UIButton buttonWithType:UIButtonTypeSystem];
                [chat_btn setFrame:CGRectMake(20, 100, 60, 44)];
                
                [chat_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [chat_btn setTitle:@"对话" forState:UIControlStateNormal];
                [contentView addSubview:chat_btn];
                
                UIButton* trace_btn = [UIButton buttonWithType:UIButtonTypeSystem];
                [trace_btn setFrame:CGRectMake(90, 100, 60, 44)];
                [trace_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [trace_btn setTitle:@"足迹" forState:UIControlStateNormal];
                [contentView addSubview:trace_btn];
                
                UIButton* road_btn = [UIButton buttonWithType:UIButtonTypeSystem];
                [road_btn setFrame:CGRectMake(160, 100, 60, 44)];
                [road_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [road_btn setTitle:@"路径" forState:UIControlStateNormal];
                [contentView addSubview:road_btn];
                
                UIButton* send_my_location =[UIButton buttonWithType:UIButtonTypeSystem];
                [send_my_location setFrame:CGRectMake(20, 155, 100, 44)];
                [send_my_location setTitle:@"发送我的位置" forState:UIControlStateNormal];
                [send_my_location setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [contentView addSubview:send_my_location];
                
                UIButton* hide_me =[UIButton buttonWithType:UIButtonTypeSystem];
                [hide_me setFrame:CGRectMake(140, 155, 60, 44)];
                [hide_me setTitle:@"对他隐身" forState:UIControlStateNormal];
                [hide_me setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [contentView addSubview:hide_me];
                
                [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];

            }];
            
            customPinView.rightCalloutAccessoryView = rightButton;
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    else
        return nil;
    
}
-(void)showDetail{
    }

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"annoSelected");// 对话，足迹，路线
   
}


#pragma mark - MKMapViewDelegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    NSLog(@"%f-----%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    //停止定位
    [_manager stopUpdatingLocation];
  
    // 上传经纬度
    CLLocationCoordinate2D lo = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
//     NSLog(@"前%f",lo.latitude);
    lo = [self hhTrans_bdGPS:lo];
      NSLog(@"后%f",lo.latitude);
    NSString* str1 = [NSString stringWithFormat:@"%f",lo.latitude];
    NSString* str2 = [NSString stringWithFormat:@"%f",lo.longitude];
    // 上传坐标
    [self uploadGPSWith_latitude:str1 longitude:str2];
    
   
}



//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败");
    [ProgressHUD showError:@"定位失败"];
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(39.915352,116.397105);
        
    float zoomLevel = 0.2;
    MKCoordinateRegion region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
   
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  - rotate
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

#pragma mark - BASE FUNCTION

// 导航栏左侧按钮触发的事件
-(void)leftButtonEvent:(UIBarButtonItem*)sender{
   //
    if ([sender.title isEqualToString:@"登录"]) {
        NSLog(@"登录");
        UIStoryboard* sbd = nil;
        if (IS_IPHONE) {
            sbd  = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        }
        if (IS_IPAD) {
            sbd = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        }
        LoginViewController* login = [sbd instantiateViewControllerWithIdentifier:@"login"];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:login];
        
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        NSLog(@"设置");
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
  
}


// 设置导航栏右侧按钮
-(void)setupRightMenuButton{
    
    // 导航栏左侧按钮设置
    // 判断是否登录，如果没有登录，按钮标题为“登录”，如果登录了，按钮标题为“设置”
    NSString* left_bar_button_titile = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"id"]) {
        left_bar_button_titile = @"设置";
        UIButton* rentou_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rentou_btn setImage:[UIImage imageNamed:@"rentou.png"] forState:UIControlStateNormal];
        [rentou_btn setFrame:CGRectMake(0, 0, 40, 40)];
        UIBarButtonItem* bar_button = [[UIBarButtonItem alloc] initWithCustomView:rentou_btn];
        self.navigationItem.leftBarButtonItems = @[bar_button];
        [rentou_btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        }];
        // 最右侧按钮
        MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];
        [rightDrawerButton setMenuButtonColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        // 倒数第三个按钮
        UIButton* refresh_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [refresh_btn setImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
        [refresh_btn setFrame:CGRectMake(0, 0, 25, 25)];
        UIBarButtonItem* ref = [[UIBarButtonItem alloc] initWithCustomView:refresh_btn];
        [refresh_btn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
        
//        UIBarButtonItem* refresh = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleBordered target:self action:@selector(refresh)];
//        [refresh setTintColor:[UIColor whiteColor]];
        [self.navigationItem setRightBarButtonItems:@[rightDrawerButton,ref] animated:YES];
        
  //   UIModalTransitionStyleFlipHorizontal
        
    }
    else{
        left_bar_button_titile = @"登录";
        UIBarButtonItem* f = [[UIBarButtonItem alloc] initWithTitle:left_bar_button_titile style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonEvent:)];
        [f setTintColor:[UIColor whiteColor]];
        
        self.navigationItem.leftBarButtonItems = @[f];
        

    }
   
    
    
    
}



// 定位
-(void)loadGPS{
    
    [_mapView setMapType:MKMapTypeStandard];
    CLLocationManager* currentLocation = [[CLLocationManager alloc] init];
    _manager = currentLocation;
    
    if([CLLocationManager locationServicesEnabled])
    {
        _manager.delegate = self;
        _manager.distanceFilter = kCLDistanceFilterNone;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        [_manager startUpdatingLocation];
    }
    [_mapView setShowsUserLocation:YES];
    
}


// 上传GPS
-(void)uploadGPSWith_latitude:(NSString*)_la  longitude:(NSString*)_lo
{
    NSUserDefaults* userD = [NSUserDefaults standardUserDefaults];
    NSString* id = [userD objectForKey:@"id"];
    
    NSString* url = [NSString stringWithFormat:@"%@&userid=%@&latitude=%@&longitude=%@",UPLOAD_LOCATION,id,_la,_lo];
    NSLog(@"***********%@",url);
    ASIFormDataRequest* req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    _upload_location_request = req;
    if (_upload_location_request) {
        [_upload_location_request startAsynchronous];
        [_upload_location_request setCompletionBlock:^{
            NSLog(@"上传坐标返回值%@",[_upload_location_request responseString]);
            if ([[_upload_location_request responseString] isEqualToString:@"1"]) {
                NSLog(@"上传坐标成功");
            }
        }];
        [_upload_location_request setFailedBlock:^{
            NSLog(@"上传坐标返回值%@",[_upload_location_request responseString]);
            
        }];
    }
    
    
}

-(void)deleteAnnos{
    [_mapView removeAnnotations:_list];
}


// 遍历添加标注
-(void)addAnnos{
    NSUserDefaults* userD = [NSUserDefaults standardUserDefaults];
    NSString* myname = [userD objectForKey:@"currentPerson"];
    NSString* myid = [userD objectForKey:@"id"];
    
    ASIFormDataRequest* req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:ALL_LOCATION  ]];
    _all_location_request = req;
    [_all_location_request startAsynchronous];
    
    [_all_location_request setCompletionBlock:^{
        NSString* str = [_all_location_request responseString];
      
        SBJsonParser* sb = [[SBJsonParser alloc] init];
        NSArray* list = [sb objectWithString:str];
        NSMutableArray* annoArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSString* all_forbidden = nil; // |zhaojian|字符串（我那条数据的forbidden字段）
        
        if (list) {
            for (id item in list) {
                if ([[item objectForKey:@"user_id"] isEqualToString:myid]) { // 查看我那条数据，是否有人不让我看见
                    
                    all_forbidden =[item objectForKey:@"forbidden"];
                    _fobiddenInMyItem = all_forbidden;
                    break;
                }
            }
        }
        NSLog(@"%@",_fobiddenInMyItem);
        
        // 遍历list
        if (list) {
            NSLog(@"%d",list.count);
            for (id item in list) {
                
                NSString* name = [item objectForKey:@"name"];
                NSString* user_id = [item objectForKey:@"user_id"];
                user_id = [NSString stringWithFormat:@"|%@|",user_id];
                // 判断朋友id是否存在于我那条forbidden字符串中,如果不存在才去添加到数组中
              //  if ([all_forbidden rangeOfString:user_id].location == NSNotFound) {
                    
                    NSString* time = [item objectForKey:@"last_update"];
                    NSString* lati = [item objectForKey:@"user_latitude"];
                    NSString* logi = [item objectForKey:@"user_longitude"];
                    id forbidden = [item objectForKey:@"forbidden"];
                    
                    // 判断每个人的状态
                    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
                    if ([user objectForKey:name]) {
                        
                    }else{
                        [user setValue:@"YES" forKey:name];
                        
                    }
                    
                    CLLocationCoordinate2D lo = CLLocationCoordinate2DMake([lati doubleValue],[logi doubleValue]);
                    lo = [self hhTrans_GCGPS:lo];// 百度坐标转为GPS坐标
                    MapPoint* mmp = [[MapPoint alloc] initWithCoordinate2D:lo];
                    mmp.title = name;
                    mmp.subtitle = time;
                    
                    NSLog(@"gps坐标%f,%f",lo.latitude,lo.longitude);
                    // 是否自己被他人屏蔽
                    // 先看enable 再看forbidden,
                    if ([[item objectForKey:@"enable"] isEqualToString:@"2"] || [myname isEqualToString:name]){ // 不显示
                        
                    }
                    
                    else{
                        
                        if ([[user objectForKey:name] isEqualToString:@"YES"]) {
                            [_mapView addAnnotation:mmp] ;
                        }
                        [_friendIDs addObject:user_id];
                        [annoArray addObject:mmp];
                        [_forbiddenList addObject:forbidden];// forbidden列表
                    }
                    
                    
               // }
                
            }
            _list = annoArray;
            if (_list.count!=0) {
                NSLog(@"数组长度：%d",_list.count);
                [ProgressHUD showSuccess:nil];
            }
        }
    }];
    
    [_all_location_request setFailedBlock:^{
        NSString* str = [_all_location_request responseString];
        NSLog(@"查询所有人坐标返回数据%@",str);
    }];
    
    
}


// 添加一个标注
-(void)addAnno:(NSNotification*)info{
    NSDictionary* dict = info.userInfo;
    if (_list && dict && [dict objectForKey:@"name"]) {
        for (id item in _list) {
            MapPoint* map = [[ MapPoint alloc] init];
            map = item;
            
            if ([map.title isEqualToString:[dict objectForKey:@"name"]]) {
                
                [_mapView addAnnotation:map];
                
            }
        }
    }
}

// 删除一个标注
-(void)removeAnno:(NSNotification*)info {
    
    NSDictionary* dict = info.userInfo;

    if (_list && dict && [dict objectForKey:@"name"]) {
        
        for (id   item  in _list) {
            MapPoint* map = [[ MapPoint alloc] init];
            map = item;
            if ([map.title isEqualToString:[dict objectForKey:@"name"]]) {
                
                [_mapView removeAnnotation:map];
                
            }
        }
    }
}


//右侧按钮点击事件
-(void)rightDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    if (_list&& _forbiddenList&&_fobiddenInMyItem&&_friendIDs) {
        NSMutableDictionary* dict2 = [[NSMutableDictionary alloc] initWithCapacity:10];
        [dict2 setObject:_list forKey:@"list"];
        [dict2 setObject:_forbiddenList forKey:@"forbidden"];
        [dict2 setObject:_fobiddenInMyItem forKey:@"fobiddenInMyItem"];
        [dict2 setObject:_friendIDs forKey:@"friendIDs"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFriends" object:self userInfo:dict2];
    }
   
    
}

//  把火星坐标转换成百度坐标
-(CLLocationCoordinate2D)hhTrans_bdGPS:(CLLocationCoordinate2D)fireGps
{
    
    CLLocationCoordinate2D bdGps;
    
    double huo_x=fireGps.longitude;
    
    double huo_y=fireGps.latitude;
    
    double z = sqrt(huo_x * huo_x + huo_y * huo_y) + 0.00002 * sin(huo_y * x_pi);
    
    double theta = atan2(huo_y, huo_x) + 0.000003 * cos(huo_x * x_pi);
    
    bdGps.longitude = z * cos(theta) + 0.0065;
    
    bdGps.latitude = z * sin(theta) + 0.006;
    
    return bdGps;
    
}

// 百度转火星
-(CLLocationCoordinate2D)hhTrans_GCGPS:(CLLocationCoordinate2D)baiduGps
{
    
    CLLocationCoordinate2D googleGps;
    
    double bd_x=baiduGps.longitude - 0.0065;
    
    double bd_y=baiduGps.latitude - 0.006;
    
    double z = sqrt(bd_x * bd_x + bd_y * bd_y) - 0.00002 * sin(bd_y * x_pi);
    
    double theta = atan2(bd_y, bd_x) - 0.000003 * cos(bd_x * x_pi);
    
    googleGps.longitude = z * cos(theta);
    
    googleGps.latitude = z * sin(theta);
    
    return googleGps;
    
}

-(void)dealloc{
 
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"remove" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"add" object:nil];
   
}


@end
