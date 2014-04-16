//
// Created by Jean Smits on 7/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainService.h"
#import "User.h"


@interface UserService  : MainService
+ (UserService *)sharedService;
- (void)getAllUsersWithSuccesHandler:(void (^)(NSMutableArray *))success andErrorHandler:(void (^)(NSException *))error;
- (void)getUserForFullName:(NSString *)fullName withSuccesHandler:(void (^)(User *))success andErrorHandler:(void (^)(NSException *))error;
//TODO find out if this should be a class method or an instance method
+ (User *)getDefaultUser;
@end