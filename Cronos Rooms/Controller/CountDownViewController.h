//
//  CountDownViewController.h
//  Cronos Rooms
//
//  Created by Katrien De Mey on 15/04/14.
//  Copyright (c) 2014 KaWi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingRoom.h"
#import "SWTableViewCell.h"

@interface CountDownViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate, UISearchBarDelegate, UISearchDisplayDelegate>{

NSTimer *timer;

}

@property (nonatomic, strong) MeetingRoom *meetingRoom;


-(void)updateCounter:(NSTimer *)theTimer;
-(void)countdownTimer;

@end
