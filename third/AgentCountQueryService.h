//
//  LoginService.h
//  MyIns
//
//  Created by zhouxianli on 11-8-18.
//  Copyright 2011年 中科软科技股份有限公司. All rights reserved.
//

@interface AgentCountQueryService :NSObject <NSXMLParserDelegate>  {
    
    int agentCount; 
    NSString * currentProperty; 
}


- (int) queryAgentCount:(NSString *) cityCode;// password:(NSString *) password;

@end