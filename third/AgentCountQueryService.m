//
//  LoginService.c
//  MyIns
//
//  Created by zhouxianli on 11-8-18.
//  Copyright 2011年 中科软科技股份有限公司. All rights reserved.
//

#include "AgentCountQueryService.h"
#import "CommonUtils.h"

@implementation AgentCountQueryService 

-(int) queryAgentCount:(NSString *) cityCode{// password:(NSString *) password {
    NSString* requestType = @"002";
    NSMutableString *requestBody = [NSMutableString stringWithFormat:@""];
    [requestBody appendString:@"<Request>"];
    [requestBody appendString:[NSString stringWithFormat:@"<cityCode>%@</cityCode>", cityCode]];
//    [requestBody appendString:[NSString stringWithFormat:@"<password>%@</password>", password]];
    [requestBody appendString:@"</Request>"];
    NSString *result = [CommonUtils callService:requestType data:requestBody]; 
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[result dataUsingEncoding:NSUTF8StringEncoding]];  
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser setDelegate:self]; 
    //agentCount = -2;
    BOOL success = [parser parse];
	

    
	if(!success){ 
        agentCount = -1;
		NSLog(@"parser xmlData Error!!!");	 
	}  
    
    return agentCount;
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSString *element = [elementName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    currentProperty = element;
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSString *stringValue = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	NSString *element = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
    // Skip over blank elements.
    if (stringValue == nil || [stringValue isEqual:@""]) {
		return;
	}
    if([element isEqualToString:@"agentCount"]) { 
		agentCount= [stringValue intValue];
	}  
} 
@end