//
// Created by Jean Smits on 9/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import "DayViewController.h"
#import "DayView.h"
#import "DayQuarterHourViewCell.h"
#import "DateHelper.h"
#import "ReservationService.h"
#import "IReservationSelector.h"
#import "EditReservationViewController.h"

#define DAYQUARTERHOURVIEWCELL_IDENTIFIER @"DayQuarterHourViewCell"

@interface DayViewController () <UITableViewDataSource, UITableViewDelegate, IReservationSelector>

@property(nonatomic, strong) DayView *dayView;
@property(nonatomic, strong) NSArray *hours;
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, strong) NSMutableArray *reservations;
@property(nonatomic, strong) UIScrollView *scrollView;

@end

@implementation DayViewController


- (void)loadView {

    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 96 * 16);
    self.view = self.scrollView;

    //TODO: make sure navigationcontroller displays current date & meeting room as title +
    self.date = [[DateHelper datetimeFormatter] dateFromString:@"20140509 09:30"];
    self.navigationItem.title = [[DateHelper datetimeFormatter] stringFromDate:self.date];

    //hours needed to display
    self.hours = [[NSArray alloc] initWithObjects:@"", @"01:00", @"02:00", @"03:00", @"04:00", @"05:00", @"06:00", @"07:00", @"08:00", @"09:00", @"10:00", @"11:00", @"12:00", @"13:00", @"14:00", @"15:00", @"16:00", @"17:00", @"18:00", @"19:00", @"20:00", @"21:00", @"22:00", @"23:00", nil];
}


- (void)viewDidLoad {

    //visual setup dayview table
    self.dayView = [[DayView alloc] initWithFrame:CGRectMake(0, -1, self.view.frame.size.width, 96 * 16) andDelegate:self];
    self.dayView.dayTableView.scrollEnabled = NO;
    [self.view addSubview:self.dayView];
    [self.dayView.dayTableView registerClass:[DayQuarterHourViewCell class] forCellReuseIdentifier:DAYQUARTERHOURVIEWCELL_IDENTIFIER];

     //load data
    [self _loadReservations];

    //scroll to about 7am. -> test this look look on different screens?
    [self.scrollView scrollRectToVisible:CGRectMake(0, 1000, 1, 1) animated:YES];

}

- (void)_loadReservations {

    [[ReservationService sharedService] getReservationsForRoomId:1 fromDate:self.date forAmountOfDays:1 withSuccesHandler:^(NSMutableArray *reservations) {
        self.reservations = [[NSMutableArray alloc] initWithArray:reservations];
        [self.dayView.dayTableView reloadData];


    }                                            andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];

}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableView & UITableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.hours count] * 4; //rows = an hour has 4 quarter hours
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //i don't reuse cells, because it seems really complicated to deal with the reuse pattern. can somebody tell me about the performance hit?
    DayQuarterHourViewCell *cell = [[DayQuarterHourViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [self tableView:nil heightForRowAtIndexPath:indexPath]) andDelegate:self];


    //cell.reservationDescription.text = @"meeting descriptie kwartiertje";

    //print the hours
    if (indexPath.row % 4 == 0) {
        cell.hourTitle.text = self.hours[indexPath.row / 4];
        cell.hourSeparator.hidden = NO;
    }

    //TODO: optimize this code
    for (Reservation *reservation in self.reservations) {

        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:reservation.startTime];
        NSInteger startHour = [components hour];
        NSInteger startMinute = [components minute];
        NSInteger startInQuarterHours = (startHour * 4) + (startMinute / 15);

        NSDateComponents *endComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:reservation.endTime];
        NSInteger endHour = [endComponents hour];
        NSInteger endMinute = [endComponents minute];
        NSInteger endInQuarterHours = (endHour * 4) + (endMinute / 15);
        NSInteger lengthOfMeeting = endInQuarterHours - startInQuarterHours;

        //if we have a meeting
        if (indexPath.row == startInQuarterHours) {
            if (lengthOfMeeting < 2) {
                //TODO: repair this silly hack to display dots.
                cell.reservationDescription.text = @"°°°";
            } else {
                cell.reservationDescription.text = [NSString stringWithFormat:@"%@\nby %@", [reservation.reservationDescription capitalizedString], [reservation.user.fullName lowercaseString]];
            }
            cell.hourSeparator.hidden = NO;
            [cell setMeetingDescriptionHeight:lengthOfMeeting];
            cell.reservation = reservation;
        }


        if (indexPath.row > startInQuarterHours && indexPath.row < (endInQuarterHours - startInQuarterHours) + startInQuarterHours) {
            // cell.backgroundColor = [UIColor lightGrayColor];
            cell.reservation = reservation;
        }

    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 16;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)didTapReservation:(Reservation *)reservation {
    if (reservation) {
        EditReservationViewController *editReservationViewController = [[EditReservationViewController alloc] init];
        editReservationViewController.reservation = reservation;
        [self.navigationController pushViewController:editReservationViewController animated:YES];
    }
}


@end


