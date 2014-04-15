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
//@property(nonatomic, strong) UITextField *countDownTextField;
@property(nonatomic, strong) UILabel *countDownLabel;
@property (nonatomic, strong) UITableView * tableView;

- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id)delegate;


@end
