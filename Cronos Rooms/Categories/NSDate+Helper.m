
#import "NSDate+Helper.h"


@implementation NSDate (Helper)


+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:string];
    return date;
}

- (NSDate *)dateWithoutTime {
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

- (NSTimeInterval)timeWithoutDate {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:self];
        NSInteger hours = [components hour];
        NSInteger minutes = [components minute];
        return (hours * 60 * 60) + (minutes * 60);

}

- (NSInteger)timeInQuarterHours {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:self];
    NSInteger hours = [components hour];
    NSInteger minutes = [components minute];
    return (hours * 4) + (minutes / 15);

}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *timestamp_str = [formatter stringFromDate:self];
    return timestamp_str;
}

@end