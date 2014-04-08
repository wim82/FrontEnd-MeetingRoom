//
// Created by Jean Smits on 7/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, assign) NSInteger userId;
- (instancetype) initWithDictionary:(NSDictionary *) dictionary;
@end