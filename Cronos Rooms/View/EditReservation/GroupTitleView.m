//
// Created by Jean Smits on 4/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import "GroupTitleView.h"
#import "UIColor+AppColor.h"



@implementation GroupTitleView
- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor app_ultraLightGrey];
        self.groupTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, self.groupTitleView.frame.size.height-1, self.groupTitleView.frame.size.width, 1);
        bottomBorder.backgroundColor = [UIColor app_lightGrey].CGColor;
        [self.groupTitleView.layer addSublayer:bottomBorder];
        [self addSubview:self.groupTitleView];

        self.groupTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, frame.size.width, 24)];
        self.groupTitleLabel.textColor = [UIColor darkGrayColor];
        self.groupTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        self.groupTitleLabel.text = [title uppercaseString];
        //self.descriptionLabel.hidden = YES;
        [self.groupTitleView addSubview:self.groupTitleLabel];


    }
    return self;
}
@end