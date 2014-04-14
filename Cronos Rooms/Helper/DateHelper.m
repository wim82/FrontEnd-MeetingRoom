//
// Created by Jean Smits on 8/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import "DateHelper.h"


//TODO: DELETE THIS DATEHELPER CLASS, MAKE SURE IT ISN'T USED ANYMORE   -> replace with NSDate+Helper

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



+ (NSString *)displayStringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d/M/yy"];
    return [dateFormatter stringFromDate:date];


}

+ (NSDateFormatter *)datetimeFormatter {
    static NSDateFormatter *timeFormatter = nil;

    if (timeFormatter == nil) {
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"yyyyMMdd HH:mm"];
    }

    return timeFormatter;

}

+ (NSDateFormatter *)shortDateFormatter {
    static NSDateFormatter *timeFormatter = nil;
    
    if (timeFormatter == nil) {
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    return timeFormatter;
    
}

+ (NSDateFormatter *)timeFormatter {
    static NSDateFormatter *timeFormatter = nil;

    if (timeFormatter == nil) {
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH:mm"];
    }

    return timeFormatter;

}
@end