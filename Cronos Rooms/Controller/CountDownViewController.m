//
//  CountDownViewController.m
//  Cronos Rooms
//
//  Created by Katrien De Mey on 15/04/14.
//  Copyright (c) 2014 KaWi. All rights reserved.
//

#import "CountDownViewController.h"
#import "CountDownView.h"
#import "SettingsViewController.h"
#import "ReservationService.h"
#import "NSDate+Helper.h"
#import "UIColor+AppColor.h"
#import "ReservationTableViewCell.h"
#import "ReservationTableViewHeader.h"
#import "DTCustomColoredAccessory.h"
#import "EditReservationViewController.h"
#import "UIImage+ImageEffects.h"
#import "MeetingRoomService.h"


#define TABLEVIEWCELL_IDENTIFIER @"reservationCell"
#define TABLEVIEWHEADER_IDENTIFIER @"reservationHeader"


@interface CountDownViewController () <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate, UISearchBarDelegate, UISearchDisplayDelegate, SettingsDelegate> {


    //we don't actually use the seconds, but leave them in for debugging purposes
    int days, hours, minutes, seconds;
    int secondsLeft;
    int clockIndexPath;
    int clockSection;
    BOOL clockReservation;

}

@property(nonatomic, strong) NSMutableDictionary *reservationsByDate;
@property(nonatomic) NSMutableArray *reservationDates;
@property(nonatomic, strong) CountDownView *countDownView;
@property(nonatomic, assign) BOOL isReservationOverviewVisible;
@property(nonatomic, strong) UIImage *backgroundImage;
@property(nonatomic, strong) UIImage *blurredBackgroundImage;

@end


//FIXME: very messy implementation, one big experiment before we heard of childviewcontrollers :)
//TODO: optimize the heavy processing code for images & alpha values
@implementation CountDownViewController


- (void)loadView {
    self.countDownView = [[CountDownView alloc] initWithFrame:[UIScreen mainScreen].bounds andDelegate:self];
    self.view = self.countDownView;
    self.isReservationOverviewVisible = NO;

}


- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];


    [self _setBackGroundImageToCurrentMeetingRoom];
    [self _setUpReservationOverviewTable];

    self.countDownView.tableView.backgroundColor = [[UIColor app_darkGrey] colorWithAlphaComponent:0.3];


    //TODO: ask katrien about this dayttableview?
    //if you want the table horizontal
    self.countDownView.dayTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    //Just so your table is not at a random place in your view
    self.countDownView.dayTableView.frame = CGRectMake(1024 - (1024 / 3) - 44, 44, 1024 / 3, 0);


    [self _addGestureRecognizers];

    [self loadReservationsForMeetingRoom:self.meetingRoom];

}


- (void)_setUpReservationOverviewTable {
    [self.countDownView.tableView registerClass:[ReservationTableViewCell class] forCellReuseIdentifier:TABLEVIEWCELL_IDENTIFIER];
    [self.countDownView.tableView registerClass:[ReservationTableViewHeader class] forHeaderFooterViewReuseIdentifier:TABLEVIEWHEADER_IDENTIFIER];
    self.countDownView.tableView.frame = CGRectMake(1024 - (1024 / 3) - 44, 44, 1024 / 3, 0);
}


- (void)_setBackGroundImageToCurrentMeetingRoom {
    NSLog(@"in _setBackGroundImageToCurrentMeetingRoom met %@", [self.meetingRoom.roomName lowercaseString]);
    self.backgroundImage = [UIImage imageNamed:[self.meetingRoom.roomName lowercaseString]];
    self.blurredBackgroundImage = [self.backgroundImage applyBlurWithRadius:16 tintColor:[[UIColor blackColor] colorWithAlphaComponent:0.2] saturationDeltaFactor:1 maskImage:nil];

    if (self.isReservationOverviewVisible) {
        // self.view.backgroundColor = [UIColor colorWithPatternImage:self.blurredBackgroundImage];
        NSLog(@"HALLLOOOOO");
        self.countDownView.backgroundView.image = self.blurredBackgroundImage;
    } else {
        // self.view.backgroundColor = [UIColor colorWithPatternImage:self.backgroundImage];
        self.countDownView.backgroundView.image = self.backgroundImage;
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [self _setUpNavigationController];
    clockReservation = FALSE;
    [timer invalidate];
}




#pragma mark - UIGestureRecognizers

- (void)_addGestureRecognizers {

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_didTapScreen)];
    [self.view addGestureRecognizer:gestureRecognizer];

    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_didPressLong:)];
    [self.view addGestureRecognizer:longPressGestureRecognizer];
}


- (void)_didPressLong:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self _presentSettingsViewController];
    }
}


- (void)_didTapScreen {

    if (self.isReservationOverviewVisible) {

        [UIView animateWithDuration:1 animations:^{
            self.countDownView.tableView.frame = CGRectMake(1024 - (1024 / 3) - 44, 44, 1024 / 3, 0); //1024, 44, 1024 / 3, 768)
        }                completion:^(BOOL finished) {
            self.isReservationOverviewVisible = NO;

        }];

        [UIView transitionWithView:self.view
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            //self.view.backgroundColor = [UIColor colorWithPatternImage:self.backgroundImage];
                            self.countDownView.backgroundView.image = self.backgroundImage;
                        } completion:NULL];

    } else {

        [UIView animateWithDuration:1 animations:^{
            self.countDownView.tableView.frame = CGRectMake(1024 - (1024 / 3) - 44, 44, 1024 / 3, 768);
        }                completion:^(BOOL finished) {

            self.isReservationOverviewVisible = YES;
        }];

        // UIImage *darkImage = [self.backgroundImage applyBlurWithRadius:16 tintColor:[[UIColor app_darkGrey] colorWithAlphaComponent:0.3] saturationDeltaFactor:1 maskImage:nil];

        [UIView transitionWithView:self.view
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.countDownView.backgroundView.image = self.blurredBackgroundImage;
                            //self.view.backgroundColor = [UIColor colorWithPatternImage:self.blurredBackgroundImage];
                        } completion:NULL];

    }

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
    // header.backgroundColor = [UIColor clearColor];
    header.lblDate.textColor = [UIColor lightTextColor];
    header.lblDate.font = [UIFont fontWithName:@"GillSans" size:14];

    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(8, header.lblDate.frame.size.height - 0.5, 280, 0.5);

    bottomBorder.backgroundColor = [UIColor lightTextColor].CGColor;
    [header.layer addSublayer:bottomBorder];

    NSLog(@"%f == contentviewframe", header.lblDate.frame.size.width);
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
                                               containingTableView:self.countDownView.tableView // Used for row height and selection
                                                leftUtilityButtons:nil
                                               rightUtilityButtons:[self rightButtons]];
    cell.delegate = self;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"GillSans-Italic" size:20];
    cell.cellScrollView.backgroundColor = [UIColor clearColor];

    [cell setCellHeight:64];

    NSMutableArray *meetingArray = [self.reservationsByDate objectForKey:self.reservationDates[indexPath.section]];
    Reservation *reservation = [meetingArray objectAtIndex:indexPath.row];

    NSDate *today = [[NSDate alloc] init];

    //logic needed to control the counter
    if (([reservation.startTime timeIntervalSinceDate:today] > 0) && !clockReservation) {
        clockIndexPath = indexPath.row;
        clockSection = indexPath.section;
        clockReservation = TRUE;
    }
    if (([reservation.startTime timeIntervalSinceDate:today] <= 0) && ([reservation.endTime timeIntervalSinceDate:today]) > 0 && !clockReservation) {

        clockIndexPath = indexPath.row;
        clockSection = indexPath.section;
        clockReservation = TRUE;

    }




    //TODO: use custom cell instead of the UITableViewCellStyleSubtitle cell

    cell.textLabel.text = [reservation.reservationDescription capitalizedString];


    cell.detailTextLabel.textColor = [UIColor app_snowWhiteShade];
    cell.detailTextLabel.font = [UIFont fontWithName:@"GillSans" size:10];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@          %@ - %@", reservation.user.fullName, [reservation.startTime stringWithFormat:DATEFORMAT_SHORT_TIME], [reservation.endTime stringWithFormat:DATEFORMAT_SHORT_TIME]];

    //Custom Accessory
    DTCustomColoredAccessory *accessory = [DTCustomColoredAccessory accessoryWithColor:[UIColor app_snowWhite]];
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
            [[UIColor blackColor] colorWithAlphaComponent:0.1]
                                                title:@"edit"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
            [[UIColor blackColor] colorWithAlphaComponent:0.2]
                                                 title:@"delete"];
    return rightUtilityButtons;
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *cellIndexPath = [self.countDownView.tableView indexPathForCell:cell];
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
                [self.countDownView.tableView deleteSections:[NSIndexSet indexSetWithIndex:cellIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else {
                [self.countDownView.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:cellIndexPath]
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


#pragma mark - access Database


- (void)loadReservationsForMeetingRoom:(MeetingRoom *)meetingRoom {

    NSDate *today = [[NSDate alloc] init];


    //make the call
    [[ReservationService sharedService] getReservationsForRoomId:self.meetingRoom.roomId fromDate:today forAmountOfDays:365 withSuccesHandler:^(NSMutableArray *reservations) {
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


        //reload table data
        [self.countDownView.tableView reloadData];

        //determine startTime of next meeting to calculate Count Down Clock:
        NSDate *startDate = [[NSDate alloc] init];
        Reservation *firstReservation = [[Reservation alloc] init];
        firstReservation = [[self.reservationsByDate objectForKey:[self.reservationDates objectAtIndex:clockSection]] objectAtIndex:clockIndexPath];
        startDate = firstReservation.startTime;
        [self setUpTimer:startDate];

        //code needed to fix trailing row ) - i don't really understand this either.
        [self.countDownView.tableView setContentInset:UIEdgeInsetsMake(0, 0, 84, 0)];

    }                                            andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];

}


#pragma mark - Private Methods



- (void)deleteReservation:(NSInteger)reservationId {
    ReservationService *reservationService = [ReservationService sharedService];

    [reservationService deleteReservation:reservationId withSuccesHandler:^(Reservation *reservation) {
        [self.navigationController popViewControllerAnimated:YES];

    }                     andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error " message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Set Up Methods

- (void)_setUpNavigationController {

    //if the title hasn't been set, set it to "Edit Reservation"
    self.navigationItem.title = self.meetingRoom.roomName;

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:self
                                 action:@selector(_didTapAdd)];

    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.hidden = NO;
}


- (void)_didTapAdd {
    EditReservationViewController *editReservationViewController = [[EditReservationViewController alloc] init];
    editReservationViewController.delegate = self;
    Reservation *reservation = [[Reservation alloc] init];

    reservation.meetingRoom = self.meetingRoom;
    editReservationViewController.reservation = reservation;
    editReservationViewController.navigationItem.title = @"Add Reservation";

    [self.navigationController pushViewController:editReservationViewController animated:YES];

}


#pragma mark - Clock Counter

- (void)setUpTimer:(NSDate *)date {

    NSDate *today = [[NSDate alloc] init];

    double countDownTimer;
    countDownTimer = [date timeIntervalSinceDate:today];

    secondsLeft = countDownTimer;

    //  self.countDownView.countDownTime.backgroundColor = [UIColor greenColor];
    self.countDownView.meetingRoomStatus.text = @"Room is available for the next";

    if (secondsLeft <= 0) {
        NSDate *endDate = [[NSDate alloc] init];
        Reservation *firstReservation = [[Reservation alloc] init];
        firstReservation = [[self.reservationsByDate objectForKey:[self.reservationDates objectAtIndex:clockSection]] objectAtIndex:clockIndexPath];
        endDate = firstReservation.endTime;

        NSDate *today = [[NSDate alloc] init];

        double countDownTimer;
        countDownTimer = [endDate timeIntervalSinceDate:today];

        secondsLeft = countDownTimer;

        self.countDownView.meetingRoomStatus.text = @"Room will be available in";
        //  self.countDownView.countDownTime.backgroundColor = [UIColor app_lightRed];

    }


    [self countdownTimer];

}


- (void)updateCounter:(NSTimer *)theTimer {
    NSLog(@"in update Counter");
    if (secondsLeft > 0) {
        secondsLeft--;
        days = secondsLeft / 86400;
        hours = (secondsLeft % 86400) / 3600;
        minutes = ((secondsLeft % 86400) % 3600) / 60;
        seconds = ((secondsLeft % 86400) % 3600) % 60;

        NSString *dayString;
        dayString = (days == 1) ? @"1 day, " : [NSString stringWithFormat:@"%i days, ", days];
        dayString = (days == 0) ? @"" : dayString;

        NSString *hourString;
        hourString = (hours == 1) ? @"1 hour" : [NSString stringWithFormat:@"%i hours", hours];
        hourString = (hours == 0) ? @"" : hourString;

        NSString *minuteString;
        minuteString = (minutes == 1) ? @" & 1 minute" : [NSString stringWithFormat:@" & %i minutes", minutes];
        minuteString = (minutes == 0) ? @"" : minuteString;

        //TODO if days is 0, don't show days
        self.countDownView.countDownTime.text = [NSString stringWithFormat:@"%@%@%@", dayString, hourString, minuteString];
    }
    else {
        if (secondsLeft <= 0) {
            clockReservation = FALSE;

            [self.countDownView.tableView reloadData];
            //determine startTime of next meeting to calculate Count Down Clock:
            Reservation *firstReservation = [[self.reservationsByDate objectForKey:[self.reservationDates objectAtIndex:clockSection]] objectAtIndex:clockIndexPath];
            NSDate *startDate = firstReservation.startTime;
            [timer invalidate];
            [self setUpTimer:startDate];
        }

    }
}


- (void)countdownTimer {

    // secondsLeft = hours = minutes = seconds = 0;
    if ([timer isValid]) {;
    }

    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];

}


#pragma mark - actions

- (void)_presentSettingsViewController {
    NSLog(@"in _presentSettingsViewController");
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    settingsViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    settingsViewController.delegate = self;
    [self.navigationController presentViewController:settingsViewController animated:YES completion:^{
        NSLog(@"in present view controller completed");
    }];
    NSLog(@"einde _presentSettingsViewController");
}


- (void)didChangeSettingsToDefaultMeetingRoom:(MeetingRoom *)defaultMeetingRoom {

    self.meetingRoom = defaultMeetingRoom;
    [self loadReservationsForMeetingRoom:defaultMeetingRoom];
    [self _setBackGroundImageToCurrentMeetingRoom];
    [self _setUpNavigationController];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{

    }];
    //
}


- (void)shouldLaunchReservationOverviewController:(ReservationOverviewController *)reservationOverviewController {
    [self.presentedViewController dismissViewControllerAnimated:NO completion:^{
        NSLog(@"in shouldlaunchreservationOverviewController completed");
        [self.navigationController popToRootViewControllerAnimated:NO];

    }];
}

@end



