#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MapAddress : NSObject

+ (NSString *) getBaiduAddress:(CLLocation *)location;
+ (NSString *) getGoogleAddress:(CLLocation *)location;
@end