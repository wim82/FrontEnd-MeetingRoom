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
    
    
    //holidays
    
    NSDateComponents *holidayComps = [[NSDateComponents alloc] init];
    timeStamp=[[NSMutableArray alloc]init];
    [holidayComps setDay:01];
    [holidayComps setMonth:05];
    [holidayComps setYear:2014];
    [timeStamp addObject:[[NSCalendar currentCalendar] dateFromComponents:holidayComps] ];
    
    holidays=[[NSMutableArray alloc]init];
    [holidays addObject:timeStamp];
    [holidayComps setDay:21];
    [holidayComps setMonth:04];
    [holidayComps setYear:2014];
    [timeStamp addObject:[[NSCalendar currentCalendar] dateFromComponents:holidayComps] ];
    [holidays addObject:timeStamp];
    
    [holidayComps setDay:29];
    [holidayComps setMonth:05];
    [holidayComps setYear:2014];
    [timeStamp addObject:[[NSCalendar currentCalendar] dateFromComponents:holidayComps] ];
    [holidays addObject:timeStamp];
    
    [holidayComps setDay:8];
    [holidayComps setMonth:06];
    [holidayComps setYear:2014];
    [timeStamp addObject:[[NSCalendar currentCalendar] dateFromComponents:holidayComps] ];
    [holidays addObject:timeStamp];
    
    
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
        NSLog(@"what day of the week? %d", dayofweek);
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
    
    self.title = @"Month Overview";
    
    
    
    [self.viewMonthOverview.collectionView registerClass:[MonthCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER_MONTHDAY];
    
    
    
    
    [self.viewMonthOverview.collectionView registerClass:[MonthHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADER_IDENTIFIER_MONTH];
    
    
    // [self _getData];
    
    //TODO : this is just to check the holiday loading. Need to be integrated into the view
    NSLog(@"de holidays inladen");
    
    [[PublicHolidayService sharedService] getAllPublicHolidaysWithSuccessHandler:^(NSMutableArray *publicHolidays) {
        self.publicHolidays = [[NSArray alloc] initWithArray:publicHolidays];
        
       // PublicHoliday *publicHoliday = [self.publicHolidays objectAtIndex:0];
       // NSLog(@"holidays %@", publicHoliday.holidayDate);
        
        
    } andErrorHandler:^(NSException * exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];

    
    
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
    
    // Day * day = [self.arrayOfDays objectAtIndex:indexPath.row];
    cell.lblName.text=@"";
    cell.backgroundColor=[UIColor lightGrayColor];
    NSDate *dayInArray=[[NSDate alloc]init];
    dayInArray=[[monthsAndDaysDictionary objectForKey:[keyArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] ;
    // NSLog(@"day: %@ and timestamp : %@", dayInArray, timeStamp);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    for(int i=0;i<[timeStamp count]; i++){
        if ([[dateFormat stringFromDate:dayInArray] isEqualToString:[dateFormat stringFromDate:[timeStamp objectAtIndex:i]]])
        {
            cell.backgroundColor=[UIColor blueColor];
        }}
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit
                                    | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:dayInArray];
    /* if (cell==nil){
     //   cell = [[UICollectionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
     
     UILabel * lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 20)];
     lblName.textAlignment = NSTextAlignmentCenter;
     lblName.font = [UIFont systemFontOfSize:16];
     lblName.textColor = [UIColor redColor];
     // self.lblName.layer.backgroundColor = [UIColor cyanColor].CGColor;
     lblName.layer.borderColor = [UIColor redColor].CGColor;
     lblName.layer.borderColor=(__bridge CGColorRef)([UIColor blackColor]);
     lblName.layer.borderWidth = 3.0;
     
     [cell.contentView addSubview:lblName];
     cell.backgroundColor=[UIColor greenColor];
     
     
     }*/
    if (components.year !=1970){
        cell.lblName.text = [NSString stringWithFormat:@"%d",components.day];}
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
-(void)cellTapped:(id)sender{
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


@end
