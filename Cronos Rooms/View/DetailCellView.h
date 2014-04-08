//
// Created by Jean Smits on 4/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DetailCellView : UIView

@property(nonatomic, strong) UITextField *detailTextField;
@property(nonatomic, strong) UILabel *detailLabel;
@property(nonatomic, strong) UIView *detailView;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title andValue:(NSString *)value andDelegate:(id)delegate;

@end