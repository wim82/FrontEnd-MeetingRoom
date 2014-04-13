//
//  MonthCell.m
//  Cronos Rooms
//
//  Created by Katrien De Mey on 13/04/14.
//  Copyright (c) 2014 KaWi. All rights reserved.
//

#import "MonthCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MonthCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor greenColor];
        
        
        self.lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        self.lblName.textAlignment = NSTextAlignmentCenter;
        self.lblName.font = [UIFont systemFontOfSize:16];
        self.lblName.textColor = [UIColor redColor];
        // self.lblName.layer.backgroundColor = [UIColor cyanColor].CGColor;
        self.lblName.layer.borderColor = [UIColor redColor].CGColor;
        self.lblName.layer.borderColor=(__bridge CGColorRef)([UIColor blackColor]);
        self.lblName.layer.borderWidth = 3.0;
        
        [self.contentView addSubview:self.lblName];
        
    }
    return self;
}

@end
