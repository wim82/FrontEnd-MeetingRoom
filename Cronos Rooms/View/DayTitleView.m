//
// Created by Jean Smits on 14/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import "DayTitleView.h"
#import "NSDate+Helper.h"
#import "UIColor+AppColor.h"
#import "IDaySwitcher.h"


@implementation DayTitleView {
    id <IDaySwitcher> _delegate;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id <IDaySwitcher>)delegate andDate:(NSDate *)date {
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        self.backgroundColor = [UIColor app_grey];

        self.dayNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
        self.dayNameLabel.font = [UIFont fontWithName:@"GillSans" size:14.0];
        self.dayNameLabel.textAlignment = NSTextAlignmentCenter;
        self.dayNameLabel.backgroundColor = [UIColor clearColor];
        self.dayNameLabel.textColor = [UIColor app_snowWhite];
        self.dayNameLabel.text = [date stringWithFormat:DATEFORMAT_DAYNAME_AND_SHORT_DATE];
        [self addSubview:self.dayNameLabel];

        self.previousButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 44, 44)];
        [self.previousButton setTitle:@"<" forState:UIControlStateNormal];
        self.previousButton.titleLabel.textColor = [UIColor app_snowWhite];
        self.previousButton.backgroundColor = [UIColor clearColor];

        [self.previousButton addTarget:self action:@selector(didTapPrevious) forControlEvents:UIControlEventTouchUpInside];


        [self addSubview:self.previousButton];


        self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 56, 0, 44, 44)];
        [self.nextButton setTitle:@">" forState:UIControlStateNormal];
        self.nextButton.titleLabel.textColor = [UIColor app_snowWhite];
        self.nextButton.backgroundColor = [UIColor clearColor];
        [self.nextButton addTarget:self action:@selector(didTapNext) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.nextButton];


    }
    return self;

}

- (void)didTapPrevious {
    [_delegate didTapPrevious];
}

- (void)didTapNext {
    [_delegate didTapPrevious];
}


@end