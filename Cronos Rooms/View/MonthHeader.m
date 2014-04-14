//
//  MonthHeader.m
//  Cronos Rooms
//
//  Created by Katrien De Mey on 13/04/14.
//  Copyright (c) 2014 KaWi. All rights reserved.
//

#import "MonthHeader.h"

@implementation MonthHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       // UIScreen *screen = [UIScreen mainScreen];
       // int width = screen.currentMode.size.width;
       // int height = screen.currentMode.size.height;
        self.backgroundColor = [UIColor clearColor];
        self.lblHeader = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.frame.size.width,50)];
      
        self.lblHeader.font = [UIFont systemFontOfSize:32];
        self.lblHeader.textColor = [UIColor grayColor];
        [self addSubview:self.lblHeader];
        
        self.lblHeaderMonday = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, self.frame.size.width/8,50)];
        self.lblHeaderMonday.font = [UIFont systemFontOfSize:16];
        self.lblHeaderMonday.textColor = [UIColor grayColor];
        self.lblHeaderMonday.text = @"Monday";
        [self addSubview:self.lblHeaderMonday];
        
        self.lblHeaderTuesday = [[UILabel alloc]initWithFrame:CGRectMake(20+self.frame.size.width/8+10, 50, self.frame.size.width/8,50)];
        self.lblHeaderTuesday.font = [UIFont systemFontOfSize:16];
        self.lblHeaderTuesday.textColor = [UIColor grayColor];
        self.lblHeaderTuesday.text = @"Tuesday";
        [self addSubview:self.lblHeaderTuesday];
        
        self.lblHeaderWednesday = [[UILabel alloc]initWithFrame:CGRectMake(20+2*(self.frame.size.width/8+10), 50, self.frame.size.width/8,50)];
        self.lblHeaderWednesday.font = [UIFont systemFontOfSize:16];
        self.lblHeaderWednesday.textColor = [UIColor grayColor];
        self.lblHeaderWednesday.text = @"Wednesday";
        [self addSubview:self.lblHeaderWednesday];
        
        self.lblHeaderThursday = [[UILabel alloc]initWithFrame:CGRectMake(30+3*(self.frame.size.width/8+10), 50, self.frame.size.width/8,50)];
        self.lblHeaderThursday.font = [UIFont systemFontOfSize:16];
        self.lblHeaderThursday.textColor = [UIColor grayColor];
        self.lblHeaderThursday.text = @"Thursday";
        [self addSubview:self.lblHeaderThursday];
        
        self.lblHeaderFriday = [[UILabel alloc]initWithFrame:CGRectMake(30+4*(self.frame.size.width/8+10), 50, self.frame.size.width/8,50)];
        self.lblHeaderFriday.font = [UIFont systemFontOfSize:16];
        self.lblHeaderFriday.textColor = [UIColor grayColor];
        self.lblHeaderFriday.text = @"Friday";
        [self addSubview:self.lblHeaderFriday];
        
        self.lblHeaderSaturday = [[UILabel alloc]initWithFrame:CGRectMake(20+5*(self.frame.size.width/8+10), 50, self.frame.size.width/8,50)];
        self.lblHeaderSaturday.font = [UIFont systemFontOfSize:16];
        self.lblHeaderSaturday.textColor = [UIColor grayColor];
        self.lblHeaderSaturday.text = @"Saturday";
        [self addSubview:self.lblHeaderSaturday];
        
        self.lblHeaderSunday = [[UILabel alloc]initWithFrame:CGRectMake(20+6*(self.frame.size.width/8+10), 50, self.frame.size.width/8,50)];
        self.lblHeaderSunday.font = [UIFont systemFontOfSize:16];
        self.lblHeaderSunday.textColor = [UIColor grayColor];
        self.lblHeaderSunday.text = @"Sunday";
        [self addSubview:self.lblHeaderSunday];

        
    }
    return self;
}

@end
