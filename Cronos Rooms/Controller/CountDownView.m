//
//  CountDownView.m
//  Cronos Rooms
//
//  Created by Katrien De Mey on 15/04/14.
//  Copyright (c) 2014 KaWi. All rights reserved.
//

#import "CountDownView.h"

@interface CountDownView (){
    id _delegate;
}
@end


@implementation CountDownView

- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        
        _delegate = delegate;
        
        
        self.countDownView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
        self.countDownView.backgroundColor = [UIColor blueColor];
        [self addSubview:self.countDownView];
        
        
      /*  self.countDownTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, frame.size.width - 20, 5)];
        
        self.countDownTextField.backgroundColor = [UIColor blueColor];
        self.countDownTextField.textColor = [UIColor greenColor];
        
        
        [self addSubview:self.countDownTextField];  
       
       */
        
        self.countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1024, 750)];
        self.countDownLabel.backgroundColor = [UIColor redColor];
        self.countDownLabel.textColor = [UIColor blackColor];
        self.countDownLabel.font = [UIFont systemFontOfSize: 52];
        
        [self addSubview:self.countDownLabel];
        
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(1024-(1024/3), 0, 1024/3, 768) style:UITableViewStylePlain];
        self.tableView.delegate = _delegate;
       self.tableView.dataSource = _delegate;
       [self addSubview:self.tableView];
        
        
        
    }
    return self;
}


@end
