//
// Created by Jean Smits on 14/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IDaySwitcher;


@interface DayTitleView : UIView

@property (nonatomic, strong) UILabel *dayNameLabel;
@property (nonatomic, strong) UIButton *previousButton;
@property (nonatomic, strong) UIButton *nextButton;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<IDaySwitcher>) delegate andDate:(NSDate *)date;

@end