//
//  tooles.h
//  huoche
//
//  Created by kan xu on 11-1-22.
//  Copyright 2011 paduu. All rights reserved.
//

#import <Foundation/Foundation.h> 
#import <QuartzCore/QuartzCore.h>
@interface CommonUtils : NSObject {	
	 
    UITextField *textField;

}

+ (NSString *)Date2StrV:(NSDate *)indate;
+ (NSString *)Date2Str:(NSDate *)indate;
+ (void)MsgBox:(NSString *)msg;

+ (NSDateComponents *)DateInfo:(NSDate *)indate;

+ (void)OpenUrl:(NSString *)inUrl; 
+ (NSString*) callService:(NSString*) requestType data:(NSString*)data;
+(NSString*) selfClaimService:(NSString*) requestType data:(NSString*)data;

//+(void)viewAnimation:(CALayer*)layer:(id)delegate:(NSString*)type:(NSString*)subtype;

+(NSArray*)splitBySep:(NSString*)formatString; ///分隔符是"|"，并且字符串要以“|” 结尾。

@end


@interface AlertPrompt : UIAlertView 
{
    UITextField *textField;
}
@property (nonatomic, strong) UITextField *textField;
@property (strong, readonly) NSString *enteredText;
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;
@end
