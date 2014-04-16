//
// Created by Jean Smits on 15/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import "SettingsView.h"
#import "GroupTitleView.h"
#import "DetailCellView.h"
#import "dimensions.h"
#import "UIColor+AppColor.h"


@implementation SettingsView

- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id)delegate {
    self = [super initWithFrame:frame];

    if (self) {

        self.backgroundColor = [UIColor app_darkGrey];
        self.userTitle = [[GroupTitleView alloc] initWithFrame:CGRectMake(0, 128, frame.size.width, DIMENSIONS_GROUP_TITLE_VIEW_HEIGHT)
                                                      andTitle:@"Settings"];
        [self addSubview:self.userTitle];


        self.userNameDetail = [[DetailCellView alloc] initWithFrame:CGRectMake(0, self.userTitle.frame.origin.y + self.userTitle.frame.size.height, frame.size.width, 64)
                                                              title:@"Name"
                                                           andValue:nil
                                                        andDelegate:self];
        self.userNameDetail.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.userNameDetail];

        self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width / 100 *20, self.userNameDetail.frame.origin.y + self.userNameDetail.frame.size.height + 40, frame.size.width / 100 * 60, 44)];
        [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [self addSubview:self.saveButton];


    }
    return self;
}

@end