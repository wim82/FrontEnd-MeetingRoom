//
// Created by Jean Smits on 9/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import "DayView.h"



@interface DayView () {
    id _delegate;
}
@end

@implementation DayView

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