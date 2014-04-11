//
//  ReservationTableViewHeader.m
//  testProject
//
//  Created by Jean Smits on 04/04/14.
//  Copyright (c) 2014 Katrien De Mey. All rights reserved.
//

#import "ReservationTableViewHeader.h"
#import "UIColor+AppColor.h"

@interface ReservationTableViewHeader ()
@property(nonatomic, strong) UIView *headerView;
@end

@implementation ReservationTableViewHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //this is superweird but it works - frame is empty when i get this

        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 32)];
        self.headerView.backgroundColor = [UIColor app_lightBlue];
        [self addSubview:self.headerView];
        self.lblDate = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, [UIScreen mainScreen].bounds.size.width, 32)];

        self.lblDate.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:14.0];
        self.lblDate.textColor = [UIColor app_snowWhite];

        [self addSubview:self.lblDate];

    }
    return self;
}


@end
