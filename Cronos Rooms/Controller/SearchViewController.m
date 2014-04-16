#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "SearchView.h"
#import "MeetingRoomService.h"
#import "UIColor+AppColor.h"
#import "UserService.h"
#import "User.h"
#import "ScopedSearchBar.h"
#import "CustomSearchDisplayController.h"
#import "EditReservationViewController.h"
#import "ReservationOverviewController.h"
#import "DayViewController.h"
#import "MonthViewController.h"


#define TABLEVIEWCELL_IDENTIFIER @"searchCell"
#define TABLEVIEWCELL_EMPTYIDENTIFIER @"emptySearchCell"


@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property(nonatomic, strong) SearchView *searchView;
@property(nonatomic, strong) ScopedSearchBar *searchBar;
@property(nonatomic, strong) CustomSearchDisplayController *searchController;
@property(nonatomic, strong) NSArray *searchResults;

@property(nonatomic, strong) NSArray *meetingRooms;
@property(nonatomic, strong) NSArray *users;

@end


@implementation SearchViewController


- (void)loadView {
    self.searchView = [[SearchView alloc] initWithFrame:[UIScreen mainScreen].bounds andDelegate:self];
    self.view = self.searchView;

    [self _loadMeetingRooms];
    [self _loadUsers];

}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.searchView.searchTableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:TABLEVIEWCELL_IDENTIFIER];

    [self _setUpSearchBar];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)_loadMeetingRooms {
    MeetingRoomService *service = [MeetingRoomService sharedService];
    [service getAllMeetingRoomsWithSuccessHandler:^(NSMutableArray *meetingRooms) {
        self.meetingRooms = [[NSArray alloc] initWithArray:meetingRooms];
        [self.searchView.searchTableView reloadData];
    }                             andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:exception.reason delegate:self cancelButtonTitle:@"het zou niet mogen" otherButtonTitles:nil];
        [alertView show];
    }];

}


- (void)_loadUsers {
    UserService *userService = [UserService sharedService];
    [userService getAllUsersWithSuccesHandler:^(NSMutableArray *users) {
        self.users = [[NSArray alloc] initWithArray:users];
    }                         andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error " message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}



#pragma mark - SetUp Methods

- (void)_setUpSearchBar {

    self.searchBar = [[ScopedSearchBar alloc] initWithFrame:CGRectZero];
    self.searchBar.tintColor = [UIColor app_darkGrey];
    self.searchBar.barTintColor = [UIColor app_blueGreyShaded];
    self.searchBar.backgroundColor = [UIColor app_blueGreyShaded];
    self.searchBar.translucent = NO; //doesn't seem to work?

    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;

    self.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"User", @"Room", nil];
    self.searchBar.selectedScopeButtonIndex = 1;
    self.searchBar.showsScopeBar = YES;

    self.searchBar.delegate = self;

    //makes sure the underlying table doesn't interfere with the scopeBar
    self.searchBar.frame = CGRectMake(0, 0, self.searchView.frame.size.width, 44 + (self.searchBar.showsScopeBar ? 40 : 0));
    self.searchView.searchTableView.tableHeaderView = self.searchBar;

    [self _setUpSearchController];

}


- (void)_setUpSearchController {
    self.searchController = [[CustomSearchDisplayController alloc]
            initWithSearchBar:self.searchBar
           contentsController:self];

    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    [self.searchController setActive:NO animated:NO];

}



#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
    } else {  //if there's no results
        if (self.searchBar.selectedScopeButtonIndex == 1) {
            return [self.meetingRooms count];
        }
        else if (self.searchBar.selectedScopeButtonIndex == 0) {
            return [self.users count];
        }
        else {
            return 0;
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:TABLEVIEWCELL_IDENTIFIER forIndexPath:indexPath];

    //figure out if there's a result to the search
    id result = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        result = [self.searchResults objectAtIndex:indexPath.row];
    } else {    //if there's no search result, display all rooms or users
        if (self.searchBar.selectedScopeButtonIndex == 1) {
            result = [self.meetingRooms objectAtIndex:indexPath.row];
        }
        if (self.searchBar.selectedScopeButtonIndex == 0) {
            result = [self.users objectAtIndex:indexPath.row];

        }
    }

    //build cell, depending on the result
    if ([result isKindOfClass:[MeetingRoom class]]) {
        cell.textLabel.text = ((MeetingRoom *) result).roomName;
    }
    if ([result isKindOfClass:[User class]]) {
        cell.textLabel.text = ((User *) result).fullName;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchBar.selectedScopeButtonIndex == 1) {
        /* DayViewController *dayViewController = [[DayViewController alloc] init];
         dayViewController.meetingRoom =  self.meetingRooms[indexPath.row];
         [self.navigationController pushViewController:dayViewController animated:YES];  */
        MonthViewController *monthViewController = [[MonthViewController alloc] init];
        monthViewController.meetingRoom = self.meetingRooms[indexPath.row];
        NSLog(@"in search : %@",self.meetingRooms[indexPath.row]);
        [self.navigationController pushViewController:monthViewController animated:YES];

    } else {
        //we've clicked on a user
        ReservationOverviewController *reservationOverviewController = [[ReservationOverviewController alloc] init];
        reservationOverviewController.user = [[User alloc] init];
        reservationOverviewController.user.userId = 2;
        [self.navigationController pushViewController:reservationOverviewController animated:YES];
    }


}

#pragma mark - Search methods

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    [tableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:TABLEVIEWCELL_IDENTIFIER];
    [tableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:TABLEVIEWCELL_EMPTYIDENTIFIER];
}


- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    if ([scope isEqualToString:@"Room"]) {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self.roomName contains[cd] %@", searchText];
        self.searchResults = [self.meetingRooms filteredArrayUsingPredicate:resultPredicate];
    }

    if ([scope isEqualToString:@"User"]) {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self.fullName contains[cd] %@", searchText];
        self.searchResults = [self.users filteredArrayUsingPredicate:resultPredicate];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                       objectAtIndex:[self.searchDisplayController.searchBar
                                               selectedScopeButtonIndex]]];
    return YES;
}


- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    self.searchBar.text = @""; //don't remove this! hack to always display searchbar
    [self.searchView.searchTableView reloadData];
    [self.searchController setActive:NO animated:NO];
}

@end
