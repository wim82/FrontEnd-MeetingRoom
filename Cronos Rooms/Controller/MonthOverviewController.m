//
//  MonthOverviewController.m
//  Cronos Rooms
//
//  Created by Katrien De Mey on 13/04/14.
//  Copyright (c) 2014 KaWi. All rights reserved.
//

#import "MonthOverviewController.h"
#import "MonthCell.h"
#import "MonthOverview.h"
#import "MonthHeader.h"
#import "PublicHolidayService.h"
#import "PublicHoliday.h"
#import "UIColor+AppColor.h"
#import "ReservationService.h"

#define CELL_IDENTIFIER_MONTHDAY @"MonthCell"
#define HEADER_IDENTIFIER_MONTH @"MonthHeaderView"

@interface MonthOverviewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) MonthOverview * viewMonthOverview;

@property (nonatomic, strong) NSArray * arrayOfDays;

-(void) cellTapped;
-(void) handleLongPress;



@end

@implementation MonthOverviewController
NSMutableDictionary *monthsAndDaysDictionary;

NSMutableArray *keyArray;
NSCalendar *calendar;
NSMutableDictionary * months;
NSMutableArray * holidays;
NSMutableArray *timeStamp;
NSMutableArray *daysInMonthArray;
int roomId;
NSDate * startDate;
int amount;


- (void)viewWillAppear:(BOOL)animated{
   [self loadHolidays];
}

- (void)loadView{
    
    self.viewMonthOverview = [[MonthOverview alloc]initWithFrame:[UIScreen mainScreen].bounds andDelegate:self];
   // NSLog(@"viewdidload :%f", [UIScreen mainScreen].bounds.size.width);
    self.view = self.viewMonthOverview;
    
    
    //datum uitlezen
    months=[[NSMutableDictionary alloc]init];
    
    [months setObject:@"January" forKey:[NSNumber numberWithInt:1]];
    [months setObject:@"February" forKey:[NSNumber numberWithInt:2]];
    [months setObject:@"March" forKey:[NSNumber numberWithInt:3]];
    [months setObject:@"April" forKey:[NSNumber numberWithInt:4]];
    [months setObject:@"May" forKey:[NSNumber numberWithInt:5]];
    [months setObject:@"June" forKey:[NSNumber numberWithInt:6]];
    [months setObject:@"July" forKey:[NSNumber numberWithInt:7]];
    [months setObject:@"August" forKey:[NSNumber numberWithInt:8]];
    [months setObject:@"September" forKey:[NSNumber numberWithInt:9]];
    [months setObject:@"October" forKey:[NSNumber numberWithInt:10]];
    [months setObject:@"November" forKey:[NSNumber numberWithInt:11]];
    [months setObject:@"December" forKey:[NSNumber numberWithInt:12]];
    

    
    /*
     NSCalendar* cal = [NSCalendar   currentCalendar];
     NSDateComponents* comps = [[NSDateComponents alloc] init] ;
     
     // Set your month here
     [comps setMonth:38];
     
     NSRange range = [cal rangeOfUnit:NSDayCalendarUnit
     inUnit:NSMonthCalendarUnit
     forDate:[cal dateFromComponents:comps]];
     NSLog(@"%d", range.length); //geeft het aantal dagen van de maand
     */
    /*
     NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
     NSDateComponents *components = [calendar components:NSYearCalendarUnit
     | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
     
     NSLog(@"today %@", components);
     
     int dayofweek = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]] weekday];
     NSLog(@"dayofweek %d", dayofweek);
     
     //7 dagen terug rekenen
     for (int i = 0; i < 7; ++i) {
     NSDate *date = [calendar dateFromComponents:components];
     NSLog(@"%d days before today = %@", i, date);
     --components.day;
     }
     */
    
    monthsAndDaysDictionary=[[NSMutableDictionary alloc]init];
    calendar = [NSCalendar autoupdatingCurrentCalendar];
    keyArray = [[NSMutableArray alloc]init];
    
    //vandaag
    NSDate *date=[[NSDate alloc]init];
    
    
    
    date=[self prefillWithOneWeek: date];
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit
                                    | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    int monthOfDate= components.month;
    
    NSLog(@"maand is : %d",monthOfDate);
    
    
    //volgende dag
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:1];
    NSDate *nextDate = [calendar dateByAddingComponents:offsetComponents toDate:date options:0];
    NSDateComponents *nextComponents = [calendar components:NSYearCalendarUnit
                                        | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:nextDate];
    
    NSLog(@"vandaag : %@, en morgen : %@", date, nextDate);
    
    daysInMonthArray=[[NSMutableArray alloc]init];
    for (int i=1; i<=12; i++){
        [keyArray addObject:[NSNumber numberWithInt:components.month]];
        
        //check if first of month is a Monday or not. add fake date cell to beginning of the month to start from Monday column
        //fake date
        NSDateComponents *fakeComponents=[[NSDateComponents alloc]init];
        [fakeComponents setDay:1];
        [fakeComponents setMonth:1];
        [fakeComponents setYear:1970];
        NSDate *fakeDate=[[NSCalendar currentCalendar] dateFromComponents:fakeComponents] ;
        
        
        int dayofweek = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date] weekday];
       // NSLog(@"what day of the week? %d", dayofweek);
        if (dayofweek!=2){
            if (dayofweek==1){
                for (int j=0; j<(7-dayofweek); j++){
                    [daysInMonthArray addObject:fakeDate];
                    
                }}
            else{
                for (int j=0;j<(dayofweek-2); j++){
                    [daysInMonthArray addObject:fakeDate];
                }
            }
        }
        
        
        
        [daysInMonthArray addObject:date];
        
        
        while (components.month==nextComponents.month){
            [daysInMonthArray addObject:nextDate];
            date=nextDate;
            components=nextComponents;
            nextDate = [calendar dateByAddingComponents:offsetComponents toDate:date options:0];
            nextComponents = [calendar components:NSYearCalendarUnit
                              | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:nextDate];
            
        }
        int monthOfDate= components.month;
        // NSLog(@"array is :%@",daysInMonthArray);
        [monthsAndDaysDictionary setObject:daysInMonthArray forKey:[NSNumber numberWithInt:monthOfDate]];
        //  NSLog(@"%i dagen in maand : %@", daysInMonthArray.count, [months objectForKey:[NSNumber numberWithInt:monthOfDate]]);
        date=nextDate;
        components=nextComponents;
        nextDate = [calendar dateByAddingComponents:offsetComponents toDate:date options:0];
        nextComponents = [calendar components:NSYearCalendarUnit
                          | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:nextDate];
        daysInMonthArray=[[NSMutableArray alloc]init];
        
    }
    //  NSLog(@"dictionary: %@", [monthsAndDaysDictionary objectForKey:[NSNumber numberWithInt:8]]);
    
    
    
    
    
}

-(NSDate *) prefillWithOneWeek:(NSDate *)today {
    NSDateComponents *components = [calendar components:NSYearCalendarUnit
                                    | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
    components.day-=7;
    NSDate * date=[calendar dateFromComponents:components];
    NSLog (@" today : %@, and date : %@",today, date);
    return date;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSLog(@"de holidays inladen");
    [self loadHolidays];
    
    self.title = @"Month Overview";
    
    [self.viewMonthOverview.collectionView registerClass:[MonthCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER_MONTHDAY];
        
    [self.viewMonthOverview.collectionView registerClass:[MonthHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADER_IDENTIFIER_MONTH];
    
    
    
    // [self _getData];
    
    
    

    
    
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
    
    amount=[[monthsAndDaysDictionary objectForKey:[keyArray objectAtIndex:section]] count];
    
    NSLog(@"amount : %d", amount);
    
    NSArray *currentMonth =[monthsAndDaysDictionary objectForKey:[keyArray objectAtIndex:section]];
    NSDate *lastDay=[currentMonth objectAtIndex: amount-1];
    NSLog (@"lqstDay : %@", lastDay);
    
    NSDateComponents *lastDayComponents = [calendar components:NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit fromDate:lastDay];
    
    NSDateComponents *startComponents=[[NSDateComponents alloc]init];
    [startComponents setDay:1];
    [startComponents setMonth:[[keyArray objectAtIndex:section] integerValue]];
    // [startComponents setMonth:lastDayComponents.month];
     [startComponents setYear:lastDayComponents.year];
     

    startDate=[[NSCalendar currentCalendar] dateFromComponents:startComponents] ;
     NSLog (@"startDate : %@",startDate);
    [self loadReservationsPerMeetingRoom:1 : startDate : amount ];
    
    
    
    return amount;
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MonthCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER_MONTHDAY forIndexPath:indexPath];
    
    // Day * day = [self.arrayOfDays objectAtIndex:indexPath.row];
    cell.lblName.text=@"";
    cell.backgroundColor=[UIColor app_ultraLightGrey];
    NSDate *dayInArray=[[NSDate alloc]init];
    dayInArray=[[monthsAndDaysDictionary objectForKey:[keyArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] ;
    // NSLog(@"day: %@ and timestamp : %@", dayInArray, timeStamp);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    
    PublicHoliday *publicHoliday = [self.publicHolidays objectAtIndex:0];
    NSLog(@"public holiday (count : %i) : %@", self.publicHolidays.count, publicHoliday.holidayDate);
    
    
    for(int i=0;i<[self.publicHolidays count]; i++){
        PublicHoliday *publicHoliday = [self.publicHolidays objectAtIndex:i];
        NSLog(@"holiday in cell :  %@", publicHoliday.holidayDate);
        
        if ([[dateFormat stringFromDate:dayInArray] isEqualToString:[dateFormat stringFromDate: publicHoliday.holidayDate]])
        {
            cell.backgroundColor=[UIColor app_red];
        }}
    
    
    
    
    //TODO: put reservations in cell
    for(int i=0;i<[self.reservationsPerMonth count]; i++){
        Reservation *reservation = [self.reservationsPerMonth objectAtIndex:i];
        NSLog(@"reservation in cell :  %@", reservation.startTime);
        
        if ([[dateFormat stringFromDate:dayInArray] isEqualToString:[dateFormat stringFromDate: reservation.startTime]])
        {
            cell.backgroundColor=[UIColor app_lightYellow];
        }}
    
    
    
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit
                                    | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:dayInArray];
    
    if (components.year !=1970){
        cell.lblName.text = [NSString stringWithFormat:@"%d",components.day];
        }
    else{
        cell.backgroundColor=[UIColor clearColor];
    }
    
    
    
    
    // Press and Long Press
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    cell.tag = indexPath.row;
    [cell addGestureRecognizer:tapGestureRecognizer];
    
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    
    
    lpgr.minimumPressDuration = 0.5; //seconds
    [cell addGestureRecognizer:lpgr];
    
    // cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(0, 50);
    
}

- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    MonthHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                               UICollectionElementKindSectionHeader withReuseIdentifier:HEADER_IDENTIFIER_MONTH forIndexPath:indexPath];
    
    NSLog(@"header title : %@", [NSNumber numberWithInt:indexPath.section]);
    NSLog(@"test test keyarray: %@", [keyArray objectAtIndex:indexPath.section]);
    
    NSString *headerText =  [months objectForKey:[keyArray objectAtIndex:indexPath.section]] ;
    
    headerView.lblHeader.text= headerText;
    return headerView;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UIScreen *screen = [UIScreen mainScreen];
    //int width = screen.currentMode.size.width;
    int height = screen.currentMode.size.height;
    CGFloat width = CGRectGetWidth(self.viewMonthOverview.bounds);
    
    return CGSizeMake(width/8,100);
}




- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(50, 20,50, 20);
}

#pragma mark -  tap and longpress actions
-(void)cellTapped:self{
    NSLog(@"Cell Tapped");
    
}

-(void)handleLongPress:(UIGestureRecognizer*)gesture{
    if ( gesture.state != UIGestureRecognizerStateBegan ){
        return;}
    NSLog(@"Long Press");
    
    UILabel *newEvent = [[UILabel alloc] initWithFrame:CGRectMake(0,20, [gesture view].frame.size.width, 20)];
    
    newEvent.text=@"new event";
    
    [[gesture view] addSubview:newEvent];
    
    
}

#pragma mark - load data

- (void) loadHolidays
{
[[PublicHolidayService sharedService] getAllPublicHolidaysWithSuccessHandler:^(NSMutableArray *publicHolidays) {
    self.publicHolidays = [[NSArray alloc] initWithArray:publicHolidays];
    
    
   // PublicHoliday *publicHoliday = [self.publicHolidays objectAtIndex:0];
   // NSLog(@"holidays %@", publicHoliday.holidayDate);
    [self.viewMonthOverview.collectionView reloadData];
    
    
} andErrorHandler:^(NSException * exception) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}];
}

- (void) loadReservationsPerMeetingRoom:(NSInteger) roomId : (NSDate *) startDate : (NSInteger) amount

{
    NSLog(@"zit ik in load");
    [[ReservationService sharedService] getReservationsForRoomId:roomId fromDate:startDate forAmountOfDays: amount withSuccesHandler:^(NSMutableArray *reservationsPerMonth) {
      self.reservationsPerMonth = [[NSMutableArray alloc] initWithArray:reservationsPerMonth];
   //     [self.viewMonthOverview.collectionView reloadData];
      
  } andErrorHandler:^(NSException * exception) {
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
      [alertView show];
  }];
 
    
    
}


#pragma mark - Layout Orientation Methods

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    self.screenHasRotated = YES;
    //[self loadForInterfaceOrientation:toInterfaceOrientation];
}

/*
- (void)loadConstraints{
    
    if([[AppState sharedInstance] deviceIsLandscape]){
        [self loadConstraintsForLandscape];
        
    }else {
        [self loadConstraintsForPortrait];
    }
    
}

- (void)loadForInterfaceOrientation:(UIInterfaceOrientation)orientation{
    
    
    if([[AppState sharedInstance] deviceIsLandscape]){
        [self loadConstraintsForPortrait];
    }else{
        [self loadConstraintsForLandscape];
    }
    
}
*/

/*
- (void)loadConstraintsForLandscape{
    
    [self.viewImageGallery loadConstraintsForLandscape];
    [self setUpImageViewsInScrollview];
}

- (void)loadConstraintsForPortrait{
    
    [self.viewImageGallery loadConstraintsForPortrait];
    [self setUpImageViewsInScrollview];
}

*/


@end
