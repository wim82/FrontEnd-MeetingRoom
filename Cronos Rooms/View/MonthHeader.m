//
//  MonthHeader.m
//  Cronos Rooms
//
//  Created by Katrien De Mey on 13/04/14.
//  Copyright (c) 2014 KaWi. All rights reserved.
//

#import "MonthHeader.h"
#import "UIColor+AppColor.h"

@implementation MonthHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       // UIScreen *screen = [UIScreen mainScreen];
       // int width = screen.currentMode.size.width;
       // int height = screen.currentMode.size.height;
        self.backgroundColor = [UIColor clearColor];
        self.lblHeader = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 200,50)];
        //self.lblHeader.textAlignment = NSTextAlignmentCenter;
        self.lblHeader.font = [UIFont fontWithName:@"GillSans-Light" size:48];
        self.lblHeader.textColor = [UIColor app_darkGrey];
        
        [self addSubview:self.lblHeader];
        
    }
    return self;
}

@end
