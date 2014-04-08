//
//  SearchViewController.m
//  testProject
//
//  Created by Katrien De Mey on 07/04/14.
//  Copyright (c) 2014 Katrien De Mey. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "SearchView.h"

#define TABLEVIEWCELL_IDENTIFIER @"searchCell"
#define TABLEVIEWCELL_EMPTYIDENTIFIER @"emptySearchCell"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) SearchView  * searchView;

@property (nonatomic, strong) UISearchDisplayController * searchController;



@end

@implementation SearchViewController

NSArray *rooms;
NSArray *searchResults;

- (void)loadView{
    
    self.searchView = [[SearchView alloc] initWithFrame:[UIScreen mainScreen].bounds andDelegate:self];
    self.view = self.searchView;
    
    
    Room *room1=[[Room alloc]init];
    room1.roomName=@"Iceland";
    Room *room2=[[Room alloc]init];
    room2.roomName=@"Norway";
    Room *room3=[[Room alloc]init];
    room3.roomName=@"Palau";
    Room *room4=[[Room alloc]init];
    room4.roomName=@"China";
    Room *room5=[[Room alloc]init];
    room5.roomName=@"Greenland";
    Room *room6=[[Room alloc]init];
    room6.roomName=@"Tasmania";
    
    rooms = [NSArray arrayWithObjects:room1.roomName, room2.roomName, room3.roomName, room4.roomName, room5.roomName, room6.roomName, nil];
   
 //   contentList = [[NSMutableArray alloc] initWithObjects:room1, room2, room3, room4, room5, room6, nil];
 //   filteredContentList = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.searchView.searchTableView registerClass:[SearchTableViewCell class]  forCellReuseIdentifier:TABLEVIEWCELL_IDENTIFIER];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    searchBar.barStyle = UIBarStyleDefault;
    
    searchBar.showsCancelButton=YES;
    searchBar.autocorrectionType=UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType=UITextAutocapitalizationTypeNone;
    
    searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"User", @"Room",@"Description", nil];
    searchBar.selectedScopeButtonIndex=1;
    searchBar.showsScopeBar = YES;
    searchBar.tintColor=[UIColor darkGrayColor];
    
    
    searchBar.delegate=self;
    self.searchView.searchTableView.tableHeaderView=searchBar;
    
    
    searchBar.frame = CGRectMake(0, 0, self.searchView.searchTableView.frame.size.width, 44 + 40);
    
   // [searchBar becomeFirstResponder];
    
    
    UISearchDisplayController *searchCon = [[UISearchDisplayController alloc]
                                            initWithSearchBar:searchBar
                                            contentsController:self ];
    self.searchController = searchCon;
    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    
    [self.searchController setActive:YES animated:YES];
    [searchBar becomeFirstResponder];
    

    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - UITableViewDelegate & UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    /*
    if (isSearching) {
        return [filteredContentList count];
    }
    else {
        return [contentList count];
    } */
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSLog(@"in searchdisplaycontroller");
        return [searchResults count];
        
    } else {
        NSLog(@"out of searchdisplaycontroller");
        return [rooms count];
    }

}


 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 return 80.0;
 }

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell selected at index path %d:%d", indexPath.section, indexPath.row);
    NSLog(@"selected cell index path is %@", [self.meetingOverview.tableView indexPathForSelectedRow]);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];}

*/


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
        

    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:TABLEVIEWCELL_IDENTIFIER forIndexPath:indexPath];
    
    /*
    // Configure the cell...
    if (isSearching) {
        cell.textLabel.text = [filteredContentList objectAtIndex:indexPath.row];
    }
    else {
        cell.textLabel.text = [contentList objectAtIndex:indexPath.row];
    }*/
    
    
    // Display room in the table cell
    //Room  *room = nil;
    NSString *roomResult=nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        roomResult = [searchResults objectAtIndex:indexPath.row];
    } else {
        roomResult = [rooms objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = roomResult;
    
    
   // cell.backgroundColor=[UIColor lightGrayColor];
   
    
    
    
    return cell;
    
}

#pragma mark - Search methods


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.hidden=NO;
    self.searchView.searchTableView.tableHeaderView=searchBar;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    [tableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:TABLEVIEWCELL_IDENTIFIER];
    [tableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:TABLEVIEWCELL_EMPTYIDENTIFIER];
}

/*
- (void)searchTableList {
    NSString *searchString = self.searchBar.text;
    
    for (NSString *tempStr in contentList) {
        NSComparisonResult result = [tempStr compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
        if (result == NSOrderedSame) {
            [filteredContentList addObject:tempStr];
        }
    }
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"Text change - %d",isSearching);
    
    //Remove all objects first.
    [filteredContentList removeAllObjects];
    
    if([searchText length] != 0) {
        isSearching = YES;
        [self searchTableList];
    }
    else {
        isSearching = NO;
    }
    // [self.tblContentList reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [self searchTableList];
}

*/
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchText];
    NSLog(@"%@",searchText);
    NSLog(@"%@",resultPredicate);
    searchResults = [rooms filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                              scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];  
    
    return YES;
}


@end
