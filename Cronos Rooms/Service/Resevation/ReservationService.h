//
// Created by Jean Smits on 7/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainService.h"
#import "Reservation.h"


@interface ReservationService : MainService


+ (ReservationService *)sharedService;
- (void)getReservationsForRoomId:(NSInteger) roomId fromDate:(NSDate *) date forAmountOfDays:(NSInteger) amount withSuccesHandler:(void (^)(NSMutableArray *))success andErrorHandler:(void (^)(NSException *))error;
- (void)getReservationsForUserId:(NSInteger) userId withSuccesHandler:(void (^)(NSMutableArray *))success andErrorHandler:(void (^)(NSException *))error;

- (void)createReservation:(Reservation*) reservation  withSuccesHandler:(void (^)(Reservation *)) success andErrorHandler:(void (^)(NSException *))error;
- (void)updateReservation:(Reservation*) reservation  withSuccesHandler:(void (^)(Reservation *)) success andErrorHandler:(void (^)(NSException *))error;
- (void)deleteReservation:(NSInteger) reservationId  withSuccesHandler:(void (^)(Reservation *)) success andErrorHandler:(void (^)(NSException *))error;

@end
