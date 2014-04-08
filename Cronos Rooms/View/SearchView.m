//
//  SearchView.m
//  testProject
//
//  Created by Katrien De Mey on 07/04/14.
//  Copyright (c) 2014 Katrien De Mey. All rights reserved.
//

#import "SearchView.h"


@interface SearchView(){
    id _delegate;
}
@end


@implementation SearchView


- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        
        //self.backgroundColor = [UIColor redColor];
        
        self.searchTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.searchTableView.delegate = _delegate;
        self.searchTableView.dataSource = _delegate;
        
        
        [self addSubview:self.searchTableView];
        
        
        
        
    }
    return self;
}


@end
