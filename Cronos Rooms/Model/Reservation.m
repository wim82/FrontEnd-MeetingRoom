//
// Created by Jean Smits on 7/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import "Reservation.h"
#import "DateHelper.h"


@implementation Reservation {

}

- (instancetype)initWithStringDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.reservationId = [[dictionary objectForKey:@"id"] integerValue];
        self.user = [[User alloc] initWithDictionary:[dictionary objectForKey:@"user"]];
        self.meetingRoom = [[MeetingRoom alloc] initWithDictionary:[dictionary objectForKey:@"meetingRoom"]];
        self.startTime = [[DateHelper datetimeFormatter] dateFromString:[dictionary objectForKey:@"startTime"]];
        self.endTime = [[DateHelper datetimeFormatter] dateFromString:[dictionary objectForKey:@"endTime"]];
        // NSLog(@"endtime in in init %@", self.endTime);
        self.reservationDescription = [dictionary objectForKey:@"description"];
    }
    return self;
}


- (NSMutableDictionary *)convertToDictionary {

    NSMutableDictionary *reservationDictionary = [[NSMutableDictionary alloc] init];

    [reservationDictionary setValue:[NSNumber numberWithInt:self.reservationId] forKey:@"id"];
    [reservationDictionary setObject:[self.user convertToDictionary] forKey:@"user"];
    [reservationDictionary setObject:[self.meetingRoom convertToDictionary] forKey:@"meetingRoom"];
    [reservationDictionary setObject:[self createStringFromDateTime:self.startTime] forKey:@"startTime"];
    [reservationDictionary setObject:[self createStringFromDateTime:self.endTime] forKey:@"endTime"];
    [reservationDictionary setObject:self.reservationDescription forKey:@"description"];

    NSLog(@"update dictionary: %@", [reservationDictionary objectForKey:@"id"]);

    return reservationDictionary;
}

- (NSString *)createStringFromDateTime:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd HH:mm"];
    return
            [dateFormatter stringFromDate:date];
}


+ (NSMutableArray *)sortByStartTime:(NSMutableArray *)reservations {
    NSArray *sortedArray;
    sortedArray = [reservations sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Reservation *) a startTime];
        NSDate *second = [(Reservation *) b startTime];
        return [first compare:second];
    }];

    return [[NSMutableArray alloc] initWithArray:sortedArray];
}


@end