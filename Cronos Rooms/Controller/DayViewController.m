//
// Created by Jean Smits on 9/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import "DayViewController.h"
#import "DayView.h"
#import "DayQuarterHourViewCell.h"
#import "ReservationService.h"
#import "PublicHolidayService.h"
#import "IReservationSelector.h"
#import "EditReservationViewController.h"
#import "NSDate+Helper.h"
#import "DayTitleView.h"
#import "PublicHoliday.h"
#import "UIColor+AppColor.h"

#define DAYQUARTERHOURVIEWCELL_IDENTIFIER @"DayQuarterHourViewCell"

@interface DayViewController () <UITableViewDataSource, UITableViewDelegate, IReservationSelector>

@property(nonatomic, strong) DayView *dayView;
@property(nonatomic, strong) NSArray *hours;
@property(nonatomic, strong) DayTitleView *dayTitleView;

@property(nonatomic, strong) NSMutableArray *reservations;
@property(nonatomic, strong) NSMutableArray *publicHolidays;
@property(nonatomic, strong) UIScrollView *scrollView;

@end

@implementation DayViewController


- (void)loadView {

    //hours needed to display
    self.hours = [[NSArray alloc] initWithObjects:@"", @"01:00", @"02:00", @"03:00", @"04:00", @"05:00", @"06:00", @"07:00", @"08:00", @"09:00", @"10:00", @"11:00", @"12:00", @"13:00", @"14:00", @"15:00", @"16:00", @"17:00", @"18:00", @"19:00", @"20:00", @"21:00", @"22:00", @"23:00", nil];


    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor=[UIColor whiteColor];

    //TODO: make sure navigationcontroller displays current date & meeting room as title +
    if (!self.date){
        self.date = [[NSDate alloc] init];
    }
    
    if (!self.meetingRoom) {
        self.meetingRoom = [[MeetingRoom alloc] init];
        self.meetingRoom.roomId = 1;
        self.meetingRoom.roomName = @"dit zou niet mogen";
    }
    self.navigationItem.title = self.meetingRoom.roomName;
    

}



- (void)viewDidLoad {

    //visual setup dayview table

    self.dayTitleView = [[DayTitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) andDate:self.date];
    [self.view addSubview:self.dayTitleView];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.dayTitleView.frame.origin.y + self.dayTitleView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.dayTitleView.frame.size.height)];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, (self.hours.count * 4) * 16);

    [self.view addSubview:self.scrollView];


    self.dayView = [[DayView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 96 * 16) andDelegate:self];


    self.dayView.dayTableView.scrollEnabled = NO;
    [self.scrollView addSubview:self.dayView];
    [self.dayView.dayTableView registerClass:[DayQuarterHourViewCell class] forCellReuseIdentifier:DAYQUARTERHOURVIEWCELL_IDENTIFIER];

    //load data
    [self _loadReservations];
    [self _loadPublicHolidays];

    //scroll to about 7am. -> test this look look on different screens?
    [self.scrollView scrollRectToVisible:CGRectMake(0, 7 * 4 * 16 + self.scrollView.frame.size.height - self.navigationController.navigationBar.frame.size.height, 1, 1) animated:YES];

}


- (void)viewWillAppear:(BOOL)animated {
    //scroll to about 7am. -> test this look look on different screens?
    [self.scrollView scrollRectToVisible:CGRectMake(0, 7 * 4 * 16 + self.scrollView.frame.size.height - self.navigationController.navigationBar.frame.size.height, 1, 1) animated:YES];

    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];


    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];


}

- (void)didSwipeLeft {
    NSLog(@"did swipe left");
    self.date = [self.date dateByAddingTimeInterval:60 * 60 * 24];
   self.dayTitleView.dayNameLabel.text = [self.date stringWithFormat:@"cccc, d MMM yyyy"];
    [self _loadReservations];
    [self checkIfPublicHoliday];
}


- (void)didSwipeRight {
    NSLog(@"did swipe right");
    self.date = [self.date dateByAddingTimeInterval:-(60 * 60 * 24)];
    self.dayTitleView.dayNameLabel.text  = [self.date stringWithFormat:@"cccc, d MMM yyyy"];
    [self _loadReservations];
    [self checkIfPublicHoliday];
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

        NSInteger startInQuarterHours = [reservation.startTime timeInQuarterHours];
        NSInteger endInQuarterHours = [reservation.endTime timeInQuarterHours];
        NSInteger lengthOfReservationInQuarterHours = endInQuarterHours - startInQuarterHours;

        //if we have a reservation
        if (indexPath.row == startInQuarterHours) {
            //connect a reservation to a cell
            cell.reservation = reservation;

            //if the cell is too small to show text
            if (lengthOfReservationInQuarterHours < 2) {
                //TODO: repair this silly hack to display dots.
                cell.reservationDescription.text = @"°°°";
            } else {
                cell.reservationDescription.text = [NSString stringWithFormat:@"%@\nby %@", [reservation.reservationDescription capitalizedString], [reservation.user.fullName lowercaseString]];
            }

            cell.hourSeparator.hidden = NO;
            //incredible animation
            [UIView animateWithDuration:0.3 animations:^{
                [cell colorReservationBlockWithLength:lengthOfReservationInQuarterHours];
            }];

        }

        //the cells beloning to a reservation should contain all necessary reservation info as well
        if (indexPath.row > startInQuarterHours && indexPath.row < (endInQuarterHours - startInQuarterHours) + startInQuarterHours) {
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



#pragma mark - Navigation

- (void)didTapReservation:(Reservation *)reservation {
    if (reservation) {
        EditReservationViewController *editReservationViewController = [[EditReservationViewController alloc] init];
        editReservationViewController.reservation = reservation;
        [self.navigationController pushViewController:editReservationViewController animated:YES];
    }
}



#pragma mark - Private Methods

- (void)_loadReservations {

    [[ReservationService sharedService] getReservationsForRoomId:self.meetingRoom.roomId fromDate:self.date forAmountOfDays:1 withSuccesHandler:^(NSMutableArray *reservations) {
        self.reservations = [[NSMutableArray alloc] initWithArray:reservations];
        [self.dayView.dayTableView reloadData];

    }
                                                 andErrorHandler:^(NSException *exception) {
                                                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                     [alertView show];
                                                 }];

}

- (void) _loadPublicHolidays {
    
    [[PublicHolidayService sharedService] getAllPublicHolidaysWithSuccessHandler:^(NSMutableArray *publicHolidays) {
        self.publicHolidays = [[NSMutableArray alloc] initWithArray:publicHolidays];
        [self checkIfPublicHoliday];
        [self.dayView.dayTableView reloadData];
        
    } andErrorHandler:^(NSException * exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
    
    
}

- (void) checkIfPublicHoliday{
    
    
    for (PublicHoliday *publicHoliday in self.publicHolidays) {
         if ([[self.date stringWithFormat:DATEFORMAT_COMPAREDATE] isEqualToString:[publicHoliday.holidayDate stringWithFormat:DATEFORMAT_COMPAREDATE]])
        {
            self.dayView.dayTableView.backgroundColor=[[UIColor app_ultraLightGrey] colorWithAlphaComponent:0.5];
            break;
        }
        else {
            self.dayView.dayTableView.backgroundColor=[UIColor whiteColor];
        }
    
    }
    

}




@end


