//
// Created by Jean Smits on 7/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import "MainService.h"
#import "AppConfig.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

@implementation MainService

- (instancetype)init{
    self = [super init];
    if (self){
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        self.operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[AppConfig sharedAppConfig].baseURL]];
    }
    return self;
}

- (void)addParametersToRequest:(NSMutableURLRequest *)request parameters:(NSDictionary *)params{
    NSError *error;
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error]];

}

- (NSMutableURLRequest *)getRequestWithPath:(NSString *) pathToService{
    NSURL *url = [NSURL URLWithString:pathToService relativeToURL:self.operationManager.baseURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:HTTP_METHOD_GET];
    [request setValue:CONTENT_TYPE_JSON forHTTPHeaderField:HTTP_HEADER_FIELD_CONTENT_TYPE];
    return request;
}

- (NSMutableURLRequest *)postRequestWithPath:(NSString *) pathToService{
    NSURL *url = [NSURL URLWithString:pathToService relativeToURL:self.operationManager.baseURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:HTTP_METHOD_POST];
    [request setValue:CONTENT_TYPE_JSON forHTTPHeaderField:HTTP_HEADER_FIELD_CONTENT_TYPE];
    return request;
}

@end
