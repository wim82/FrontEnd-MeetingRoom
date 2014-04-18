//
//  MonthOverviewController.h
//  Cronos Rooms
//
//  Created by Katrien De Mey on 13/04/14.
//  Copyright (c) 2014 KaWi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingRoom.h"

@interface MonthViewController : UIViewController <UIGestureRecognizerDelegate>

@property(nonatomic, strong) NSArray *publicHolidays;
@property(nonatomic, strong) NSArray *reservationsPerRoom;
@property(nonatomic, strong) MeetingRoom *meetingRoom;
@property(nonatomic) NSInteger realWidth;
@property(nonatomic, strong) UIImageView *backGroundImage;
@end
