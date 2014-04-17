//
// Created by Jean Smits on 7/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainService.h"
#import "User.h"


@interface UserService  : MainService

//Singleton
+ (UserService *)sharedService;

//Rest Calls
- (void)getAllUsersWithSuccesHandler:(void (^)(NSMutableArray *))success andErrorHandler:(void (^)(NSException *))error;
- (void)getUserForFullName:(NSString *)fullName withSuccesHandler:(void (^)(User *))success andErrorHandler:(void (^)(NSException *))error;

//NSUserDefaults
- (User *)getDefaultUser;


@end