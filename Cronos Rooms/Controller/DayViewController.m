//
// Created by Jean Smits on 9/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import "DayViewController.h"
#import "DayView.h"
#import "DayQuarterHourViewCell.h"
#import "DateHelper.h"
#import "ReservationService.h"
#import "Reservation.h"

#define DAYQUARTERHOURVIEWCELL_IDENTIFIER @"DayQuarterHourViewCell"

@interface DayViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) DayView *dayView;
@property(nonatomic, strong) NSArray *hours;
@property(nonatomic, assign) NSInteger meetingDuration;  //in quarter hours
@property(nonatomic, strong) NSDate *startTime;
@property(nonatomic, strong) NSMutableArray *reservations;
@end

@implementation DayViewController


- (void)loadView {

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = scrollView;
    self.meetingDuration = 10;
    self.startTime = [[DateHelper datetimeFormatter] dateFromString:@"20140509 09:30"];

    self.navigationItem.title = @"Day Grid Tester";
    self.navigationController.navigationBar.translucent = NO;
    self.hours = [[NSArray alloc] initWithObjects:@"00:00", @"01:00", @"02:00", @"03:00", @"04:00", @"05:00", @"06:00", @"07:00", @"08:00", @"09:00", @"10:00", @"11:00", @"12:00", @"13:00", @"14:00", @"15:00", @"16:00", @"17:00", @"18:00", @"19:00", @"20:00", @"21:00", @"22:00", @"23:00", nil];
}


- (void)viewDidLoad {
    self.dayView = [[DayView alloc] initWithFrame:self.view.frame andDelegate:self];
    [self.view addSubview:self.dayView];
    [self.dayView.dayTableView registerClass:[DayQuarterHourViewCell class] forCellReuseIdentifier:DAYQUARTERHOURVIEWCELL_IDENTIFIER];
    [self _loadReservations];

}

- (void)_loadReservations {


    //make the call
    [[ReservationService sharedService] getReservationsForRoomId:1 fromDate:self.startTime forAmountOfDays:1 withSuccesHandler:^(NSMutableArray *reservations) {
        self.reservations = [[NSMutableArray alloc] initWithArray:reservations];
        NSLog(@"ik heb er weer eentje binnen");
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 96;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //i don't reuse cells, because it seems really complicated to deal with the reuse pattern. can somebody tell me about the performance hit?
    DayQuarterHourViewCell *cell = [[DayQuarterHourViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [self tableView:nil heightForRowAtIndexPath:indexPath])];


    //cell.meetingDescription.text = @"meeting descriptie kwartiertje";

    //print the hours
    if (indexPath.row % 4 == 0) {
        cell.hourTitle.text = self.hours[indexPath.row / 4];
    }

    //TODO: optimize this code
    for (Reservation *reservation in self.reservations) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:reservation.startTime];
        NSInteger hour = [components hour];
        NSLog(@"date: %@", self.startTime);
        // NSLog(@"%i", hour);
        NSInteger minute = [components minute];
        // NSLog(@"%i", minute);
        NSInteger result = hour * 4 + minute;

        // NSLog(@"%i == indexpath.row %i",result, indexPath.row);
        if (indexPath.row == result) {
            cell.meetingDescription.text = @"hoppppppa";
            cell.meetingDescription.backgroundColor = [UIColor redColor];
            //   NSLog(@"allez");
        }

       /* unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;

        NSDateComponents *conversionInfo = [currentCa components:unitFlags fromDate:m_fromDepTime  toDate:m_toArrTime  options:0];

        int months = [conversionInfo month];
        int days = [conversionInfo day];
        int hours = [conversionInfo hour];
        int minutes = [conversionInfo minute];
         */
        if (indexPath.row > result && indexPath.row < 3 + result) {

            cell.meetingDescription.backgroundColor = [UIColor redColor];
            // NSLog(@"allez");
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


@end


