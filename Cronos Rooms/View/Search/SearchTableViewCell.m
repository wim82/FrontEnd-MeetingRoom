//
//  SearchTableViewCell.m
//  testProject
//
//  Created by Katrien De Mey on 07/04/14.
//  Copyright (c) 2014 Katrien De Mey. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "UIColor+AppColor.h"


@implementation SearchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
       self.backgroundColor=[UIColor app_snowWhite];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
