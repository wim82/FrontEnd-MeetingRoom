//
//  ReservationOverviewController.m
//  testProject
//
//  Created by Katrien De Mey on 03/04/14.
//  Copyright (c) 2014 Katrien De Mey. All rights reserved.
//

#import "ReservationOverviewController.h"
#import "ReservationOverview.h"
#import "ReservationTableViewCell.h"
#import "ReservationTableViewHeader.h"
#import "SearchViewController.h"
#import "ReservationService.h"
#import "Reservation.h"
#import "EditReservationViewController.h"
#import "DateHelper.h"


#define TABLEVIEWCELL_IDENTIFIER @"meetingCell"
#define TABLEVIEWHEADER_IDENTIFIER @"meetingHeader"

@interface ReservationOverviewController () <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property(nonatomic, strong) ReservationOverview *meetingOverview;
@property(nonatomic, strong) NSMutableDictionary *reservationsByDate;
@property(nonatomic) NSMutableArray *reservationDates;

@end

@implementation ReservationOverviewController


- (void)loadView {
    self.meetingOverview = [[ReservationOverview alloc] initWithFrame:[UIScreen mainScreen].bounds andDelegate:self];
    self.view = self.meetingOverview;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    //init arrays
    self.reservationDates = [[NSMutableArray alloc] init];
    self.reservationsByDate = [[NSMutableDictionary alloc] init];


    //register reuseable cells
    [self.meetingOverview.tableView registerClass:[ReservationTableViewCell class] forCellReuseIdentifier:TABLEVIEWCELL_IDENTIFIER];
    [self.meetingOverview.tableView registerClass:[ReservationTableViewHeader class] forHeaderFooterViewReuseIdentifier:TABLEVIEWHEADER_IDENTIFIER];

    // If you set the seperator inset on iOS 6 you get a NSInvalidArgumentException...weird
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.meetingOverview.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0); // Makes the horizontal row seperator stretch the entire length of the table view
    }

    //set up
    [self _setUpNavigationBar];
    [self loadReservations];


}

- (void)loadReservations {

    //make the call
    [[ReservationService sharedService] getReservationsForUserId:1 withSuccesHandler:^(NSMutableArray *reservations) {

        //build an array of dates for the sections
        for (Reservation *reservation  in reservations) {
            if (![self.reservationDates containsObject:reservation.date]) {
                [self.reservationDates addObject:reservation.date];
            }
        }

        //build a dictionary of reservations by date
        for (NSDate *date in self.reservationDates) {
            NSMutableArray *reservationsPerDate = [[NSMutableArray alloc] init];
            for (Reservation *reservation in reservations) {
                if (date == reservation.date) {
                    [reservationsPerDate addObject:reservation];
                }

            }
            [self.reservationsByDate setObject:reservationsPerDate forKey:date];
        }
        [self.meetingOverview.tableView reloadData];

    }                            andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigationbar

- (void)_setUpNavigationBar {

    // create an array for the buttons
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:2];

    // create  standard  buttons
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:self
                                 action:@selector(_didTapAdd)];

    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                 target:self
                                 action:@selector(_didTapSearch)];

    //add to array of right buttons
    [buttons addObject:addButton];
    [buttons addObject:searchButton];
    self.navigationItem.rightBarButtonItems = buttons;

    //create left button: searchButton
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"1396879915_FEZ-04.png"] style:UIBarButtonItemStylePlain
                   target:self
                   action:@selector(_didTapSettings)];

    //add Title
    self.navigationItem.title = @"Reservations";
}




#pragma mark - Navigation

- (void)_didTapAdd {
    //todo implement add

}

- (void)_didTapSettings {
    //todo implement settings screen

}

- (void)_didTapSearch {
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewController animated:YES];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.hidden = YES;
    self.meetingOverview.tableView.tableHeaderView = nil;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.reservationDates count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDate *date = [self.reservationDates objectAtIndex:section];
    return [[self.reservationsByDate objectForKey:date] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ReservationTableViewHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TABLEVIEWHEADER_IDENTIFIER];
    header.lblDate.text = [DateHelper displayStringFromDate:[self.reservationDates objectAtIndex:section]];
    return header;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDate *date = self.reservationDates[indexPath.section];
    Reservation *reservation = [self.reservationsByDate objectForKey:date][indexPath.row];


    EditReservationViewController *editReservationViewController = [[EditReservationViewController alloc] init];
    editReservationViewController.reservation = reservation;
    [self.navigationController pushViewController:editReservationViewController animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SWTableViewCell *cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:TABLEVIEWCELL_IDENTIFIER
                                               containingTableView:self.meetingOverview.tableView // Used for row height and selection
                                                leftUtilityButtons:[self leftButtons]
                                               rightUtilityButtons:[self rightButtons]];
    cell.delegate = self;

    [cell setCellHeight:64];

    NSMutableArray *meetingArray =[self.reservationsByDate objectForKey:self.reservationDates[indexPath.section]];
    Reservation *reservation = [meetingArray objectAtIndex:indexPath.row];

    //TODO maak eigen labels
    cell.textLabel.text = reservation.reservationDescription;
    cell.textLabel.backgroundColor = [UIColor redColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@           %@", reservation.meetingRoom.roomName, reservation.startTime];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}


#pragma marks - Swipe Methods

- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
            [UIColor lightGrayColor]
                                                 icon:[UIImage imageNamed:@"edit-512.png"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
            [UIColor redColor]
                                                 icon:[UIImage imageNamed:@"delete-512.png"]];

    return rightUtilityButtons;
}


- (NSArray *)leftButtons {
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    return leftUtilityButtons;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor whiteColor];
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {   //TODO  edit button is pressed. Implement action: trigger edit view
            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil];
            [alertTest show];

            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1: {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.meetingOverview.tableView indexPathForCell:cell];
            //TODO implement delete action
            //  [_testArray[cellIndexPath.section] removeObjectAtIndex:cellIndexPath.row];
            //  [self.meetingOverview.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}


@end
