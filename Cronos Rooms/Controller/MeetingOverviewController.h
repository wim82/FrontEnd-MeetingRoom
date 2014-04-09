//
//  MeetingOverviewController.h
//  testProject
//
//  Created by Katrien De Mey on 03/04/14.
//  Copyright (c) 2014 Katrien De Mey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meeting.h"
#import "SWTableViewCell.h"

@interface MeetingOverviewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
@end
