//
//  MonthCell.m
//  Cronos Rooms
//
//  Created by Katrien De Mey on 13/04/14.
//  Copyright (c) 2014 KaWi. All rights reserved.
//

#import "MonthCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+AppColor.h"

@implementation MonthCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        self.lblName.textAlignment = NSTextAlignmentCenter;
        self.lblName.font = [UIFont systemFontOfSize:16];
        self.lblName.textColor = [UIColor app_darkGrey];
        
        [self.contentView addSubview:self.lblName];
        
        self.lblReservations = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.frame.size.width, 70)];
        //self.lblReservations.textAlignment = NSTextAlignmentCenter;
        self.lblReservations.font = [UIFont systemFontOfSize:14];
        self.lblReservations.textColor = [UIColor app_darkGrey];
        self.lblReservations.backgroundColor=[UIColor app_darkYellow];
        
        [self.contentView addSubview:self.lblName];
        
        self.lblReservations = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, self.frame.size.width-10, 80)];
        self.lblReservations.font = [UIFont systemFontOfSize:12];
        self.lblReservations.textColor = [UIColor darkGrayColor];
        self.lblReservations.numberOfLines = 0;
        [self.contentView addSubview:self.lblReservations];
        
    }
    return self;
}

@end
