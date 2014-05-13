#import "MapAddress.h"

@implementation MapAddress

+ (NSString *) getBaiduAddress:(CLLocation *)location {
    double latitude = location.coordinate.latitude;
    double longtitude = location.coordinate.longitude;
    NSString *urlstr = [NSString stringWithFormat:
                        @"http://api.map.baidu.com/geocoder?output=json&location=%f,%f&key=dc40f705157725fc98f1fee6a15b6e60",
                        latitude, longtitude];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSString *s = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    return s;
}
+ (NSString *) getGoogleAddress:(CLLocation *)location {
    NSString *urlstr = [NSString stringWithFormat:
                        @"http://maps.google.com/maps/api/geocode/json?latlng=%f,%f&language=zh-CN&sensor=false",
                        location.coordinate.latitude, location.coordinate.longitude];
    NSLog(@"%@", urlstr);
    NSURL *url = [NSURL URLWithString:urlstr];
    NSString *s = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    return s;
}

@end