//
// Created by Jean Smits on 4/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reservation.h"


@interface EditReservationViewController : UIViewController
@property(nonatomic, strong) MeetingRoom *currentMeetingRoom;
@property(nonatomic, strong) NSMutableArray *meetingRooms;
@property(nonatomic, strong) Reservation *reservation;
@property(nonatomic, strong) id delegate;

@end