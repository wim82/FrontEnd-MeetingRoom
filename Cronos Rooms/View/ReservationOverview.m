//
//  ReservationOverview.m
//  testProject
//
//  Created by Katrien De Mey on 03/04/14.
//  Copyright (c) 2014 Katrien De Mey. All rights reserved.
//

#import "ReservationOverview.h"

@interface ReservationOverview (){
    id _delegate;
}
@end


@implementation ReservationOverview


- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        
       // self.backgroundColor = [UIColor redColor];
        
        self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.delegate = _delegate;
        self.tableView.dataSource = _delegate;
        
        
        [self addSubview:self.tableView];
    
       
        
        
    }
    return self;
}






@end
