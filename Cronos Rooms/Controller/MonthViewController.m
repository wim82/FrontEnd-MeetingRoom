//
//  MonthOverviewController.m
//  Cronos Rooms
//
//  Created by Katrien De Mey on 13/04/14.
//  Copyright (c) 2014 KaWi. All rights reserved.
//

#import "MonthViewController.h"
#import "MonthCell.h"
#import "MonthOverview.h"
#import "MonthHeader.h"
#import "PublicHolidayService.h"
#import "PublicHoliday.h"
#import "UIColor+AppColor.h"
#import "ReservationService.h"
#import "NSDate+Helper.h"
#import "MeetingRoom.h"
#import "EditReservationViewController.h"
#import "DayViewController.h"
#import "AppState.h"

#define CELL_IDENTIFIER_MONTHDAY @"MonthCell"
#define HEADER_IDENTIFIER_MONTH @"MonthHeaderView"

@interface MonthViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSMutableDictionary *monthsAndDaysDictionary;
    
    NSMutableArray *keyArray;
    NSCalendar *calendar;
    NSMutableDictionary * months;
    NSMutableArray *daysInMonthArray;
    
    NSInteger roomId;
    NSDate * startDate;
    NSInteger amount;
    NSDate * today;
}

@property (nonatomic, strong) MonthOverview * viewMonthOverview;
@property (nonatomic)BOOL screenHasRotated;
@property (nonatomic, strong) NSArray * arrayOfDays;
@property (nonatomic,strong) MonthHeader *headerView;
@property (nonatomic, strong) UILabel * lblHeader;
@property (nonatomic,strong) NSDate *today;
@property (nonatomic,strong) NSDate *dayInArray;


@end

@implementation MonthViewController



- (void)loadView{
    
    self.viewMonthOverview = [[MonthOverview alloc]initWithFrame: [UIScreen mainScreen].bounds andDelegate:self];
    self.view = self.viewMonthOverview;
    
    if (!self.meetingRoom) {
        self.meetingRoom = [[MeetingRoom alloc] init];
        self.meetingRoom.roomId = 1;
        self.meetingRoom.roomName = @"dit zou niet mogen";
    }
    self.navigationItem.title = self.meetingRoom.roomName;
    
    [self buildDaysInMonths];

}



- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!self.screenHasRotated){
        [self loadConstraints];
    }
    
    self.title = self.meetingRoom.roomName;
    
    [self.viewMonthOverview.collectionView registerClass:[MonthCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER_MONTHDAY];
    [self.viewMonthOverview.collectionView registerClass:[MonthHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADER_IDENTIFIER_MONTH];

    
   //load data from database: reservations per meetingroom and public holidays
    
    [self _loadPublicHolidays];
    NSLog(@"startDate %@", startDate);
    [self _loadReservations: self.meetingRoom.roomId: startDate : 450];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate{
    return TRUE;
}


#pragma mark - UICollectionViewData

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return [monthsAndDaysDictionary count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [[monthsAndDaysDictionary objectForKey:[keyArray objectAtIndex:section]] count];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MonthCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER_MONTHDAY forIndexPath:indexPath];

    cell.lblName.text=@"";
    cell.backgroundColor=[UIColor app_snowWhiteShade];
    self.today=[[NSDate alloc]init];
    self.dayInArray=[[NSDate alloc]init];
    self.dayInArray=[[monthsAndDaysDictionary objectForKey:[keyArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] ;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    if ([[dateFormat stringFromDate:self.dayInArray] isEqualToString:[dateFormat stringFromDate:self.today]])
    {
        cell.backgroundColor=[UIColor app_blueGrey];
    }
    
    
    [self fillCellWithReservationsAndHolidays:cell];

    
    //remove the fakeCells TODO: make the fakecells inactive
    NSDateComponents *components = [calendar components:NSYearCalendarUnit
                                    | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self.dayInArray];
    if (components.year !=1970){
        cell.lblName.text = [NSString stringWithFormat:@"%d",components.day];
      
    }
    else{
        cell.backgroundColor=[UIColor clearColor];
        
    }
    
    [self gestureRecognition:cell:indexPath.row];
    
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(self.viewMonthOverview.collectionView.frame.size.width, 50);
    
}

- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    MonthHeader * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                               UICollectionElementKindSectionHeader withReuseIdentifier:HEADER_IDENTIFIER_MONTH forIndexPath:indexPath];
   
    NSString *headerText =  [keyArray objectAtIndex:indexPath.section] ;
    headerView.lblHeader.text= headerText;
    
    return headerView;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DayViewController *dayViewController = [[DayViewController alloc] init];
    dayViewController.meetingRoom =self.meetingRoom;
    NSDate *date=[[NSDate alloc]init];
    date=[[monthsAndDaysDictionary objectForKey:[keyArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] ;
    dayViewController.date=date;

    [self.navigationController pushViewController:dayViewController animated:YES];
   
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = CGRectGetWidth(self.viewMonthOverview.bounds);
    return CGSizeMake(width/8,100);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(50, 20,50, 20);
}


#pragma mark - building blocks of monthView

-(void)buildDaysInMonths{
    
    //TODO #define number of days to prefill in the calendar (back in history/days before today) And number of months in calendar
    NSInteger xNumberOfDays=-10;
    NSInteger numberOfMonths=11;
    
    NSDate *date=[[NSDate alloc]init]; //vandaag
    
    startDate = [self fillWithXNumberOfDays:date: xNumberOfDays];
    
    monthsAndDaysDictionary=[[NSMutableDictionary alloc]init];
    calendar = [NSCalendar autoupdatingCurrentCalendar];
    keyArray = [[NSMutableArray alloc]init]; //months in Array, starting with first month corresponding with startDate
    
    date=startDate;
    // NSLog(@"date is : %@", date);
    
    //volgende dag
    NSDate *nextDate = [self fillWithXNumberOfDays:date :1];
    
    
    daysInMonthArray=[[NSMutableArray alloc]init]; //array of all the days in a Month, including the fake dates
    for (int i=1; i<=numberOfMonths; i++){
        [keyArray addObject:[self displayStringMonthFromDate:date]];  //fill keyArray with corresponding months of the dictionary
        
        //check if first of month is a Monday or not. add fake date cell to beginning of the month to start from Monday column (note: Sunday=1)
      //  int dayOfWeek = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date] weekday];
        //  NSLog(@"dayofweek : %d", dayOfWeek);
        NSString *weekDay= [date stringWithFormat:DATEFORMAT_WEEKDAY];
        if ([weekDay isEqualToString:@"Sunday"]){
            for (int j=0; j<6; j++){
                [daysInMonthArray addObject:[self fakeDate]];
            }}
        if ([weekDay isEqualToString:@"Tuesday"]){
            [daysInMonthArray addObject:[self fakeDate]];
        }
        if ([weekDay isEqualToString:@"Wednesday"]){
            for (int j=0; j<2; j++){
                [daysInMonthArray addObject:[self fakeDate]];
            }}
        if ([weekDay isEqualToString:@"Thursday"]){
            for (int j=0; j<3; j++){
                [daysInMonthArray addObject:[self fakeDate]];
            }}
        if ([weekDay isEqualToString:@"Friday"]){
            for (int j=0; j<4; j++){
                [daysInMonthArray addObject:[self fakeDate]];
            }}
        if ([weekDay isEqualToString:@"Saturday"]){
            for (int j=0; j<5; j++){
                [daysInMonthArray addObject:[self fakeDate]];
            }}
        
        
        [daysInMonthArray addObject:date];
        
        
        while ([[self displayStringMonthFromDate:date] isEqualToString:[self displayStringMonthFromDate:nextDate]]){
            [daysInMonthArray addObject:nextDate];
            date=nextDate;
            nextDate = [self fillWithXNumberOfDays:date :1];
        }
        
        [monthsAndDaysDictionary setObject:daysInMonthArray forKey:[self displayStringMonthFromDate:date]];
        date=nextDate;
        nextDate = [self fillWithXNumberOfDays:date :1];
        daysInMonthArray = [[NSMutableArray alloc]init];
    
}
}

-(void)fillCellWithReservationsAndHolidays:(MonthCell *)cell {
    NSString * dayContent  = [[NSString alloc]init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    for(int i=0;i<[self.reservationsPerRoom count]; i++){
        Reservation *reservation = [self.reservationsPerRoom objectAtIndex:i];
        
        if ([[dateFormat stringFromDate:self.dayInArray] isEqualToString:[dateFormat stringFromDate:reservation.startTime]])
        {
            cell.backgroundColor=[UIColor app_lightYellow];
            dayContent=[dayContent stringByAppendingString:reservation.reservationDescription];
            dayContent=[dayContent stringByAppendingString:@"\n"] ;
            
        }}
    
    
    for(int i=0;i<[self.publicHolidays count]; i++){
        PublicHoliday *publicHoliday = [self.publicHolidays objectAtIndex:i];
        if ([[dateFormat stringFromDate:self.dayInArray] isEqualToString:[dateFormat stringFromDate:publicHoliday.holidayDate]])
        {
            cell.backgroundColor=[UIColor app_lightRed];
            dayContent=[dayContent stringByAppendingString:publicHoliday.holidayName];
        }}
    
    
    //TODO: ipad/iphone check --> use different cells is probably a better solution
    if([[AppState sharedInstance] deviceIsiPad]){
        cell.lblReservations.text = dayContent;
    }
    
    
    
}


#pragma mark -  tap and longpress actions and recognizer

//this adds tap and long press gesture recognizer to the cell with number indexpath.row
-(void) gestureRecognition:(MonthCell *) cell : (NSInteger) row {
    
    cell.tag = row;

    //Long Press
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2; //seconds
    lpgr.delegate=self;
    [cell addGestureRecognizer:lpgr];

    
}



- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint p = [gestureRecognizer locationInView:self.viewMonthOverview.collectionView];
        
        NSIndexPath *indexPath = [self.viewMonthOverview.collectionView indexPathForItemAtPoint:p];
        if (indexPath == nil) {
            NSLog(@"long press on table view but not on a row");
        } else {
            UICollectionViewCell *cell = [self.viewMonthOverview.collectionView cellForItemAtIndexPath:indexPath];
            if (cell.isHighlighted) {
                NSLog(@"long press on table view at section %d row %d", indexPath.section, indexPath.row);
                NSIndexPath *cellIndexPath = [self.viewMonthOverview.collectionView indexPathForCell:cell];
                
                NSDate *date=[[NSDate alloc]init];
                date=[[monthsAndDaysDictionary objectForKey:[keyArray objectAtIndex:cellIndexPath.section]] objectAtIndex:cellIndexPath.row] ;
                Reservation *reservation = [[Reservation alloc] init];
                reservation.meetingRoom = self.meetingRoom;
                reservation.startTime=date;
                EditReservationViewController *editReservationViewController = [[EditReservationViewController alloc] init];
                editReservationViewController.reservation = reservation;
                [self.navigationController pushViewController:editReservationViewController animated:YES];
                
                
            }
        }
    }
}


#pragma mark - access DataBase

- (void) _loadPublicHolidays {
    
[[PublicHolidayService sharedService] getAllPublicHolidaysWithSuccessHandler:^(NSMutableArray *publicHolidays) {
    self.publicHolidays = [[NSArray alloc] initWithArray:publicHolidays];
    [self.viewMonthOverview .collectionView reloadData];
    
} andErrorHandler:^(NSException * exception) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}];
}

-(void) _loadReservations: (NSInteger) roomId : (NSDate *) startDate : (NSInteger) amount{
  [[ReservationService sharedService] getReservationsForRoomId:roomId fromDate: startDate forAmountOfDays: amount withSuccesHandler:^(NSMutableArray *reservationsPerRoom) {
      self.reservationsPerRoom = [[NSMutableArray alloc] initWithArray:reservationsPerRoom];
      [self.viewMonthOverview .collectionView reloadData];
  } andErrorHandler:^(NSException * exception) {
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
      [alertView show];
  }];
    
}


#pragma mark - orientation checks


- (void)willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
   [self.viewMonthOverview.collectionView  setFrame:CGRectMake(0, 0, super.view.frame.size.width, super.view.frame.size.height)];
    if([[AppState sharedInstance] deviceIsLandscape]){
        [self.headerView loadConstraintsForLandscape];
    }else {
        [self.headerView loadConstraintsForPortrait];
    }
    
    [self.viewMonthOverview.collectionView.collectionViewLayout invalidateLayout];
    [self.viewMonthOverview.collectionView  reloadData];

    
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    self.viewMonthOverview.collectionView.frame = CGRectMake(0, 0, super.view.frame.size.width, super.view.frame.size.height);
    if([[AppState sharedInstance] deviceIsLandscape]){
        [self.headerView loadConstraintsForLandscape];
    }else {
        [self.headerView loadConstraintsForPortrait];
    }
    
    [self.viewMonthOverview.collectionView.collectionViewLayout invalidateLayout];
    [self.viewMonthOverview.collectionView  reloadData];
   
    
    
}

- (void)loadConstraints{
    
    if([[AppState sharedInstance] deviceIsLandscape]){
        [self loadConstraintsForLandscape];
    }else {
        [self loadConstraintsForPortrait];
    }
    
}

- (void)loadForInterfaceOrientation:(UIInterfaceOrientation)orientation{
    
    if([[AppState sharedInstance] deviceIsLandscape]){
        [self.viewMonthOverview loadConstraintsForPortrait];
        [self.headerView loadConstraintsForPortrait];
    }else{
        [self.viewMonthOverview loadConstraintsForLandscape];
        [self.headerView loadConstraintsForPortrait];
        
    }
    
}

- (void)loadConstraintsForLandscape{
    
    [self.viewMonthOverview loadConstraintsForLandscape];
    [self.headerView loadConstraintsForPortrait];
    [self loadView];
}

- (void)loadConstraintsForPortrait{
    
    [self.viewMonthOverview loadConstraintsForPortrait];
    [self.headerView loadConstraintsForPortrait];
    [self loadView];
}



#pragma marks - date calculators

//add dates (if negative, go back in time. if positive, go in the future)
-(NSDate *) fillWithXNumberOfDays:(NSDate *) today : (NSInteger) xNumber{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit
                                    | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
    components.day+=xNumber;
    NSDate * date=[[NSCalendar currentCalendar] dateFromComponents:components];
    return date;
    
}

+ (NSDate *)dateWithOutTime:(NSDate *)date {
    if (date == nil ) {
        date = [NSDate date];
    }
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}


- (NSString *)displayStringMonthFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM"];
    return [dateFormatter stringFromDate:date];
    
    
}

- (NSString *)displayStringDayFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    return [dateFormatter stringFromDate:date];
    
    
}

//fake date
- (NSDate *) fakeDate{
NSDateComponents *fakeComponents=[[NSDateComponents alloc]init];
[fakeComponents setDay:1];
[fakeComponents setMonth:1];
[fakeComponents setYear:1970];
    return [[NSCalendar currentCalendar] dateFromComponents:fakeComponents] ;
   
}

@end
