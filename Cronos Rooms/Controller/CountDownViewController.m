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


#define TABLEVIEWCELL_IDENTIFIER @"reservationCell"
#define TABLEVIEWHEADER_IDENTIFIER @"reservationHeader"



@interface CountDownViewController () <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate, UISearchBarDelegate, UISearchDisplayDelegate, SettingsDelegate>


@property(nonatomic, strong) NSMutableDictionary *reservationsByDate;
@property(nonatomic) NSMutableArray *reservationDates;
@property(nonatomic, strong) CountDownView *countDownView;
@property(nonatomic, strong) NSDate *startDate;
@property(nonatomic, strong) NSDate *today;
@property(nonatomic, strong) NSDate *endDate;
@property(nonatomic, assign) BOOL isReservationOverviewVisible;
@property(nonatomic, strong) UIImage *backgroundImage;



@end


@implementation CountDownViewController


int days, hours, minutes, seconds;
int secondsLeft;
int clockIndexPath;
int clockSection;
BOOL clockReservation;



- (void)loadView {
    self.countDownView = [[CountDownView alloc] initWithFrame:[UIScreen mainScreen].bounds andDelegate:self];
    self.view = self.countDownView;
    self.isReservationOverviewVisible = NO;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapScreen)];
    [self.view addGestureRecognizer:gestureRecognizer];

    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didPressLong)];
    [self.view addGestureRecognizer:longPressGestureRecognizer];
}


- (void)didPressLong {
    [self _didTapSettings];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didTapScreen {

    if (self.isReservationOverviewVisible) {
        [UIView transitionWithView:self.view
                          duration:1
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.view.backgroundColor = [UIColor colorWithPatternImage:self.backgroundImage];
                        } completion:NULL];

        [UIView animateWithDuration:0.6 animations:^{
            self.countDownView.tableView.frame = CGRectMake(1024, 0, 1024 / 3, 768);
        }                completion:^(BOOL finished) {
            self.isReservationOverviewVisible = NO;
        }];

    } else {

        UIImage *darkImage = [self.backgroundImage applyBlurWithRadius:16 tintColor:[[UIColor app_darkGrey] colorWithAlphaComponent:0.3] saturationDeltaFactor:1 maskImage:nil];
        [UIView transitionWithView:self.view
                          duration:1
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.view.backgroundColor = [UIColor colorWithPatternImage:darkImage];
                        } completion:NULL];


        [UIView animateWithDuration:0.6 animations:^{





            // self.view.backgroundColor = [UIColor colorWithPatternImage:self.backgroundImage];
            self.countDownView.tableView.frame = CGRectMake(1024 - (1024 / 3), 0, 1024 / 3, 768);
        }                completion:^(BOOL finished) {
            self.isReservationOverviewVisible = YES;
        }];
    }

}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.backgroundImage = [UIImage imageNamed:@"Iceland"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:self.backgroundImage];

    // self.view.backgroundColor = [UIColor redColor];
    //register reuseable cells
    //table with all reservations for meetingroom
    [self.countDownView.tableView registerClass:[ReservationTableViewCell class] forCellReuseIdentifier:TABLEVIEWCELL_IDENTIFIER];
    [self.countDownView.tableView registerClass:[ReservationTableViewHeader class] forHeaderFooterViewReuseIdentifier:TABLEVIEWHEADER_IDENTIFIER];

    
    
  //if you want the table horizontal
    self.countDownView.dayTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    //Just so your table is not at a random place in your view
    self.countDownView.dayTableView.frame = CGRectMake(0,0, self.countDownView.dayTableView.frame.size.width, self.countDownView.dayTableView.frame.size.height);
   
    
    [self _setUpNavigationController];

}


- (void)viewWillAppear:(BOOL)animated {
    //TODO: write code to see what is the "meetingroom"
    if (!self.meetingRoom) {
        self.meetingRoom = [[MeetingRoom alloc] init];
        self.meetingRoom.roomId = 2;
    }

    clockReservation = FALSE;
    [timer invalidate];
   
    [self loadReservationsForMeetingRoom:self.meetingRoom];
    
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
                                               containingTableView:self.countDownView.tableView // Used for row height and selection
                                                leftUtilityButtons:nil
                                               rightUtilityButtons:[self rightButtons]];
    cell.delegate = self;

    [cell setCellHeight:64];

    NSMutableArray *meetingArray = [self.reservationsByDate objectForKey:self.reservationDates[indexPath.section]];
    Reservation *reservation = [meetingArray objectAtIndex:indexPath.row];

    NSDate *today = [[NSDate alloc] init];

    //logic needed to control the counter
    NSLog(@"wat is verschil %f", [reservation.startTime timeIntervalSinceDate:today]);
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

    NSLog(@"clockIndexPath en section : %d   %d", clockIndexPath, clockSection);



    //TODO: use custom cell instead of the UITableViewCellStyleSubtitle cell

    cell.textLabel.textColor = [UIColor darkTextColor];
    cell.textLabel.text = [reservation.reservationDescription capitalizedString];


    cell.detailTextLabel.textColor = [UIColor app_grey];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
    //TODO check the name of the user of the reservation
    cell.detailTextLabel.text = [NSString stringWithFormat:@"User %ld           %@ - %@", (long) reservation.user.fullName, [reservation.startTime stringWithFormat:DATEFORMAT_SHORT_TIME], [reservation.endTime stringWithFormat:DATEFORMAT_SHORT_TIME]];

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
    NSLog(@"today %@", today);


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
    self.navigationItem.title = @"Meeting Room Name";

    self.navigationController.navigationBar.translucent = NO;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"settings-44"] style:UIBarButtonItemStylePlain
                   target:self
                   action:@selector(_didTapSettings)];

    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0.0, -8, 0, 0);

    self.navigationController.navigationBar.hidden = YES;
}


#pragma mark - Clock Counter

- (void)setUpTimer:(NSDate *)date {

    NSDate *today = [[NSDate alloc] init];
    NSLog(@"startdate %@ and today %@", date, today);
    double countDownTimer;
    countDownTimer = [date timeIntervalSinceDate:today];

    secondsLeft = countDownTimer;
    NSLog(@"secondsLeft %d", secondsLeft);
    //  self.countDownView.countDownTime.backgroundColor = [UIColor greenColor];
    self.countDownView.meetingRoomStatus.text = @"Room is available for the next";

    if (secondsLeft <= 0) {
        NSDate *endDate = [[NSDate alloc] init];
        Reservation *firstReservation = [[Reservation alloc] init];
        firstReservation = [[self.reservationsByDate objectForKey:[self.reservationDates objectAtIndex:clockSection]] objectAtIndex:clockIndexPath];
        endDate = firstReservation.endTime;

        NSDate *today = [[NSDate alloc] init];
        NSLog(@"startdate %@ and today %@", date, today);
        double countDownTimer;
        countDownTimer = [endDate timeIntervalSinceDate:today];

        secondsLeft = countDownTimer;
        NSLog(@"secondsLeft %d", secondsLeft);
        self.countDownView.meetingRoomStatus.text = @"Room will be available in";
        //  self.countDownView.countDownTime.backgroundColor = [UIColor app_lightRed];

    }


    [self countdownTimer];

}


- (void)updateCounter:(NSTimer *)theTimer {
    if (secondsLeft > 0) {
        secondsLeft--;
        days = secondsLeft / 86400;
        hours = (secondsLeft % 86400) / 3600;
        minutes = ((secondsLeft % 86400) % 3600) / 60;
        seconds = ((secondsLeft % 86400) % 3600) % 60;

        NSString *dayString;
        dayString = (days == 1) ? @"day" : @"days";

        NSString *hourString;
        hourString = (hours == 1) ? @"hour" : @"hours";

        NSString *minuteString;
        minuteString = (minutes == 1) ? @"minute" : @"minutes";

        //TODO if days is 0, don't show days
        self.countDownView.countDownTime.text = [NSString stringWithFormat:@"%d %@, %02d %@ & %02d %@", days, dayString, hours, hourString, minutes, minuteString];
    }
    else {
        if (secondsLeft <= 0) {
            clockReservation = FALSE;

            [self.countDownView.tableView reloadData];
            //determine startTime of next meeting to calculate Count Down Clock:
            NSDate *startDate = [[NSDate alloc] init];
            Reservation *firstReservation = [[Reservation alloc] init];
            firstReservation = [[self.reservationsByDate objectForKey:[self.reservationDates objectAtIndex:clockSection]] objectAtIndex:clockIndexPath];
            startDate = firstReservation.startTime;
            [timer invalidate];
            [self setUpTimer:startDate];
        }

    }
}


- (void)countdownTimer {

    // secondsLeft = hours = minutes = seconds = 0;
    if ([timer isValid]) {;
    }

    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];

}


#pragma mark - actions

- (void)_didTapSettings {

    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    settingsViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    settingsViewController.delegate = self;
    [self.navigationController presentViewController:settingsViewController animated:YES completion:nil];
}



- (void)didChangeSettingsToDefaultMeetingRoom:(MeetingRoom *)defaultMeetingRoom {
    NSLog(@"in delegate method");
    self.meetingRoom = defaultMeetingRoom;
    [self viewWillAppear:YES];
}

@end



