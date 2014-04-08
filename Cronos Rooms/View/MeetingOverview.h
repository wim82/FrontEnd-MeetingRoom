//
//  MeetingOverview.h
//  testProject
//
//  Created by Katrien De Mey on 03/04/14.
//  Copyright (c) 2014 Katrien De Mey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingOverview : UIView

@property (nonatomic, strong) UITableView * tableView;
- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate;

@end
