//
// Created by Jean Smits on 9/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeetingRoom.h"


@interface DayViewController : UIViewController <UIGestureRecognizerDelegate>
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, strong) MeetingRoom *meetingRoom;
@end