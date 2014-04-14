//
// Created by Jean Smits on 14/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import "DayTitleView.h"
#import "NSDate+Helper.h"
#import "UIColor+AppColor.h"


@implementation DayTitleView {

}

- (instancetype)initWithFrame:(CGRect)frame andDate:(NSDate *)date {
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"ok");
        self.backgroundColor = [UIColor app_grey];
        self.dayNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
        self.dayNameLabel.font =  [UIFont fontWithName:@"Futura-Medium" size:14.0];
        self.dayNameLabel.textAlignment = NSTextAlignmentCenter;
        self.dayNameLabel.backgroundColor = [UIColor clearColor];
        self.dayNameLabel.textColor = [UIColor app_snowWhite];
        self.dayNameLabel.text = [date stringWithFormat:DATEFORMAT_DAYNAME_AND_SHORT_DATE];
        [self addSubview:self.dayNameLabel];

        self.previousButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 44, 44)];
        self.previousButton.titleLabel.text =  @"<--";
        self.previousButton.titleLabel.textColor = [UIColor app_snowWhite];
        self.previousButton.backgroundColor = [UIColor clearColor];

        [self addSubview:self.previousButton];


        self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 56, 0, 44, 44)];
        self.nextButton.titleLabel.text =  @"---->";
        self.nextButton.titleLabel.textColor = [UIColor app_snowWhite];
        self.nextButton.backgroundColor = [UIColor clearColor];
        [self addSubview:self.nextButton];



    }
    return self;

}
@end