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



@property (nonatomic) NSMutableDictionary *meetings;
@property (nonatomic) NSMutableArray *meetingsAll;
@property (nonatomic) NSMutableArray *dates;
@property (nonatomic,strong) Meeting *meeting1;
@property (nonatomic,strong) Meeting *meeting2;
@property (nonatomic,strong) Meeting *meeting3;
@property (nonatomic,strong) Meeting *meeting4;
@property (nonatomic,strong) Meeting *meeting5;
@property (nonatomic,strong) Meeting *meeting6;
@property (nonatomic,strong) Meeting *meeting7;


//TODO
@property (nonatomic, strong) UILabel * lblDate;
@property (nonatomic, strong) UILabel * lblDescription;
@property (nonatomic, strong) UILabel * lblRoom;
@property (nonatomic, strong) UILabel * lblTime;




@end
