//
// Created by Jean Smits on 7/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>

#define HTTP_METHOD_POST @"POST"
#define HTTP_METHOD_GET @"GET"
#define HTTP_METHOD_PUT @"PUT"
#define HTTP_METHOD_DELETE @"DELETE"
#define HTTP_HEADER_FIELD_CONTENT_TYPE @"Content-Type"
#define CONTENT_TYPE_JSON @"application/json"

@interface MainService : NSObject

@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;

- (void)addParametersToRequest:(NSMutableURLRequest *) request parameters:(NSDictionary *)params;

- (NSMutableURLRequest *)getRequestWithPath:(NSString *) pathToService;
- (NSMutableURLRequest *)postRequestWithPath:(NSString *) pathToService;
- (NSMutableURLRequest *)putRequestWithPath:(NSString *) pathToService;
- (NSMutableURLRequest *)deleteRequestWithPath:(NSString *) pathToService;


@end
