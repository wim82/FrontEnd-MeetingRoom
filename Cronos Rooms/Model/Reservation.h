//
// Created by Jean Smits on 7/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "MeetingRoom.h"


@interface Reservation : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) MeetingRoom *meetingRoom;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSString *reservationDescription;
- (instancetype)initWithStringDictionary:(NSDictionary *) dictionary;
-(NSMutableDictionary *)convertToDictionary;
+ (NSDateFormatter *)dateFormatter;



@end