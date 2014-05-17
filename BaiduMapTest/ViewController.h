//
//  ViewController.h
//  BaiduMapTest
//
//  Created by ZKR on 5/6/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CommonUtils.h"
#import "MapPoint.h"
#import "MapAddress.h"
#import "RouteSearch.h"
#import "KMLParser.h"
#import "MJGeocoder.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"

#import "UIViewController+MMDrawerController.h"

#define ALL_LOCATION @"http://weixin.jsptz.com/map.php?action=getAllUserLocaltion&userid=45"
// 上传我的坐标
#define  UPLOAD_LOCATION @"http://weixin.jsptz.com/map.php?action=uploadMyLocation"

@interface ViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate> {
    MKMapView *_mapView;
    UILabel *_showLabel;
}

@property(weak,nonatomic) ASIFormDataRequest* all_location_request;
@property(weak,nonatomic) ASIFormDataRequest* upload_location_request;
@property(weak,nonatomic) ASIFormDataRequest* getMyPermisson;

@property(nonatomic, strong) MKMapView* m_mapView;
@property(nonatomic, strong) MKUserLocation* m_currentLocation;

@property (nonatomic,strong) UIActivityIndicatorView* indicator;
@property (nonatomic,strong) UIAlertView* m_WaitingAlert;

/////////////
@property (nonatomic, retain) CALayer *animationLayer;
@property (nonatomic, retain) CAShapeLayer *m_pathLayer;
/////////////
@property(strong,nonatomic) NSMutableArray* list;
@property(strong,nonatomic) NSMutableArray* forbiddenList;


//@property(assign,nonatomic) NSInteger zoom_level;
@property(assign,nonatomic) NSInteger zoom_level;

@property(strong,nonatomic)    NSTimer* m_timer;
@property(strong,nonatomic) NSTimer* uploadGPS_timer;

@property(strong,nonatomic) NSTimer* zoom_timer;

@property(strong,nonatomic)CLLocationManager* manager;


@property(strong,nonatomic) NSString* oneLatitude;
@property(strong,nonatomic) NSString* oneLogitude;

@property(strong,nonatomic) NSMutableArray* listLaLo;


@property int prjSelect;
@property BOOL isLoaded;

-(void)refresh;
 
@end
