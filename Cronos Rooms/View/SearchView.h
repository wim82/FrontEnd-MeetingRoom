//
//  SearchView.h
//  testProject
//
//  Created by Katrien De Mey on 07/04/14.
//  Copyright (c) 2014 Katrien De Mey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchView : UIView

@property (nonatomic, strong) UITableView * searchTableView;
- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate;


@end
