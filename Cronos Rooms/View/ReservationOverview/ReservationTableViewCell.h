//
//  ReservationTableViewCell.h
//  testProject
//
//  Created by Katrien De Mey on 03/04/14.
//  Copyright (c) 2014 Katrien De Mey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface ReservationTableViewCell : SWTableViewCell



@property (nonatomic, strong) UILabel * lblDate;
@property (nonatomic, strong) UILabel * lblDescription;
@property (nonatomic, strong) UILabel * lblRoom;
@property (nonatomic, strong) UILabel * lblTime;

@end
