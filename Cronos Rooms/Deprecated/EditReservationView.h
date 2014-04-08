//
// Created by Jean Smits on 4/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailCellView.h"
#import "GroupTitleView.h"
#import "DatePickerView.h"

@class MeetingRoomOverview;


@interface EditReservationView : UIView

@property(nonatomic, strong) DetailCellView *descriptionTextView;
@property(nonatomic, strong) DetailCellView *reservedByTextView;
@property(nonatomic, strong) GroupTitleView *detailTitleView;
@property(nonatomic, strong) GroupTitleView *timeTitleView;
@property(nonatomic, strong) GroupTitleView *roomTitleView;
@property(nonatomic, strong) DatePickerView *startDatePickerView;
@property(nonatomic, strong) DatePickerView *endDatePickerView;
@property(nonatomic, strong) MeetingRoomOverview *meetingRoomOverview;
@property(nonatomic, strong) NSArray *meetingRooms;
@property(nonatomic, strong) NSString *currentMeetingRoom;

@end