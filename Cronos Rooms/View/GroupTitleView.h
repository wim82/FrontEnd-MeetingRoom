//
// Created by Jean Smits on 4/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GroupTitleView : UIView
@property(nonatomic, strong) UILabel *groupTitleLabel;
@property(nonatomic, strong) UIView *groupTitleView;

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title;
@end