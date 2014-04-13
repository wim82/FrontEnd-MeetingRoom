//
//  PublicHolidayService.h
//  Cronos Rooms
//
//  Created by Katrien De Mey on 13/04/14.
//  Copyright (c) 2014 KaWi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainService.h"

@interface PublicHolidayService : MainService
+ (PublicHolidayService *)sharedService;
- (void)getAllPublicHolidaysWithSuccessHandler:(void (^)(NSMutableArray *))success andErrorHandler:(void (^)(NSException *))error;

@end
