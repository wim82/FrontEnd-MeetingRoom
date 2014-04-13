//
// Created by Wim Maesschalck on 13/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import "CustomSearchDisplayController.h"


@implementation CustomSearchDisplayController


- (id)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController {
    self = [super initWithSearchBar:searchBar contentsController:viewController];
    if (self) {
              //extra init code necessary?
    }

    return self;
}


- (void)setActive:(BOOL)visible animated:(BOOL)animated {
    [super setActive:visible animated:YES];
    //always show navigation controller in searchview
    [self.searchContentsController.navigationController setNavigationBarHidden:NO animated:NO];
}



@end