//
//  ReservationOverviewController.h
//  testProject
//
//  Created by Katrien De Mey on 03/04/14.
//  Copyright (c) 2014 Katrien De Mey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

#import "User.h"



@interface ReservationOverviewController : UIViewController   //<UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
@property (nonatomic, strong) User *user;
@end
