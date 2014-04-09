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

@end