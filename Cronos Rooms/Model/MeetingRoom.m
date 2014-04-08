//
// Created by Jean Smits on 7/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import "MeetingRoom.h"


@implementation MeetingRoom {

}

- (instancetype) initWithDictionary:(NSDictionary *) dictionary{
    self = [super init];
    if(self){
        self.roomId = [dictionary objectForKey:@"roomId"];
        self.roomName = [dictionary objectForKey:@"roomName"];
        self.buildingName = [dictionary objectForKey:@"buildingName"];
    }

    return self;

}

@end