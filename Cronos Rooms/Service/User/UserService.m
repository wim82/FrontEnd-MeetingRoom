//
// Created by Jean Smits on 7/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import "UserService.h"
#import "User.h"


@implementation UserService

+ (UserService *)sharedService {
    static UserService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[UserService alloc] init];
        }

    });

    return instance;
}

- (void)getAllUsersWithSuccesHandler:(void (^)(NSMutableArray *))success andErrorHandler:(void (^)(NSException *))error {

    //set path
    NSMutableURLRequest *request = [self getRequestWithPath:@"users"];

    //init request
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [requestOperation setResponseSerializer:serializer];

    //set up failure + completion blocks
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != nil && [responseObject isKindOfClass:[NSDictionary class]]) {

            NSMutableArray *result = [[NSMutableArray alloc] init];
            for (id responseElement in [responseObject objectForKey:@"data"]) {
                User *user = [[User alloc] initWithDictionary:responseElement];
                [result addObject:user];
            }
            success(result);
        }
        else {
            error([NSException exceptionWithName:@"No Users" reason:@"Problem with webservice" userInfo:nil]);
        }

    }failure:^(AFHTTPRequestOperation *operation, NSError *callbackError) {
        if (error) {
            error([NSException exceptionWithName:@"User problem: " reason:[callbackError.userInfo objectForKey:NSLocalizedDescriptionKey] userInfo:nil]);
        }
    }];

    //start request
    [self.operationManager.operationQueue addOperation:requestOperation];

}
@end