//
// Created by Jean Smits on 7/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import "Reservation.h"


@implementation Reservation {

}

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter = nil;

    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
    }

    return dateFormatter;

}

+ (NSDateFormatter *)timeFormatter{
    static NSDateFormatter *timeFormatter = nil;

    if (timeFormatter == nil) {
    timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"mm:ss"];
    }

    return timeFormatter;

}

- (instancetype)initWithStringDictionary:(NSDictionary *)dictionary {
    if (self) {
        self.id = [dictionary objectForKey:@"id"];
        self.user = [[User alloc] initWithDictionary:[dictionary objectForKey:@"user"]];
        self.meetingRoom = [[MeetingRoom alloc] initWithDictionary:[dictionary objectForKey:@"meetingRoom"]];
        self.date = [[Reservation dateFormatter] dateFromString:[dictionary objectForKey:@"date"]];
        self.startTime = [[Reservation timeFormatter] dateFromString:[dictionary objectForKey:@"startTime"]];
        self.endTime = [[Reservation timeFormatter] dateFromString:[dictionary objectForKey:@"endTime"]];
        self.reservationDescription = [dictionary objectForKey:@"description"];
    }
    return self;
}


@end