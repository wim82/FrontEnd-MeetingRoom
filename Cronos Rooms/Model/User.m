//
// Created by Jean Smits on 7/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import "User.h"


@implementation User {

}


- (instancetype) initWithDictionary:(NSDictionary *) dictionary{
    self = [super init];
    if(self){
        self.fullName = [dictionary objectForKey:@"fullName"];
        self.userId = [[dictionary objectForKey:@"userId"] integerValue];
    }

    return self;

}

-(NSMutableDictionary *)convertToDictionary {
    
    NSMutableDictionary *userDictionary=[[NSMutableDictionary alloc]init];
    
    [userDictionary setObject:[NSString stringWithFormat:@"%i", self.userId] forKey:@"userId"];
    [userDictionary setObject:self.fullName forKey:@"fullName"];
    return userDictionary;
}

@end