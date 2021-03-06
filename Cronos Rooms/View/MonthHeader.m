//
//  MonthHeader.m
//  Cronos Rooms
//
//  Created by Katrien De Mey on 13/04/14.
//  Copyright (c) 2014 KaWi. All rights reserved.
//

#import "MonthHeader.h"
#import "UIColor+AppColor.h"
#import "AppState.h"
#import "MonthOverview.h"

@implementation MonthHeader

NSInteger realWidth;
NSInteger realHeight;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.lblHeader = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, realWidth,50)];
        self.lblHeader.font = [UIFont fontWithName:@"GillSans-Light" size:48];
        self.lblHeader.textColor = [UIColor darkGrayColor];
        [self addSubview:self.lblHeader];
     
        self.lblHeaderMonday = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, realWidth/8,50)];
        self.lblHeaderMonday.font = [UIFont fontWithName:@"GillSans-Light" size:16];
        self.lblHeaderMonday.textColor = [UIColor app_grey];
        self.lblHeaderMonday.text = @"Monday";
        self.lblHeaderMonday.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lblHeaderMonday];
        
        self.lblHeaderTuesday = [[UILabel alloc]initWithFrame:CGRectMake(20+realWidth/8+10, 50, realWidth/8,50)];
        self.lblHeaderTuesday.font = [UIFont fontWithName:@"GillSans-Light" size:16];
        self.lblHeaderTuesday.textColor = [UIColor app_grey];
        self.lblHeaderTuesday.text = @"Tuesday";
        self.lblHeaderTuesday.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lblHeaderTuesday];
        
        self.lblHeaderWednesday = [[UILabel alloc]initWithFrame:CGRectMake(20+2*(realWidth/8+10), 50, realWidth/8,50)];
        self.lblHeaderWednesday.font = [UIFont fontWithName:@"GillSans-Light" size:16];
        self.lblHeaderWednesday.textColor = [UIColor app_grey];
        self.lblHeaderWednesday.text = @"Wednesday";
        self.lblHeaderWednesday.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lblHeaderWednesday];
        
        self.lblHeaderThursday = [[UILabel alloc]initWithFrame:CGRectMake(30+3*(realWidth/8+10), 50, realWidth/8,50)];
        self.lblHeaderThursday.font = [UIFont fontWithName:@"GillSans-Light" size:16];
        self.lblHeaderThursday.textColor = [UIColor app_grey];
        self.lblHeaderThursday.text = @"Thursday";
        self.lblHeaderThursday.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lblHeaderThursday];
        
        self.lblHeaderFriday = [[UILabel alloc]initWithFrame:CGRectMake(30+4*(realWidth/8+10), 50, realWidth/8,50)];
        self.lblHeaderFriday.font = [UIFont fontWithName:@"GillSans-Light" size:16];
        self.lblHeaderFriday.textColor = [UIColor app_grey];
        self.lblHeaderFriday.text = @"Friday";
        self.lblHeaderFriday.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lblHeaderFriday];
        
        self.lblHeaderSaturday = [[UILabel alloc]initWithFrame:CGRectMake(20+5*(realWidth/8+10), 50, realWidth/8,50)];
        self.lblHeaderSaturday.font = [UIFont fontWithName:@"GillSans-Light" size:16];
        self.lblHeaderSaturday.textColor = [UIColor app_grey];
        self.lblHeaderSaturday.text = @"Saturday";
        self.lblHeaderSaturday.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lblHeaderSaturday];
    
        self.lblHeaderSunday = [[UILabel alloc]initWithFrame:CGRectMake(20+6*(realWidth/8+10), 50, realWidth/8,50)];
        self.lblHeaderSunday.font = [UIFont fontWithName:@"GillSans-Light" size:16];
        self.lblHeaderSunday.textColor = [UIColor app_grey];
        self.lblHeaderSunday.text = @"Sunday";
        self.lblHeaderSunday.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lblHeaderSunday];

        
    }
    return self;
}

- (void)loadConstraintsForPortrait{
    
    if ([[AppState sharedInstance]deviceIsiPad]) {
        
        realWidth=768;
        realHeight=1024;
         NSLog(@"header rotate");
        
    } else {
        realWidth=320;
        realHeight=568;
        
    }
}

- (void)loadConstraintsForLandscape{
    
    if ([[AppState sharedInstance]deviceIsiPad]) {
        
        realWidth = 1024;
        realHeight = 768;
        NSLog(@"header rotate");
        
        
    } else {
        
        realWidth=568;
        realHeight=320;
        
    }
}



@end
