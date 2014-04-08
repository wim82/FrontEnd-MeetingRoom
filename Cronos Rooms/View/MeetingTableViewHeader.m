//
//  MeetingTableViewHeader.m
//  testProject
//
//  Created by Jean Smits on 04/04/14.
//  Copyright (c) 2014 Katrien De Mey. All rights reserved.
//

#import "MeetingTableViewHeader.h"

@implementation MeetingTableViewHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
      
        
        self.lblDate = [[UILabel alloc] initWithFrame:CGRectMake(320, 0, frame.size.width-320, 20)];
        self.lblDate.font = [UIFont italicSystemFontOfSize:15.0];
        self.lblDate.backgroundColor=[UIColor grayColor];
        [self addSubview:self.lblDate];

    }
    return self;
}



@end
