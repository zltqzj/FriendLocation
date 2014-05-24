//
//  NameIndex.m
//  BaiduMapTest
//
//  Created by ZKR on 5/24/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import "NameIndex.h"

@implementation NameIndex
@synthesize _firstName, _lastName;
@synthesize _sectionNum, _originIndex;

- (NSString *) getFirstName {
    if ([_firstName canBeConvertedToEncoding: NSASCIIStringEncoding]) {//如果是英文
        return _firstName;
    }
    else { //如果是非英文
        return [NSString stringWithFormat:@"%c",pinyinFirstLetter([_firstName characterAtIndex:0])];
    }
    
}
- (NSString *) getLastName {
    if ([_lastName canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        return _lastName;
    }
    else {
        return [NSString stringWithFormat:@"%c",pinyinFirstLetter([_lastName characterAtIndex:0])];
    }
    
}

@end
