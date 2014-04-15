//
// Created by Jean Smits on 7/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MeetingRoom : NSObject

@property(nonatomic, strong) NSString *roomName;
@property(nonatomic, assign) NSInteger roomId;
@property(nonatomic, strong) NSString *buildingName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSMutableDictionary *)convertToDictionary;

@end