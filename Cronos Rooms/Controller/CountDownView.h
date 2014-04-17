//
//  CountDownView.h
//  Cronos Rooms
//
//  Created by Katrien De Mey on 15/04/14.
//  Copyright (c) 2014 KaWi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountDownView : UIView

@property(nonatomic, strong) UIView *countDownView;

@property(nonatomic, strong) UIView *countDownDetails;
@property(nonatomic, strong) UILabel *meetingRoomStatus;
@property(nonatomic, strong) UILabel *countDownTime;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UITableView *dayTableView;


- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id)delegate;


@end
