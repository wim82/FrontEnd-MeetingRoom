//
//  ReservationTableViewHeader.m
//  testProject
//
//  Created by Jean Smits on 04/04/14.
//  Copyright (c) 2014 Katrien De Mey. All rights reserved.
//

#import "ReservationTableViewHeader.h"

@implementation ReservationTableViewHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //this is superweird but it works
        self.lblDate = [[UILabel alloc] initWithFrame:CGRectMake(330, 0, frame.size.width-310, 24)];

        self.lblDate.font = [UIFont italicSystemFontOfSize:15.0];
        self.lblDate.backgroundColor=[UIColor grayColor];
        [self addSubview:self.lblDate];

    }
    return self;
}



@end
