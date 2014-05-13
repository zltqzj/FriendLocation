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
#import "LeftViewController.h"
#import "LoginViewController.h"
typedef NS_ENUM(NSInteger, MMCenterViewControllerSection){
    MMCenterViewControllerSectionLeftViewState,
    MMCenterViewControllerSectionLeftDrawerAnimation,
    MMCenterViewControllerSectionRightViewState,
    MMCenterViewControllerSectionRightDrawerAnimation,
};

#define PI 3.14159265358979323846264338327950288
const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
static int zoom_level = 1;
@interface ViewController ()
@property (nonatomic,assign) CGRect openFrame;
@property (nonatomic,assign) CGRect closeFrame;
@property (nonatomic,assign) CGRect openFrameBottom;
@property (nonatomic,assign) CGRect closeFrameBottom;
@end

#define OFFSET 150

@implementation ViewController
@synthesize m_mapView;
@synthesize m_currentLocation;
@synthesize list = _list;
@synthesize m_WaitingAlert, indicator;
@synthesize animationLayer, m_pathLayer;
@synthesize upload_location_request = _upload_location_request;
@synthesize prjSelect;
@synthesize isLoaded;
@synthesize all_location_request = _all_location_request;
@synthesize m_timer;
@synthesize manager = _manager;
@synthesize getMyPermisson = _getMyPermisson;
@synthesize uploadGPS_timer = _uploadGPS_timer;
// 导航栏右侧按钮触发的事件
-(void)back{

    UIStoryboard* sbd = nil;
    if (IS_IPHONE) {
        sbd  = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    }
    if (IS_IPAD) {
        sbd = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    }
    LoginViewController* login = [sbd instantiateViewControllerWithIdentifier:@"login"];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:login];
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}


// 设置导航栏右侧按钮
-(void)setupRightMenuButton{
    
    // 导航栏左侧按钮设置
    UIBarButtonItem* f = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    [f setTintColor:[UIColor blackColor]];
    
    self.navigationItem.leftBarButtonItems = @[f];
    
    // 最右侧按钮
    MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];
    [rightDrawerButton setMenuButtonColor:[UIColor blackColor] forState:UIControlStateNormal];
  
    
    

  
    
    // 倒数第三个按钮
    UIBarButtonItem* refresh = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleBordered target:self action:@selector(refresh)];
    [refresh setTintColor:[UIColor blackColor]];
    
    [self.navigationItem setRightBarButtonItems:@[rightDrawerButton,refresh] animated:YES];
    
   
}

-(void)refresh{
    NSLog(@"刷新");
   // [_list removeAllObjects];
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

// 初始化地图
-(void)initMap{
     self.title = @"朋友定位";
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setTintColor:)]) {
         [self.navigationController.navigationBar setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav.png"]]];
        
    }
    _list = [[NSMutableArray alloc] initWithCapacity:10];
    _manager.delegate = self;
    
    // 添加地图
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _mapView.mapType = MKMapTypeStandard;

    [self.view addSubview:_mapView];
    if ([CLLocationManager locationServicesEnabled]) {
        _mapView.showsUserLocation = YES;
        _mapView.delegate = self;
        [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    }
   
    [self addAnnos]; // 添加所有标注
    
    [self setupRightMenuButton];  // 显示导航栏右侧按钮
    
    [self showUserLocation];  //zoom到四环效果
    
    [NSThread detachNewThreadSelector:@selector(loadGPS) toTarget:self withObject:nil];

    
}

-(void)zoomMap
{
   // zoom_level += 1;
   CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(39.915352,116.397105);
    //缩放比例
    MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.2);
    //确定要显示的区域
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [_mapView  setCenterCoordinate:coordinate zoomLevel:zoom_level animated:NO];
    //让地图显示这个区域
    [_mapView setRegion:region animated:YES];

    [m_timer invalidate];
   
   
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAnno:) name:@"remove" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAnno:) name:@"add" object:nil];
    
    [self initMap]; // 初始化地图
   
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

#pragma mark - 自己定义的方法
-(void)deleteAnnos{
    [_mapView removeAnnotations:_list];
}


// 遍历添加标注
-(void)addAnnos{
        ASIFormDataRequest* req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:ALL_LOCATION]];
        _all_location_request = req;
        [_all_location_request startAsynchronous];
        
        [_all_location_request setCompletionBlock:^{
            NSString* str = [_all_location_request responseString];
            NSLog(@"查询所有人坐标返回数据%@",str);
            SBJsonParser* sb = [[SBJsonParser alloc] init];
            NSArray* list = [sb objectWithString:str];
            NSMutableArray* annoArray = [[NSMutableArray alloc] initWithCapacity:0];
            // 遍历list
            if (list) {
                
                    for (id item in list) {
                        NSString* name = [item objectForKey:@"name"];
                        NSString* time = [item objectForKey:@"last_update"];
                        NSString* lati = [item objectForKey:@"user_latitude"];
                        NSString* logi = [item objectForKey:@"user_longitude"];
                        NSLog(@"查询到的好友名称%@",time);
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
 
                        if ([[user objectForKey:name] isEqualToString:@"YES"]) {
                             [_mapView addAnnotation:mmp];
                        }
                        
                        [annoArray addObject:mmp];
    
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


// 删除一个标注
-(void)removeAnno:(NSNotification*)info {
    
    NSDictionary* dict = info.userInfo;
    
    NSLog(@"收到删除通知了%@",[dict objectForKey:@"name"]);
    if (_list && dict && [dict objectForKey:@"name"]) {

        for (id item in _list) {
            MapPoint* map = [[ MapPoint alloc] init];
            map = item;
            if ([map.title isEqualToString:[dict objectForKey:@"name"]]) {
                NSLog(@"相同");
                [_mapView removeAnnotation:map];
            }
        }
    }
}

// 添加一个标注
-(void)addAnno:(NSNotification*)info{
    NSDictionary* dict = info.userInfo;
    
    NSLog(@"收到添加通知了%@",[dict objectForKey:@"name"]);
    if (_list && dict && [dict objectForKey:@"name"]) {
        for (id item in _list) {
            MapPoint* map = [[ MapPoint alloc] init];
            map = item;
            if ([map.title isEqualToString:[dict objectForKey:@"name"]]) {
                NSLog(@"相同");
                [_mapView addAnnotation:map];
            }
        }
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


// 定时器、zoom效果，定时上传GPS
-(void)showUserLocation
{
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(zoomMap) userInfo:nil repeats:YES];
    _uploadGPS_timer= [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(loadGPS) userInfo:nil repeats:YES];
}

-(void)showDetail  // 标注点击事件
{
    
}

#pragma mark - MKMapViewDelegate

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        ((MKUserLocation *)annotation).title = @"当前位置";
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
            customPinView.pinColor = MKPinAnnotationColorPurple;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
           // NSLog(@"副标题%@",[annotation subtitle]);
            
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
            [rightButton addTarget:self
                            action:@selector(showDetail)
                  forControlEvents:UIControlEventTouchUpInside];
            
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

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"annoSelected");
}




#pragma mark - MKMapViewDelegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    m_currentLocation = userLocation;
    NSLog(@"%f-----%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    //停止定位
    [_manager stopUpdatingLocation];
  
    // 上传经纬度
    CLLocationCoordinate2D lo = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
     NSLog(@"前%f",lo.latitude);
    lo = [self hhTrans_bdGPS:lo];
      NSLog(@"后%f",lo.latitude);
    NSString* str1 = [NSString stringWithFormat:@"%f",lo.latitude];
    NSString* str2 = [NSString stringWithFormat:@"%f",lo.longitude];
    // 上传坐标
    [self uploadGPSWith_latitude:str1 longitude:str2];
   
}




#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //当前的位置
    CLLocation* newLocation = [locations lastObject];
    NSLog(@"GPS：%f",newLocation.coordinate.latitude);
    _manager = manager;
    
    CLLocationCoordinate2D lo = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
   
    lo = [self hhTrans_bdGPS:lo];
  
    NSString* str1 = [NSString stringWithFormat:@"%f",lo.latitude];
    NSString* str2 = [NSString stringWithFormat:@"%f",lo.longitude];
    
     // 上传坐标  （这里会与正常GPS坐标不同）
  //  [self uploadGPSWith_latitude:str1 longitude:str2];
    
    
   
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败");
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


//右侧按钮点击事件
-(void)rightDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
 
    NSMutableDictionary* dict2 = [[NSMutableDictionary alloc] initWithCapacity:10];
    [dict2 setObject:_list forKey:@"list"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFriends" object:self userInfo:dict2];
    
}

-(void)doubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideLeft completion:nil];
}

-(void)twoFingerDoubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideRight completion:nil];
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

@end
