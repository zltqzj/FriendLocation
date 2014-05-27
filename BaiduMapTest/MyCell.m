//
//  MyCell.m
//  BaiduMapTest
//
//  Created by ZKR on 5/8/14.
//  Copyright (c) 2014 ZKR. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell
@synthesize name = _name;
@synthesize state = _state;
@synthesize onlyAppear = _onlyAppear;
@synthesize forbidden = _forbidden;
@synthesize appear_on_map_switch = _appear_on_map_switch;
@synthesize hide_me_to_him = _hide_me_to_him;
@synthesize portrait = _portrait;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
        
        // Initialization code
        NSArray* array = nil;
        if (IS_IPAD ) {
            array=[[NSBundle mainBundle]loadNibNamed:@"My_ipad" owner:self options:nil];
        }
        else if(IS_IPHONE){
            array=[[NSBundle mainBundle]loadNibNamed:@"My_iphone" owner:self options:nil];
        }
        
        MyCell *cell=[array objectAtIndex:0];
        if (cell==nil) {
            return nil;
        }
        self=cell;
    }
    return self;
}

 
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
