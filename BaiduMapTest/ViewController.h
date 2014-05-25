//
//  ViewController.h
//  BaiduMapTest
//
//  Created by ZKR on 5/6/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGModal.h"
#import "MapPoint.h"
#import "MapAddress.h"

@interface ViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate> {
    MKMapView *_mapView;
   
}

@property(weak,nonatomic) ASIFormDataRequest* all_location_request;
@property(weak,nonatomic) ASIFormDataRequest* upload_location_request;
@property(weak,nonatomic) ASIFormDataRequest* getMyPermisson;

@property(strong,nonatomic) NSMutableArray* list;
@property(strong,nonatomic) NSMutableArray* forbiddenList;

@property(strong,nonatomic) NSString* fobiddenInMyItem;
@property(strong,nonatomic) NSMutableArray* friendIDs;

@property(assign,nonatomic) NSInteger zoom_level;

@property(strong,nonatomic) NSTimer* m_timer;
@property(strong,nonatomic) NSTimer* uploadGPS_timer;

@property(strong,nonatomic)CLLocationManager* manager;

-(void)refresh;
 
@end
