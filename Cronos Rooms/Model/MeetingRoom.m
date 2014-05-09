//
// Created by Jean Smits on 7/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import "MeetingRoom.h"


@implementation MeetingRoom {

}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.roomId = [[dictionary objectForKey:@"roomId"] integerValue];
        self.roomName = [dictionary objectForKey:@"roomName"];
       // self.buildingName = [dictionary objectForKey:@"buildingName"];
    }

    return self;

}

- (NSMutableDictionary *)convertToDictionary {

    NSMutableDictionary *meetingRoomDictionary = [[NSMutableDictionary alloc] init];

    [meetingRoomDictionary setObject:[NSString stringWithFormat:@"%i", self.roomId] forKey:@"roomId"];
    [meetingRoomDictionary setObject:self.roomName forKey:@"roomName"];
 //   [meetingRoomDictionary setObject:self.buildingName forKey:@"buildingName"];

    return meetingRoomDictionary;
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.roomName forKey:@"roomName"];
    [encoder encodeObject:[NSNumber numberWithInt:self.roomId] forKey:@"roomId"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.roomName = [decoder decodeObjectForKey:@"roomName"];
        self.roomId = [[decoder decodeObjectForKey:@"roomId"] integerValue];
    }
    return self;
}

@end