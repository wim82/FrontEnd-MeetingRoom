//
// Created by Jean Smits on 7/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import "TestViewController.h"
#import "MeetingRoomService.h"
#import "UserService.h"
#import "User.h"
#import "ReservationService.h"
#import "Reservation.h"


@implementation TestViewController {

}

- (void)loadView {

    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = scrollView;
    self.navigationItem.title = @"Rest Tester";
}



- (void)viewDidLoad {


        MeetingRoomService *service = [MeetingRoomService sharedService];
    [service getAllMeetingRoomsWithSuccessHandler:^(NSMutableArray *meetingRooms) {
        for (MeetingRoom *meetingRoom in meetingRooms) {
            NSLog(@"controller check meetingroom: %@", meetingRoom.roomName);
        }

    }                             andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:exception.reason delegate:self cancelButtonTitle:@"het zou niet mogen" otherButtonTitles:nil];
        [alertView show];
    }];


    UserService *userService = [UserService sharedService];
    [userService getAllUsersWithSuccesHandler:^(NSMutableArray *users) {
        for (User *user in users){
            NSLog(@"controller check user: %@",user.fullName);
        }

    } andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error " message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];


    ReservationService *reservationService = [ReservationService sharedService];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:-60*60*24*365*3];
    [reservationService getReservationsForRoomId:1 fromDate:date forAmountOfDays:5000 withSuccesHandler:^(NSMutableArray *reservations) {
        for (Reservation *reservation  in reservations){
            NSLog(@"reservation = %@", reservation.reservationDescription);
        }

    } andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error " message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];

}




- (void)viewWillAppear:(BOOL)animated {
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end