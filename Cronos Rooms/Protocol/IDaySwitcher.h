//
// Created by Wim Maesschalck on 4/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IDaySwitcher <NSObject>

@required
- (void)didTapPrevious;
- (void)didTapNext;

@end