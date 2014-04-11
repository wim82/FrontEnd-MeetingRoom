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
                NSLog(@"%@", responseElement);
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
                NSLog(@"in de originele rest call: %@",reservation.reservationDescription );
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


- (void)createReservation:(Reservation*) reservation  withSuccesHandler:(void (^)(Reservation *)) success andErrorHandler:(void (^)(NSException *))error {
    NSString *path = [NSString stringWithFormat:@"reservations/create"];
    NSMutableURLRequest *request = [self postRequestWithPath:path];
    NSLog(@"in createreservation restcall : %@",reservation.startTime);
    [self addParametersToRequest:request parameters:[reservation convertToDictionary]];
    
    NSLog(@"Create Post request : %@", request);
    
    
    //init request
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    NSLog(@"serializer : %@",serializer);
    [requestOperation setResponseSerializer:serializer];
    
    //set up failure + completion blocks
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != nil && [responseObject isKindOfClass:[NSDictionary class]]) {
        
                Reservation *reservation = [[Reservation alloc] initWithStringDictionary:[responseObject objectForKey:@"data"]];
           
            success(reservation);
        }
        else {
            //TODO: use the message from json response  --> implement this for all rest calls!!!
            error([NSException exceptionWithName:@"Creation failed" reason:@"Ditmoet ik nog uitzoeken" userInfo:nil]);
        }
        
    }                                       failure:^(AFHTTPRequestOperation *operation, NSError *callbackError) {
        if (error) {
            error([NSException exceptionWithName:@"Reservation problem: " reason:[callbackError.userInfo objectForKey:NSLocalizedDescriptionKey] userInfo:nil]);
        }
    }];
    //start request
    [self.operationManager.operationQueue addOperation:requestOperation];
}


- (void)updateReservation:(Reservation*) reservation  withSuccesHandler:(void (^)(Reservation *)) success andErrorHandler:(void (^)(NSException *))error {
    NSString *path = [NSString stringWithFormat:@"reservations/update"];
    NSMutableURLRequest *request = [self putRequestWithPath:path];
    NSLog(@"in updatereservation restcall : %@",reservation.startTime);
    [self addParametersToRequest:request parameters:[reservation convertToDictionary]];
    
    NSLog(@"Update Put request : %@", request);
    
    
    //init request
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    NSLog(@"serializer : %@",serializer);
    [requestOperation setResponseSerializer:serializer];
    
    //set up failure + completion blocks
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != nil && [responseObject isKindOfClass:[NSDictionary class]]) {
            
            Reservation *reservation = [[Reservation alloc] initWithStringDictionary:[responseObject objectForKey:@"data"]];
            
            success(reservation);
        }
        else {
            //TODO: use the message from json response  --> implement this for all rest calls!!!
            error([NSException exceptionWithName:@"Creation failed" reason:@"Ditmoet ik nog uitzoeken" userInfo:nil]);
        }
        
    }                                       failure:^(AFHTTPRequestOperation *operation, NSError *callbackError) {
        if (error) {
            error([NSException exceptionWithName:@"Reservation problem: " reason:[callbackError.userInfo objectForKey:NSLocalizedDescriptionKey] userInfo:nil]);
        }
    }];
    //start request
    [self.operationManager.operationQueue addOperation:requestOperation];
}


- (void)deleteReservation:(NSInteger) reservationId  withSuccesHandler:(void (^)(Reservation *)) success andErrorHandler:(void (^)(NSException *))error {
    NSString *path = [NSString stringWithFormat:@"reservations/%i",reservationId];
    NSMutableURLRequest *request = [self deleteRequestWithPath:path];
    NSLog(@"in deletereservation restcall : %@",path);
   // [self addParametersToRequest:request parameters:[reservation convertToDictionary]];
    
    NSLog(@"Delete request : %@", request);
    
    
    //init request
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [requestOperation setResponseSerializer:serializer];
    
    //set up failure + completion blocks
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != nil && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"lukt het deleten");
            
            success(nil);
        }
        else {
            //TODO: use the message from json response  --> implement this for all rest calls!!!
            error([NSException exceptionWithName:@"Creation failed" reason:@"Ditmoet ik nog uitzoeken" userInfo:nil]);
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