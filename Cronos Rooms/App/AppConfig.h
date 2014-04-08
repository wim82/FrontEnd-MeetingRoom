//
// Created by Jean Smits on 7/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppConfig : NSObject

+ (AppConfig *)sharedAppConfig;

@property (nonatomic, strong, readonly) NSString *baseURL;
@property (nonatomic, getter = isInDemoMode, readonly) BOOL demoMode;


@end