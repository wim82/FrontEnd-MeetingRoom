//
// Created by Jean Smits on 9/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import "DayView.h"
#import "UIColor+AppColor.h"



@interface DayView () {
    id _delegate;
}
@end

@implementation DayView

- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        self.dayTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];

        self.dayTableView.delegate = _delegate;
        self.dayTableView.dataSource = _delegate;
        self.dayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //self.dayTableView.backgroundColor=[[UIColor redColor] colorWithAlphaComponent:0.1];
        [self addSubview:self.dayTableView];

    }
    return self;
}

- (void)display
{
    CALayer *layer = self.layer;
    self.dayTableView.backgroundColor=[[UIColor app_ultraLightGrey] colorWithAlphaComponent:0.5];
    [layer setNeedsDisplay];
    [layer displayIfNeeded];
}

@end