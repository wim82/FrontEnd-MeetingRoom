//
// Created by Wim Maesschalck on 6/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MeetingRoomOverview : UIView

@property(nonatomic, strong) UITableView *tableView;

- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate;

@end