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

#define TABLEVIEWCELL_IDENTIFIER @"reservationCell"
#define TABLEVIEWHEADER_IDENTIFIER @"reservationHeader"

@interface CountDownViewController ()<UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate, UISearchBarDelegate, UISearchDisplayDelegate>


@property(nonatomic, strong) NSMutableDictionary *reservationsByDate;
@property(nonatomic) NSMutableArray *reservationDates;
@property (nonatomic, strong) CountDownView * countDownView;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *today;

@end

@implementation CountDownViewController


int hours, minutes, seconds;
int secondsLeft;

- (void)loadView {
    self.countDownView = [[CountDownView alloc]initWithFrame:[UIScreen mainScreen].bounds andDelegate:self];
    self.view = self.countDownView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //register reuseable cells
    [self.countDownView.tableView registerClass:[ReservationTableViewCell class] forCellReuseIdentifier:TABLEVIEWCELL_IDENTIFIER];
    [self.countDownView.tableView registerClass:[ReservationTableViewHeader class] forHeaderFooterViewReuseIdentifier:TABLEVIEWHEADER_IDENTIFIER];
    

    
    [self _setUpNavigationController];
    
    self.countDownView.backgroundColor = [UIColor purpleColor];
    
 /*   NSDate *startDate=[[NSDate alloc]init];
    startDate=[[self.reservationsByDate objectForKey:[self.reservationDates objectAtIndex:0]] objectAtIndex:0];
    NSDate *today = [[NSDate alloc]init];
    NSLog(@"startdate %@ and today %@", startDate, today);
    NSLog(@"Seconds --------> %f",[[NSDate date] timeIntervalSinceDate: self.startDate]);
    secondsLeft = 16925;
    [self countdownTimer];
  */
    //[timer invalidate]   implement this on the backbutton of navigation controller when
}

- (void)viewWillAppear:(BOOL)animated {
    //TODO: write code to see what is the "meetingroom"
    if (!self.meetingRoom) {
        self.meetingRoom = [[MeetingRoom alloc] init];
        self.meetingRoom.roomId = 1;}
    
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
    
    //TODO: use custom cell instead of the UITableViewCellStyleSubtitle cell
    
    cell.textLabel.textColor = [UIColor darkTextColor];
    cell.textLabel.text = [reservation.reservationDescription capitalizedString];
    
    
    cell.detailTextLabel.textColor = [UIColor app_grey];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
    //TODO check the name of the user of the reservation
    cell.detailTextLabel.text = [NSString stringWithFormat:@"User %ld           %@ - %@", (long)reservation.user.userId, [reservation.startTime stringWithFormat:DATEFORMAT_SHORT_TIME], [reservation.endTime stringWithFormat:DATEFORMAT_SHORT_TIME]];
    
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
            
            if ([[self.reservationsByDate objectForKey:[self.reservationDates objectAtIndex:cellIndexPath.section]] count]==0){
                
                [self.reservationsByDate removeObjectForKey:[self.reservationDates objectAtIndex:cellIndexPath.section]];
                [self.reservationDates removeObjectAtIndex:cellIndexPath.section];
                [self.countDownView.tableView deleteSections:[NSIndexSet indexSetWithIndex:cellIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else {
                [self.countDownView.tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject:cellIndexPath ]
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
    
    NSDate *today = [[NSDate alloc]init];
    NSLog (@"today %@",today);
    
    
    //make the call
    [[ReservationService sharedService] getReservationsForRoomId:meetingRoom.roomId fromDate:today forAmountOfDays:365 withSuccesHandler:^(NSMutableArray * reservations) {
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
        
        
        NSDate *startDate=[[NSDate alloc]init];
        Reservation *firstReservation = [[Reservation alloc]init];
        firstReservation = [[self.reservationsByDate objectForKey:[self.reservationDates objectAtIndex:0]] objectAtIndex:0];
        startDate = firstReservation.startTime;
        NSLog(@"startdate %@", startDate);
        NSDate *today = [[NSDate alloc]init];
        NSLog(@"startdate %@ and today %@", startDate, today);
        double countDownTimer;
        countDownTimer = [startDate timeIntervalSinceDate: today];
        
        NSLog(@"Seconds --------> %f",countDownTimer);
        secondsLeft = countDownTimer;
        NSLog(@"secondsLeft %d", secondsLeft);
        [self countdownTimer];
        
        
        
        [self.countDownView.tableView reloadData];
        
        //code needed to fix trailing row ) - i don't really understand this either.
        [self.countDownView.tableView setContentInset:UIEdgeInsetsMake(0, 0, 84, 0)];
        
    
    } andErrorHandler:^(NSException * exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];

    
    
    
    
}


- (void)deleteReservation:(NSInteger)reservationId {
    ReservationService *reservationService = [ReservationService sharedService];
    
    [reservationService deleteReservation:reservationId withSuccesHandler:^(Reservation *reservation) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }                     andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error " message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}



- (void)didReceiveMemoryWarning
{
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
    
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0.0, -8, 0, 0);}


#pragma mark - Clock Counter

- (void)updateCounter:(NSTimer *)theTimer {
    if(secondsLeft > 0 ){
        NSLog(@"ben ik hier");
        secondsLeft -- ;
        hours = secondsLeft / 3600;
        minutes = (secondsLeft % 3600) / 60;
        seconds = (secondsLeft %3600) % 60;
        self.countDownView.countDownLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    }
  /*  else{
        NSLog(@"Kom ik hier in");
        secondsLeft = 16925;
    } */
}

-(void)countdownTimer{
    
   // secondsLeft = hours = minutes = seconds = 0;
    if([timer isValid])
    {
        ;
    }
    //  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    
}


#pragma mark - actions

- (void)_didTapSettings {
    
    SettingsViewController *settingsViewController = [[SettingsViewController alloc]init];
    settingsViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self.navigationController presentViewController:settingsViewController animated:YES completion:nil];
}


@end
