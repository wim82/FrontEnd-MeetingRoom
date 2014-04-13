//
//  PublicHoliday.m
//  Cronos Rooms
//
//  Created by Katrien De Mey on 13/04/14.
//  Copyright (c) 2014 KaWi. All rights reserved.
//

#import "PublicHoliday.h"
#import "DateHelper.h"

@implementation PublicHoliday

- (instancetype)initWithStringDictionary:(NSDictionary *)dictionary {
    if (self) {
        self.holidayId = [[dictionary objectForKey:@"id"] integerValue];
        self.holidayName = [dictionary objectForKey:@"holidayName"] ;
        self.holidayDate = [[DateHelper shortDateFormatter] dateFromString:[dictionary objectForKey:@"holidayDate"]];
        
    }
    return self;
}







@end
