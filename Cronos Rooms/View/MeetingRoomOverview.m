//
// Created by Wim Maesschalck on 6/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import "MeetingRoomOverview.h"


@interface MeetingRoomOverview () {
    id _delegate;
}
@end

@implementation MeetingRoomOverview

- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;

        self.backgroundColor = [UIColor redColor];

        self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.delegate = _delegate;
        self.tableView.dataSource = _delegate;
        [self addSubview:self.tableView];

    }
    return self;
}
@end