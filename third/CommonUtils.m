//
//  tooles.m
//  huoche
//
//  Created by kan xu on 11-1-22.
//  Copyright 2011 paduu. All rights reserved.
//

#import "CommonUtils.h"
#define MsgBox(msg) [self MsgBox:msg]

@implementation CommonUtils

//程序中使用的，将日期显示成  2011年4月4日 星期一
+ (NSString *) Date2StrV:(NSDate *)indate{

	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]]; //setLocale 方法将其转为中文的日期表达
	dateFormatter.dateFormat = @"yyyy '-' MM '-' dd ' ' EEEE";
	NSString *tempstr = [dateFormatter stringFromDate:indate];
	return tempstr;
}

//程序中使用的，提交日期的格式
+ (NSString *) Date2Str:(NSDate *)indate{
	
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
	dateFormatter.dateFormat = @"yyyyMMdd";
	NSString *tempstr = [dateFormatter stringFromDate:indate];
	return tempstr;	
}

//提示窗口
+ (void)MsgBox:(NSString *)msg{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg
												   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

//获得日期的具体信息，本程序是为获得星期，注意！返回星期是 int 型，但是和中国传统星期有差异
+ (NSDateComponents *) DateInfo:(NSDate *)indate{

	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | 
	NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

	comps = [calendar components:unitFlags fromDate:indate];
	
	return comps;

//	week = [comps weekday];    
//	month = [comps month];
//	day = [comps day];
//	hour = [comps hour];
//	min = [comps minute];
//	sec = [comps second];

}


//打开一个网址
+ (void) OpenUrl:(NSString *)inUrl{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:inUrl]];
}
 
+ (NSString*) callService:(NSString*) requestType data:(NSString*)data{
    NSString *urlString = [NSString stringWithFormat:@"http://218.249.118.226:11088/mobilesalesweb/interface"];
  //  NSString *urlString = [NSString stringWithFormat:@"http://192.168.20.84:8888/piccclaim/service/SelfClaimWebService/importDuty"]; 
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLCacheStorageNotAllowed];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	//set headers
	NSString *contentType = [NSString stringWithFormat:@"text/xml"];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	 
    NSString* requestUserName = [[NSUserDefaults standardUserDefaults]  stringForKey:@"userName"];  
    NSString* requestPassword = [[NSUserDefaults standardUserDefaults]  stringForKey:@"password"];
    
	NSMutableData *postBody = [NSMutableData data];
    
    [postBody appendData:[@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"<PACKET type=\"REQUEST\" version=\"1.0\">" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"<HEAD>" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"<REQUEST_TYPE>" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[requestType dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"</REQUEST_TYPE>" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"<USER>" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[requestUserName dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"</USER>" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"<PASSWORD>" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[requestPassword dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"</PASSWORD>" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"</HEAD>" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"<BODY>" dataUsingEncoding:NSUTF8StringEncoding]]; 
	[postBody appendData:[data dataUsingEncoding:NSUTF8StringEncoding]]; 
    [postBody appendData:[@"</BODY>" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"</PACKET>" dataUsingEncoding:NSUTF8StringEncoding]];
 
    
	[request setHTTPBody:postBody];
    //get response
	NSHTTPURLResponse* urlResponse = nil;  
	NSError *error = [[NSError alloc] init];  
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];  
    if ([responseData length] == 0) 
        return nil;
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSLog(@"Response Code: %d", [urlResponse statusCode]);
	if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
		NSLog(@"Response: %@", result);
	}
    else
    {
        NSString* str = [NSString stringWithFormat:@"%d", [urlResponse statusCode]];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"网络故障" 
                                                 message:str
                                                 delegate:self cancelButtonTitle:@"Cancel" 
                                                 otherButtonTitles:@"OK", nil];
        [alert show];
        
    }
    return result;
}

+(NSString*) selfClaimService:(NSString*) requestType data:(NSString*)data
{
    NSString *urlString = [NSString stringWithFormat:@"http://192.168.20.84:8888/piccclaim/service/SelfClaimWebService"];
    
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLCacheStorageNotAllowed];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	//set headers
	NSString *contentType = [NSString stringWithFormat:@"text/xml"];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
	NSMutableData *postBody = [NSMutableData data];
    
    [postBody appendData:[@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"<PACKET type=\"REQUEST\" version=\"1.0\">" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"<HEAD>" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"<REQUEST_TYPE>" dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[requestType dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"</REQUEST_TYPE>" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"</HEAD>" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"<BODY>" dataUsingEncoding:NSUTF8StringEncoding]]; 
	[postBody appendData:[data dataUsingEncoding:NSUTF8StringEncoding]]; 
    [postBody appendData:[@"</BODY>" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"</PACKET>" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
	[request setHTTPBody:postBody];
	NSHTTPURLResponse* urlResponse = nil;  
	NSError *error = [[NSError alloc] init];  
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];  
    if ([responseData length] == 0) 
        return nil;
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSLog(@"Response Code: %d", [urlResponse statusCode]);
	if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
		NSLog(@"Response: %@", result);
	}
    else
    {
        NSString* str = [NSString stringWithFormat:@"%d", [urlResponse statusCode]];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"网络故障" 
                                                       message:str
                                                      delegate:self cancelButtonTitle:@"Cancel" 
                                             otherButtonTitles:@"OK", nil];
        [alert show];
        
    }
    return result;   
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


+(NSArray*)splitBySep:(NSString *)formatString
{
    if (formatString == nil) 
        return nil;
    
    NSMutableArray* arraySplit = [[NSMutableArray alloc] initWithCapacity:0];
    NSString* s;
    NSRange range;
    while (1) {
        
        range = [formatString rangeOfString:@"|"];
        s=[formatString substringToIndex:range.location];
        [arraySplit addObject:s];
        if ([formatString rangeOfString:@"|"].location == formatString.length-1) 
            break;
        formatString = [formatString substringFromIndex:range.location+1];
        
    }
    return arraySplit;
}


@end

@implementation AlertPrompt
@synthesize textField;
@synthesize enteredText;
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle
{
    
    if (self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okayButtonTitle, nil])
    {
        UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)]; 
        [theTextField setBackgroundColor:[UIColor whiteColor]]; 
        [self addSubview:theTextField];
        self.textField = theTextField;
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 0.0); 
        [self setTransform:translate];
    }
    return self;
}
- (void)show
{
    [textField becomeFirstResponder];
    [super show];
}
- (NSString *)enteredText
{
    return textField.text;
}
@end