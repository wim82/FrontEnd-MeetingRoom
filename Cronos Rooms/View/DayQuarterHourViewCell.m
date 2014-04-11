//
// Created by Jean Smits on 9/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import "DayQuarterHourViewCell.h"
#import "UIColor+Expanded.h"
#import "IReservationSelector.h"
#import "UIColor+AppColor.h"

@interface DayQuarterHourViewCell ()


@end

@implementation DayQuarterHourViewCell {
    id <IReservationSelector> _delegate;
}

//TODO: convert hardcoded numbers to constants
- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id <IReservationSelector>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        self.backgroundColor = [UIColor clearColor];


        //hour
        self.hourTitle = [[UILabel alloc] initWithFrame:CGRectMake(6, -8, 64, 16)];
        self.hourTitle.textColor = [UIColor app_grey];
        [self.hourTitle setFont: [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]];
        [self addSubview:self.hourTitle];

        //hourly separator
        self.hourSeparator = [[UIView alloc] initWithFrame:CGRectMake(50,0,frame.size.width,0.5)];
        [self.hourSeparator setBackgroundColor:[UIColor app_blue]];
        self.hourSeparator.hidden = YES;
        [self addSubview:self.hourSeparator];

        //quarterly separator
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(54,0,frame.size.width,0.5);
        bottomBorder.backgroundColor =[[UIColor app_grey] colorWithAlphaComponent:0.2f].CGColor;
        [self.layer addSublayer:bottomBorder];

        //description of meeting
        self.reservationDescription =  [[UITextView alloc] initWithFrame:CGRectMake(50, 0, frame.size.width-50,16)];
        self.reservationDescription.scrollEnabled = NO;
        self.reservationDescription.editable = NO;
        self.reservationDescription.backgroundColor = [UIColor clearColor];
        self.reservationDescription.textContainerInset = UIEdgeInsetsMake(2, 0, 0, 0);
        [self _addGestureRecognizers];
    }
    return self;
}

- (void)_addGestureRecognizers {
    UITapGestureRecognizer *uiTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapReservation)];
    [self.reservationDescription addGestureRecognizer:uiTapGestureRecognizer];
    [self addSubview:self.reservationDescription];
}

- (void)didTapReservation {
    [_delegate didTapReservation:self.reservation];
}


//adjust the meeting description textview heigth to match the amount of quarter hours the reservation lasts
- (void)colorReservationBlockWithLength:(int)quarterHours {
    self.reservationDescription.frame =  CGRectMake(50, self.reservationDescription.frame.origin.y, self.reservationDescription.frame.size.width,quarterHours*16);
    self.reservationDescription.backgroundColor = [[UIColor app_darkYellow] colorWithAlphaComponent:0.5f];
    CALayer *leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0.0f, 0, 2, quarterHours*16);
    leftBorder.backgroundColor = [UIColor app_darkYellow].CGColor;
    [self.reservationDescription.layer addSublayer:leftBorder];

}


@end