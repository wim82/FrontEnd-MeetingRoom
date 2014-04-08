//
//  SearchViewController.h
//  testProject
//
//  Created by Katrien De Mey on 07/04/14.
//  Copyright (c) 2014 Katrien De Mey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"


@interface SearchViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,  UISearchBarDelegate, UISearchDisplayDelegate>

/*
{
    NSMutableArray *contentList;
    NSMutableArray *filteredContentList;
    BOOL isSearching;
}
*/


@property (nonatomic,strong) Room * room1;
@property (nonatomic,strong) Room * room2;
@property (nonatomic,strong) Room * room3;
@property (nonatomic,strong) Room * room4;
@property (nonatomic,strong) Room * room5;
@property (nonatomic,strong) Room * room6;

/*
@property (strong, nonatomic) IBOutlet UITableView *tblContentList;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchBarController;
*/
 
@end
