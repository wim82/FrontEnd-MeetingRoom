//
// Created by Jean Smits on 10/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol IReservationSelector <NSObject>

@required
- (void)didTapReservation:(Reservation *)sender;

@end