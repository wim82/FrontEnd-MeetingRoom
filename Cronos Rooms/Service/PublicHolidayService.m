//
//  PublicHolidayService.m
//  Cronos Rooms
//
//  Created by Katrien De Mey on 13/04/14.
//  Copyright (c) 2014 KaWi. All rights reserved.
//

#import "PublicHolidayService.h"
#import "PublicHoliday.h"

@implementation PublicHolidayService

+ (PublicHolidayService *)sharedService {
    static PublicHolidayService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[PublicHolidayService alloc] init];
        }
        
    });
    
    return instance;
}

- (void)getAllPublicHolidaysWithSuccessHandler:(void (^)(NSMutableArray *))success andErrorHandler:(void (^)(NSException *))error {
    
    //set path
    NSMutableURLRequest *request = [self getRequestWithPath:@"publicholidays"];
    
    //init request
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [requestOperation setResponseSerializer:serializer];
    
    //set up failure + completion blocks
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != nil && [responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSMutableArray *result = [[NSMutableArray alloc] init];
            for (id responseElement in [responseObject objectForKey:@"data"]) {
                PublicHoliday *publicHoliday = [[PublicHoliday alloc] initWithStringDictionary:responseElement];
                [result addObject:publicHoliday];
            }
            success(result);
        }
        else {
            error([NSException exceptionWithName:@"No Public Holidays" reason:@"Missing session id" userInfo:nil]);
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *callbackError) {
        if (error) {
            error([NSException exceptionWithName:@"Public Holiday problem: " reason:[callbackError.userInfo objectForKey:NSLocalizedDescriptionKey] userInfo:nil]);
        }
    }];
    
    //start request
    [self.operationManager.operationQueue addOperation:requestOperation];
    
}




@end
