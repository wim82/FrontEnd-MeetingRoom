//
//  PublicHoliday.h
//  Cronos Rooms
//
//  Created by Katrien De Mey on 13/04/14.
//  Copyright (c) 2014 KaWi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicHoliday : NSObject

@property (nonatomic, assign) NSInteger holidayId;
@property (nonatomic, strong) NSString *holidayName;
@property (nonatomic, strong) NSDate *holidayDate;

- (instancetype)initWithStringDictionary:(NSDictionary *) dictionary;




@end
