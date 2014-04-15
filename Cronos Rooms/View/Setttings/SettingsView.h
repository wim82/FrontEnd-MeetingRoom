//
// Created by Jean Smits on 15/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GroupTitleView;
@class DetailCellView;


@interface SettingsView : UIView
@property(nonatomic, strong) GroupTitleView *userTitle;
@property(nonatomic, strong) DetailCellView *userNameDetail;

- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id)delegate;

@end