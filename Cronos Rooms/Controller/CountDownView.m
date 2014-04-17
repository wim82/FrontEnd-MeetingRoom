//
//  CountDownView.m
//  Cronos Rooms
//
//  Created by Katrien De Mey on 15/04/14.
//  Copyright (c) 2014 KaWi. All rights reserved.
//

#import "CountDownView.h"
#import "UIColor+AppColor.h"

@interface CountDownView (){
    id _delegate;
}
@end


@implementation CountDownView

- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;

        self.countDownView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
       // self.countDownView.backgroundColor = [UIColor app_darkGrey];
        [self addSubview:self.countDownView];


        self.countDownDetails = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
        [self addSubview:self.countDownDetails];


        self.meetingRoomStatus = [[UILabel alloc] initWithFrame:CGRectMake(44, 480, 980, 150)];
        self.meetingRoomStatus.textColor = [UIColor whiteColor];
        self.meetingRoomStatus.font = [UIFont fontWithName:@"GillSans-Light" size:36];

        [self.countDownDetails addSubview:self.meetingRoomStatus];


        self.countDownTime = [[UILabel alloc] initWithFrame:CGRectMake(44, 500, 980, 200)];
        self.countDownTime.textColor = [UIColor whiteColor];
        self.countDownTime.font = [UIFont fontWithName:@"GillSans-LightItalic" size:48];


        [self.countDownDetails addSubview:self.countDownTime];



        
        
      //  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(1024-(1024/3), 0, 1024/3, 768) style:UITableViewStylePlain];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(1024, 0, 1024/3, 768) style:UITableViewStylePlain];
        self.tableView.delegate = _delegate;
       self.tableView.dataSource = _delegate;
       [self addSubview:self.tableView];
        
        self.dayTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 700, 20, 1024-1024/3) style:UITableViewStylePlain];
        self.dayTableView.delegate = _delegate;
        self.dayTableView.dataSource = _delegate;
        [self addSubview:self.dayTableView];

        
        
        
    }
    return self;
}


@end
