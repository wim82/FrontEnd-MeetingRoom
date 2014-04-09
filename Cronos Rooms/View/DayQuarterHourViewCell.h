//
// Created by Jean Smits on 9/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DayQuarterHourViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *hourTitle;
@property (nonatomic, strong) UILabel *meetingDescription;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end