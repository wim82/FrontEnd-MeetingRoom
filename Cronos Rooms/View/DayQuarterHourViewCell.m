//
// Created by Jean Smits on 9/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import "DayQuarterHourViewCell.h"

@interface DayQuarterHourViewCell ()

@end

@implementation DayQuarterHourViewCell {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        /*
      //  self.backgroundColor = [UIColor groupTableViewBackgroundColor];
       // self.groupTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //CALayer *bottomBorder = [CALayer layer];
        //bottomBorder.frame = CGRectMake(0.0f, self.groupTitleView.frame.size.height - 1, self.groupTitleView.frame.size.width, 0.5f);
        //bottomBorder.backgroundColor = [UIColor grayColor].CGColor;
        [self.groupTitleView.layer addSublayer:bottomBorder];
        [self addSubview:self.groupTitleView];

        self.groupTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 30, frame.size.width, 24)];
        self.groupTitleLabel.textColor = [UIColor grayColor];
        self.groupTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        self.groupTitleLabel.text = [title uppercaseString];
        //self.descriptionLabel.hidden = YES;
        [self.groupTitleView addSubview:self.groupTitleLabel];
                   */
        self.hourTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 64, 16)];
        [self.hourTitle setBackgroundColor:[UIColor cyanColor]];
        [self addSubview:self.hourTitle];

        self.meetingDescription =  [[UILabel alloc] initWithFrame:CGRectMake(64, 0, frame.size.width-64,16)];
        self.meetingDescription.backgroundColor = [UIColor magentaColor];
        [self addSubview:self.meetingDescription];

    }
    return self;
}


@end