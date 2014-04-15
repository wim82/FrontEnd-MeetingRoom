//
// Created by Jean Smits on 4/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IDatePickerSlider;


@interface DatePickerView : UIView
@property(nonatomic, strong) UILabel *dateTitleLabel;
@property(nonatomic, strong) UILabel *dateValueLabel;
@property(nonatomic, strong) UIView *dateView;
@property(nonatomic, strong) UIView *dateSliderView;
@property(nonatomic, strong) UIDatePicker *datePicker;
@property(nonatomic) BOOL datePickerSlideOpen;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title date:(NSDate *)date mode:(UIDatePickerMode)mode andDelegate:(id <IDatePickerSlider>)delegate;
- (void)updateDateValue;
- (void)slideDatePicker;

@end