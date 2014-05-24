//
//  NameIndex.h
//  BaiduMapTest
//
//  Created by ZKR on 5/24/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pinyin.h"
@interface NameIndex : NSObject{

    NSString *_lastName;
    NSString *_firstName;
    NSInteger _sectionNum;
    NSInteger _originIndex;
}
@property (nonatomic, retain) NSString *_lastName;
@property (nonatomic, retain) NSString *_firstName;
@property (nonatomic) NSInteger _sectionNum;
@property (nonatomic) NSInteger _originIndex;
- (NSString *) getFirstName;
- (NSString *) getLastName;

@end
