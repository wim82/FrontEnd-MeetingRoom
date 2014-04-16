//
// Created by Jean Smits on 7/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainService.h"
#import "MeetingRoom.h";


@interface MeetingRoomService : MainService
+ (MeetingRoomService *)sharedService;

- (void)getAllMeetingRoomsWithSuccessHandler:(void (^)(NSMutableArray *))success andErrorHandler:(void (^)(NSException *))error;
- (void)getAvailableMeetingRoomsForStartTime:(NSDate *)startTime andEndTime:(NSDate *)endTime withSuccesHandler:(void (^)(NSMutableArray *))success andErrorHandler:(void (^)(NSException *))error;
- (void)getMeetingRoomWithRoomName:(NSString *)roomName withSuccesHandler:(void (^)(MeetingRoom *))success andErrorHandler:(void (^)(NSException *))error;
@end