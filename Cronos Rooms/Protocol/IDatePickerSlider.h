//
// Created by Wim Maesschalck on 4/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IDatePickerSlider <NSObject>

@required
- (void)datePickerDidSlideOpen:(BOOL)slideOpen sentBy:(id)sender;

@end