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
        
        self.lblHeaderTuesday = [[UILabel alloc]initWithFrame:CGRectMake(20+self.frame.size.width/8, 50, self.frame.size.width/8,50)];
        self.lblHeaderTuesday.font = [UIFont systemFontOfSize:16];
        self.lblHeaderTuesday.textColor = [UIColor grayColor];
        self.lblHeaderTuesday.text = @"Tuesday";
        [self addSubview:self.lblHeaderTuesday];

        
    }
    return self;
}

@end
