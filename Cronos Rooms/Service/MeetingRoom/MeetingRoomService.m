//
// Created by Jean Smits on 7/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import "MeetingRoomService.h"
#import "MeetingRoom.h"


@implementation MeetingRoomService

+ (MeetingRoomService *)sharedService {
    static MeetingRoomService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[MeetingRoomService alloc] init];
        }

    });

    return instance;
}

- (void)getAllMeetingRoomsWithSuccessHandler:(void (^)(NSMutableArray *))success andErrorHandler:(void (^)(NSException *))error {

    //set path
    NSMutableURLRequest *request = [self getRequestWithPath:@"meetingrooms"];

    //init request
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [requestOperation setResponseSerializer:serializer];

    //set up failure + completion blocks
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != nil && [responseObject isKindOfClass:[NSDictionary class]]) {

            NSMutableArray *result = [[NSMutableArray alloc] init];
            for (id responseElement in [responseObject objectForKey:@"data"]) {
                MeetingRoom *meetingRoom = [[MeetingRoom alloc] initWithDictionary:responseElement];
                [result addObject:meetingRoom];
            }
            success(result);
        }
        else {
            error([NSException exceptionWithName:@"No Meeting Rooms" reason:@"Missing session id" userInfo:nil]);
        }

    }failure:^(AFHTTPRequestOperation *operation, NSError *callbackError) {
        if (error) {
            error([NSException exceptionWithName:@"Meeting Room problem: " reason:[callbackError.userInfo objectForKey:NSLocalizedDescriptionKey] userInfo:nil]);
        }
    }];

    //start request
    [self.operationManager.operationQueue addOperation:requestOperation];

}


@end