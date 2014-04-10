

#import <Foundation/Foundation.h>

@interface NSDate (Helper)

#define DATEFORMAT_SHORT_DATE @"d/M/yy"
#define DATEFORMAT_JSON @"yyyyMMdd HH:mm"
#define DATEFORMAT_SHORT_TIME @"HH:mm"
#define DATEFORMAT_SHORT_DATE_AND_SHORT_TIME @"d/M/yy    HH:mm"

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSDate *)dateWithoutTime;


@end
