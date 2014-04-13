//
// Created by Jean Smits on 8/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DateHelper : NSObject

+ (NSDateFormatter *)jsonDateFormatter;

+ (NSString *)displayStringFromDate:(NSDate *) date;
+ (NSDate *)dateWithOutTime:(NSDate *)date;
+ (NSDate *)timeWithoutDate:(NSDate *)time;


+ (NSDateFormatter *)timeFormatter;
+ (NSDateFormatter *)datetimeFormatter;
+ (NSDateFormatter *)shortDateFormatter;

@end