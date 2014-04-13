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
        self.backgroundColor = [UIColor purpleColor];
        self.lblHeader = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200,50)];
        self.lblHeader.textAlignment = NSTextAlignmentCenter;
        self.lblHeader.font = [UIFont systemFontOfSize:16];
        self.lblHeader.textColor = [UIColor grayColor];
        self.lblHeader.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.lblHeader.layer.borderColor = [UIColor blueColor].CGColor;
        self.lblHeader.layer.borderWidth = 3.0;
        
        [self addSubview:self.lblHeader];
        
    }
    return self;
}

@end
