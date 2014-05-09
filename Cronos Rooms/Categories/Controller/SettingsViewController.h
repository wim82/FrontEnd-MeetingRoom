//
// Created by Jean Smits on 15/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CountDownViewController.h"
#import "User.h"

#import "ReservationOverviewController.h"


@protocol SettingsDelegate <NSObject>

@optional
- (void)shouldLaunchCountDownViewController:(CountDownViewController *)countDownViewController;
- (void)shouldLaunchReservationOverviewController:(ReservationOverviewController *)reservationOverviewController;
- (void)didChangeSettingsToDefaultUser:(User *)defaultUser;
- (void)didChangeSettingsToDefaultMeetingRoom:(MeetingRoom *)defaultMeetingRoom;
@end


@interface SettingsViewController : UIViewController
@property(nonatomic, assign) id delegate;
@end