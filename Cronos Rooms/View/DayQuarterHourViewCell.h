//
// Created by Jean Smits on 9/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reservation.h"

@protocol IReservationSelector;

@interface DayQuarterHourViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *hourTitle;
@property (nonatomic, strong) UITextView *reservationDescription;
@property (nonatomic, strong) UIView *hourSeparator;
@property (nonatomic, strong) Reservation *reservation;

- (void)colorReservationBlockWithLength:(int)quarterHours;
- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id <IReservationSelector>)delegate;
@end