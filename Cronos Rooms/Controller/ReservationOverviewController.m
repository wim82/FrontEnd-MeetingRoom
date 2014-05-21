
#import "ReservationOverviewController.h"
#import "ReservationOverview.h"
#import "ReservationTableViewCell.h"
#import "ReservationTableViewHeader.h"
#import "SearchViewController.h"
#import "ReservationService.h"
#import "EditReservationViewController.h"
#import "NSDate+Helper.h"
#import "UIColor+AppColor.h"
#import "DTCustomColoredAccessory.h"
#import "SettingsViewController.h"


#define TABLEVIEWCELL_IDENTIFIER @"meetingCell"
#define TABLEVIEWHEADER_IDENTIFIER @"meetingHeader"


@interface ReservationOverviewController () <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate, UISearchBarDelegate, UISearchDisplayDelegate, SettingsDelegate>

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

    //register reuseable cells
    [self.meetingOverview.tableView registerClass:[ReservationTableViewCell class] forCellReuseIdentifier:TABLEVIEWCELL_IDENTIFIER];
    [self.meetingOverview.tableView registerClass:[ReservationTableViewHeader class] forHeaderFooterViewReuseIdentifier:TABLEVIEWHEADER_IDENTIFIER];



}


- (void)viewWillAppear:(BOOL)animated {
    //set up
    [self _setUpNavigationBar];

    //TODO: write some sort of ModeController -> load ReservationOverview if in userMode, load CountDownMode if inMeetingRoomMode
    if (![self _isInMeetingRoomMode]) {
        [self _loadAppInUserMode];
    }
}


#pragma mark - Private Methods

- (BOOL)_isInMeetingRoomMode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:@"defaultMeetingRoom"];
    MeetingRoom *meetingRoom = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    if (meetingRoom) {
        CountDownViewController *countDownViewController = [[CountDownViewController alloc] init];
        countDownViewController.meetingRoom = meetingRoom;
        [self.navigationController pushViewController:countDownViewController animated:YES];
        return YES;
    }
    return NO;
}

- (void)_loadAppInUserMode {
    //User of the reservation over has not been set
    //get the default user
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedUser = [defaults objectForKey:@"defaultUser"];
    User *defaultUser = [NSKeyedUnarchiver unarchiveObjectWithData:encodedUser];

    if (!self.user) { //if user has not been set
        if (defaultUser) { //check if there is a default user and use his settings
            self.user = defaultUser;
        } else {
            //if there's no default user, go to settings screen
            [self _didTapSettings];
        }
    }

    if (self.user == defaultUser) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                initWithImage:[UIImage imageNamed:@"settings-44"] style:UIBarButtonItemStylePlain
                       target:self
                       action:@selector(_didTapSettings)];
        self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0.0, -8, 0, 0);
    }

    [self _loadReservationsForUser:self.user];
}


- (void)_loadReservationsForUser:(User *)user {

    //make the call
    [[ReservationService sharedService] getReservationsForUserId:user.userId withSuccesHandler:^(NSMutableArray *reservations) {

        reservations = [Reservation sortByStartTime:reservations];


        //init arrays
        self.reservationDates = [[NSMutableArray alloc] init];
        self.reservationsByDate = [[NSMutableDictionary alloc] init];

        //build an array of dates for the sections
        for (Reservation *reservation  in reservations) {
            NSDate *dateWithoutTime = [reservation.startTime dateWithoutTime];
            if (![self.reservationDates containsObject:dateWithoutTime]) {
                [self.reservationDates addObject:dateWithoutTime];
            }
        }

        //build a dictionary of reservations by date
        for (NSDate *date in self.reservationDates) {
            NSMutableArray *reservationsPerDate = [[NSMutableArray alloc] init];
            for (Reservation *reservation in reservations) {
                if ([date compare:[reservation.endTime dateWithoutTime]] == NSOrderedSame) {
                    [reservationsPerDate addObject:reservation];
                }

            }
            [self.reservationsByDate setObject:reservationsPerDate forKey:date];
        }

        [self.meetingOverview.tableView reloadData];

        //code needed to fix trailing row - i don't really understand this either.
        [self.meetingOverview.tableView setContentInset:UIEdgeInsetsMake(0, 0, 84, 0)];

    }                                            andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];

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

    //align the searchbutton a bit more to the right.
    searchButton.imageInsets = UIEdgeInsetsMake(0.0, 10, 0, -10);

    //add to array of right buttons
    [buttons addObject:addButton];
    [buttons addObject:searchButton];
    self.navigationItem.rightBarButtonItems = buttons;


    self.navigationController.navigationBar.translucent = NO;
    self.title = @"Reservations";
    self.navigationController.navigationBar.hidden = NO;

}


#pragma mark - Navigation

- (void)_didTapAdd {
    EditReservationViewController *editReservationViewController = [[EditReservationViewController alloc] init];

    Reservation *reservation = [[Reservation alloc] init];
    reservation.user = self.user;

    //TODO: remove back button, first time add is pressed
    editReservationViewController.reservation = reservation;
    editReservationViewController.navigationItem.title = @"Add Reservation";

    [self.navigationController pushViewController:editReservationViewController animated:YES];
}


- (void)_didTapSettings {

    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    //settingsViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    settingsViewController.delegate = self;
    [self.navigationController presentViewController:settingsViewController animated:YES completion:nil];
}


- (void)_didTapSearch {
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewController animated:YES];
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
    header.lblDate.text = [[[self.reservationDates objectAtIndex:section] stringWithFormat:DATEFORMAT_DAYNAME_AND_SHORT_DATE] lowercaseString];
    return header;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDate *date = self.reservationDates[indexPath.section];
    Reservation *reservation = [self.reservationsByDate objectForKey:date][indexPath.row];


    EditReservationViewController *editReservationViewController = [[EditReservationViewController alloc] init];
    editReservationViewController.reservation = reservation;
    self.navigationItem.backBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:@""
                                             style:UIBarButtonItemStyleBordered
                                            target:nil
                                            action:nil];
    [self.navigationController pushViewController:editReservationViewController animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SWTableViewCell *cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:TABLEVIEWCELL_IDENTIFIER
                                               containingTableView:self.meetingOverview.tableView // Used for row height and selection
                                                leftUtilityButtons:nil
                                               rightUtilityButtons:[self rightButtons]];
    cell.delegate = self;

    [cell setCellHeight:64];

    NSMutableArray *meetingArray = [self.reservationsByDate objectForKey:self.reservationDates[indexPath.section]];
    Reservation *reservation = [meetingArray objectAtIndex:indexPath.row];

    //TODO: use custom cell instead of the UITableViewCellStyleSubtitle cell

    cell.textLabel.textColor = [UIColor darkTextColor];
    cell.textLabel.text = [reservation.reservationDescription capitalizedString];


    cell.detailTextLabel.textColor = [UIColor app_grey];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@           %@ - %@", reservation.meetingRoom.roomName, [reservation.startTime stringWithFormat:DATEFORMAT_SHORT_TIME], [reservation.endTime stringWithFormat:DATEFORMAT_SHORT_TIME]];

    //Custom Accessory
    DTCustomColoredAccessory *accessory = [DTCustomColoredAccessory accessoryWithColor:[UIColor app_red]];
    cell.accessoryView = accessory;

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    //this doesn't work as i expected -> probably because of SWTableViewCell?
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    //do nothing;
}



#pragma mark - SwipeTableViewCell Methods

- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];


    [rightUtilityButtons sw_addUtilityButtonWithColor:
            [UIColor app_ultraLightGrey]
                                                title:@"edit"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
            [UIColor app_red]
                                                title:@"delete"];
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *cellIndexPath = [self.meetingOverview.tableView indexPathForCell:cell];
    NSDate *date = self.reservationDates[cellIndexPath.section];
    Reservation *reservation = [self.reservationsByDate objectForKey:date][cellIndexPath.row];
    switch (index) {
        case 0: {
            EditReservationViewController *editReservationViewController = [[EditReservationViewController alloc] init];
            editReservationViewController.reservation = reservation;
            [self.navigationController pushViewController:editReservationViewController animated:YES];

            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1: {
            [self deleteReservation:reservation.reservationId];
            [[self.reservationsByDate objectForKey:[self.reservationDates objectAtIndex:cellIndexPath.section]] removeObjectAtIndex:cellIndexPath.row];

            [cell hideUtilityButtonsAnimated:YES];

            if ([[self.reservationsByDate objectForKey:[self.reservationDates objectAtIndex:cellIndexPath.section]] count] == 0) {

                [self.reservationsByDate removeObjectForKey:[self.reservationDates objectAtIndex:cellIndexPath.section]];
                [self.reservationDates removeObjectAtIndex:cellIndexPath.section];
                [self.meetingOverview.tableView deleteSections:[NSIndexSet indexSetWithIndex:cellIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else {
                [self.meetingOverview.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:cellIndexPath]
                                                      withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            break;
        }
        default:
            break;
    }
}


- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state {
    if (state == kCellStateRight) {
        cell.accessoryView.hidden = YES;
    } else {
        cell.accessoryView.hidden = NO;
    }

}


#pragma mark - Rest Calls

- (void)deleteReservation:(NSInteger)reservationId {
    ReservationService *reservationService = [ReservationService sharedService];

    [reservationService deleteReservation:reservationId withSuccesHandler:^(Reservation *reservation) {
        [self.navigationController popViewControllerAnimated:YES];

    }                     andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error " message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}


#pragma mark - Settings Delegate Methods

- (void)shouldLaunchCountDownViewController:(CountDownViewController *)countDownViewController {
    [self.presentedViewController dismissViewControllerAnimated:NO completion:^{
        [self.navigationController pushViewController:countDownViewController animated:YES];
    }];

}

- (void)didChangeSettingsToDefaultUser:(User *)defaultUser {
    self.user = defaultUser;
    [self _loadAppInUserMode];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Rotation Methods
//FIXME: really bad rotation implementation
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [UIView animateWithDuration:0.5 animations:^{
        self.meetingOverview.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}


@end
