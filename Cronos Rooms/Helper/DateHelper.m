//
// Created by Jean Smits on 8/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import "DateHelper.h"


@implementation DateHelper {

}

+ (NSDateFormatter *)jsonDateFormatter {
    static NSDateFormatter *dateFormatter = nil;

    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
    }

    return dateFormatter;

}

+ (NSDate *)dateWithOutTime:(NSDate *)date {
    if (date == nil ) {
        date = [NSDate date];
    }
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)timeWithoutDate:(NSDate *)time {
    if (time == nil ) {
        time = [NSDate date];
    }

    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:time];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}


+ (NSString *)displayStringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d/M/yy"];
    return [dateFormatter stringFromDate:date];


}

- (NSDateFormatter *)timeFormatter {
    static NSDateFormatter *timeFormatter = nil;

    if (timeFormatter == nil) {
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"mm:ss"];
    }

    return timeFormatter;

}
@end