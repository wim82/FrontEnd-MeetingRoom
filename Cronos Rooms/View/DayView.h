//
// Created by Jean Smits on 9/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DayView : UIView

@property(nonatomic, strong) UITableView *dayTableView;

- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate;

@end