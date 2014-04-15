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

        self.backgroundColor = [UIColor app_blueGreyShaded];
        self.userTitle = [[GroupTitleView alloc] initWithFrame:CGRectMake(0, 128, frame.size.width, DIMENSIONS_GROUP_TITLE_VIEW_HEIGHT)
                                                      andTitle:@"Details"];
        [self addSubview:self.userTitle];


        self.userNameDetail = [[DetailCellView alloc] initWithFrame:CGRectMake(0, self.userTitle.frame.origin.y + self.userTitle.frame.size.height, frame.size.width, 64)
                                                              title:@"Fullname"
                                                           andValue:nil
                                                        andDelegate:self];
        self.userNameDetail.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.userNameDetail];


    }
    return self;
}

@end