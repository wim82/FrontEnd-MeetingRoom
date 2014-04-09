//
// Created by Jean Smits on 7/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import "ReservationService.h"
#import "Reservation.h"
#import "DateHelper.h"


@implementation ReservationService {

}

+ (ReservationService *)sharedService {
    static ReservationService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[ReservationService alloc] init];
        }

    });

    return instance;
}

- (void)getReservationsForRoomId:(NSInteger)roomId fromDate:(NSDate *)date forAmountOfDays:(NSInteger)amount withSuccesHandler:(void (^)(NSMutableArray *))success andErrorHandler:(void (^)(NSException *))error {

    //set path
    NSString *dateString = [[DateHelper jsonDateFormatter] stringFromDate:date];
    NSString *path = [NSString stringWithFormat:@"reservations/meetingroom/%i/%@/%i", roomId, dateString, amount];
    NSLog(@"path = %@", path);
    NSMutableURLRequest *request = [self getRequestWithPath:path];

    //init request
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [requestOperation setResponseSerializer:serializer];

    //set up failure + completion blocks
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        if (responseObject != nil && [responseObject isKindOfClass:[NSDictionary class]]) {

            NSMutableArray *result = [[NSMutableArray alloc] init];
            for (id responseElement in [responseObject objectForKey:@"data"]) {

                Reservation *reservation = [[Reservation alloc] initWithStringDictionary:responseElement];
                [result addObject:reservation];
            }
            success(result);
        }
        else {
            //TODO: use the message from json response  --> implement this for all rest calls!!!
            error([NSException exceptionWithName:@"No Reservations Rooms" reason:@"Ditmoet ik nog uitzoeken" userInfo:nil]);
        }

    }                                       failure:^(AFHTTPRequestOperation *operation, NSError *callbackError) {
        if (error) {
            error([NSException exceptionWithName:@"Reservation problem: " reason:[callbackError.userInfo objectForKey:NSLocalizedDescriptionKey] userInfo:nil]);
        }
    }];

    //start request
    [self.operationManager.operationQueue addOperation:requestOperation];

}

- (void)getReservationsForUserId:(NSInteger)userId withSuccesHandler:(void (^)(NSMutableArray *))success andErrorHandler:(void (^)(NSException *))error {


    NSString *path = [NSString stringWithFormat:@"reservations/user/%i", userId];
    NSMutableURLRequest *request = [self getRequestWithPath:path];

    //init request
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [requestOperation setResponseSerializer:serializer];

    //set up failure + completion blocks
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != nil && [responseObject isKindOfClass:[NSDictionary class]]) {

            NSMutableArray *result = [[NSMutableArray alloc] init];
            for (id responseElement in [responseObject objectForKey:@"data"]) {
                Reservation *reservation = [[Reservation alloc] initWithStringDictionary:responseElement];
                [result addObject:reservation];
            }
            success(result);
        }
        else {
            //TODO: use the message from json response  --> implement this for all rest calls!!!
            error([NSException exceptionWithName:@"No Reservations Rooms" reason:@"Ditmoet ik nog uitzoeken" userInfo:nil]);
        }

    }                                       failure:^(AFHTTPRequestOperation *operation, NSError *callbackError) {
        if (error) {
            error([NSException exceptionWithName:@"Reservation problem: " reason:[callbackError.userInfo objectForKey:NSLocalizedDescriptionKey] userInfo:nil]);
        }
    }];

    //start request
    [self.operationManager.operationQueue addOperation:requestOperation];

}

@end