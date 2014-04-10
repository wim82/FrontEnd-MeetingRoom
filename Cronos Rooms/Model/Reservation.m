//
// Created by Jean Smits on 7/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import "Reservation.h"
#import "DateHelper.h"


@implementation Reservation {

}
/*
+ (NSDateFormatter *)dateFormatter {
 static NSDateFormatter *dateFormatter = nil;

 if (dateFormatter == nil) {
     dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:@"yyyyMMdd"];
 }

 return dateFormatter;

}
  */




- (instancetype)initWithStringDictionary:(NSDictionary *)dictionary {
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.user = [[User alloc] initWithDictionary:[dictionary objectForKey:@"user"]];
        self.meetingRoom = [[MeetingRoom alloc] initWithDictionary:[dictionary objectForKey:@"meetingRoom"]];
        self.startTime = [[DateHelper datetimeFormatter] dateFromString:[dictionary objectForKey:@"startTime"]];
        self.endTime = [[DateHelper datetimeFormatter] dateFromString:[dictionary objectForKey:@"endTime"]];
       // NSLog(@"endtime in in init %@", self.endTime);
        self.reservationDescription = [dictionary objectForKey:@"description"];
    }
    return self;
}


-(NSMutableDictionary *)convertToDictionary {
    
    NSMutableDictionary *reservationDictionary = [[NSMutableDictionary alloc]init];
    
    [reservationDictionary setObject:[NSString stringWithFormat:@"%i", self.id] forKey:@"id"];
    [reservationDictionary setObject:[self.user convertToDictionary] forKey:@"user"];
    [reservationDictionary setObject:[self.meetingRoom convertToDictionary] forKey:@"meetingRoom"];
    [reservationDictionary setObject:[self createStringFromDateTime:self.startTime] forKey:@"startTime"];
    [reservationDictionary setObject:[self createStringFromDateTime:self.endTime] forKey:@"endTime"];
    [reservationDictionary setObject:self.reservationDescription forKey:@"description"];

    
    return reservationDictionary;
}

- (NSString *)createStringFromDateTime:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd HH:mm"];
    return [dateFormatter stringFromDate:date];
}



/*
- (NSDate *)date {
    return _date;
}

- (void)setDate:(NSDate *)date {
    _date = [DateHelper dateWithOutTime:date];;
}

- (NSDate *)startTime {
    return _startTime;
}

- (void)setStartTime:(NSDate *)startTime {
    _startTime = [DateHelper timeWithoutDate:startTime];;
}

- (NSDate *)endTime {
    return _endTime;
}

- (void)setEndTime:(NSDate *)endTime {
    _date = [DateHelper timeWithoutDate:endTime];;
}
  */

@end