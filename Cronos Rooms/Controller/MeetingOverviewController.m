//
//  MeetingOverviewController.m
//  testProject
//
//  Created by Katrien De Mey on 03/04/14.
//  Copyright (c) 2014 Katrien De Mey. All rights reserved.
//

#import "MeetingOverviewController.h"
#import "MeetingOverview.h"
#import "MeetingTableVIewCell.h"
#import "Meeting.h"
#import "MeetingTableViewHeader.h"
#import "SearchViewController.h"
#import "SWTableViewCell.h"

NSString *localeNameForTimeZoneNameComponents(NSArray *nameComponents);
NSMutableDictionary *regionDictionaryWithNameInArray(NSString *name, NSArray *array);

NSMutableArray *dates;
NSInteger dateSection;



#define TABLEVIEWCELL_IDENTIFIER @"meetingCell"
#define TABLEVIEWHEADER_IDENTIFIER @"meetingHeader"

@interface MeetingOverviewController () <UITableViewDataSource, UITableViewDelegate,SWTableViewCellDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) MeetingOverview  * meetingOverview;

//@property (nonatomic) BOOL useCustomCells;
@property (nonatomic, weak) UIRefreshControl *refreshControl;


@end

@implementation MeetingOverviewController


-(void)loadView{
    self.meetingOverview = [[MeetingOverview alloc] initWithFrame:[UIScreen mainScreen].bounds andDelegate:self];
    self.view = self.meetingOverview;
    
    self.meetings=[[NSMutableDictionary alloc]init];
    self.meetingsAll=[[NSMutableArray alloc]init];
    
    //fake data opbouwen
    
    self.meeting1=[[Meeting alloc]init];
    self.meeting1.date=(@"20140406");
    self.meeting1.title=@"customer meeting";
    self.meeting1.room=@"China";
    self.meeting1.timeInterval=@"time interval: 11:00-12:00";
    [self.meetingsAll addObject:self.meeting1];
    
    self.meeting2=[[Meeting alloc]init];
    self.meeting2.date=(@"20140722");
    self.meeting2.title=@"internal meeting";
    self.meeting2.room=@"China";
    self.meeting2.timeInterval=@"time interval: 11:00-12:00";
    [self.meetingsAll addObject:self.meeting2];
    
    self.meeting3=[[Meeting alloc]init];
    self.meeting3.date=(@"20140406");
    self.meeting3.title=@"sh** meeting";
    self.meeting3.room=@"Iceland";
    self.meeting3.timeInterval=@"time interval: 11:00-12:00";
    [self.meetingsAll addObject:self.meeting3];
    
    self.meeting4=[[Meeting alloc]init];
    self.meeting4.date=(@"20140508");
    self.meeting4.title=@"internal meeting";
    self.meeting4.room=@"Iceland";
    self.meeting4.timeInterval=@"time interval: 11:00-12:00";
    [self.meetingsAll addObject:self.meeting4];
    
    self.meeting5=[[Meeting alloc]init];
    self.meeting5.date=(@"20140722");
    self.meeting5.title=@"internal meeting";
    self.meeting5.room=@"Iceland";
    self.meeting5.timeInterval=@"time interval: 11:00-12:00";
    [self.meetingsAll addObject:self.meeting5];
    
    self.meeting6=[[Meeting alloc]init];
    self.meeting6.date=(@"20140508");
    self.meeting6.title=@"internal meeting";
    self.meeting6.room=@"Iceland";
    self.meeting6.timeInterval=@"time interval: 11:00-12:00";
    [self.meetingsAll addObject:self.meeting6];
    
    self.meeting7=[[Meeting alloc]init];
    self.meeting7.date=(@"20140722");
    self.meeting7.title=@"internal meeting";
    self.meeting7.room=@"Iceland";
    self.meeting7.timeInterval=@"time interval: 11:00-12:00";
    [self.meetingsAll addObject:self.meeting7];

    
    
  self.dates = [[NSMutableArray alloc]initWithObjects:@"20140406",@"20140722",@"20140508",nil];
  
    
    
    for (NSString *date in self.dates){
        NSMutableArray *meetingPerDate=[[NSMutableArray alloc]init];
        for (Meeting *meeting in self.meetingsAll){
            if (date==meeting.date){
                [meetingPerDate addObject:meeting];
            }
            
        }
        [self.meetings setObject:meetingPerDate forKey:date];
        
        NSLog(@"meetingperdate : %@, %lu", meetingPerDate, (unsigned long)meetingPerDate.count);
    }
    
    

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
  
    [self _createNavBar];
    
    
    [self.meetingOverview.tableView registerClass:[MeetingTableVIewCell class]  forCellReuseIdentifier:TABLEVIEWCELL_IDENTIFIER];
    [self.meetingOverview.tableView registerClass:[MeetingTableViewHeader class] forHeaderFooterViewReuseIdentifier:TABLEVIEWHEADER_IDENTIFIER];
    
    // If you set the seperator inset on iOS 6 you get a NSInvalidArgumentException...weird
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.meetingOverview.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0); // Makes the horizontal row seperator stretch the entire length of the table view
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigationbar
- (void) _createNavBar{
    //define the navigationbar and its' items (buttons, title, ....)
    
    // create an array for the buttons
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
    
    // create  standard  buttons
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(_addButtonClicked:)];
    
    UIBarButtonItem* searchButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                     target:self
                                     action:@selector(_searchButtonClicked)];
    //add to array of rightbuttons
    [buttons addObject:addButton];
    [buttons addObject:searchButton];
    self.navigationItem.rightBarButtonItems=buttons;
    
    //create leftbutton:searchButton
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]
                                           initWithImage:[UIImage imageNamed:@"1396879915_FEZ-04.png"] style:UIBarButtonItemStylePlain
                                           target:self
                                           action:@selector(_settingsButtonClicked:)];
    //add Title
    self.navigationItem.title = @"Reservations";
}

#pragma mark - Search functionality
-(void) _searchButtonClicked{
  
    SearchViewController *searchViewController=[[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchViewController animated:YES];
    /*
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
   
    
    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    searchBar.barStyle = UIBarStyleDefault;
    
    searchBar.showsCancelButton=YES;
    searchBar.autocorrectionType=UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType=UITextAutocapitalizationTypeNone;
    
    searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"User", @"Room",@"Description", nil];
    searchBar.showsScopeBar = YES;
    searchBar.tintColor=[UIColor darkGrayColor];
   
   
    searchBar.delegate=self;
    self.meetingOverview.tableView.tableHeaderView=searchBar;
    
    
    searchBar.frame = CGRectMake(0, 0, self.meetingOverview.tableView.frame.size.width, 44 + 40);
    
    [searchBar becomeFirstResponder];  */
 
    }
    

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.hidden=YES;
    self.meetingOverview.tableView.tableHeaderView=nil;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
}


#pragma mark - UITableViewDelegate & UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"aantal dates : %lu", (unsigned long)self.dates.count);
    return [self.dates count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *date = [self.dates objectAtIndex:section];
    NSMutableArray * meetingsPerDay=[self.meetings objectForKey:date];
    dateSection=section;
    return meetingsPerDay.count;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}*/

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25.0;

}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MeetingTableViewHeader *header=[tableView dequeueReusableHeaderFooterViewWithIdentifier:TABLEVIEWHEADER_IDENTIFIER];
        
        header.lblDate.text=([self.dates objectAtIndex:section]);
    return header;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell selected at index path %d:%d", indexPath.section, indexPath.row);
    NSLog(@"selected cell index path is %@", [self.meetingOverview.tableView indexPathForSelectedRow]);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
 
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TABLEVIEWCELL_IDENTIFIER];
    
    
        
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:TABLEVIEWCELL_IDENTIFIER
                                  containingTableView:self.meetingOverview.tableView // Used for row height and selection
                                   leftUtilityButtons:[self leftButtons]
                                  rightUtilityButtons:[self rightButtons]];
        cell.delegate = self;
    
    
    NSMutableArray *meetingArray=[self.meetings valueForKey:self.dates[indexPath.section]];
    NSLog (@" %lu",(unsigned long)meetingArray.count);
    NSLog (@"meetingsarray %@",meetingArray);
    
    Meeting *meeting=[Meeting alloc];
    meeting=[meetingArray objectAtIndex:indexPath.row];
    cell.backgroundColor=[UIColor greenColor];
   
    //TODO maak eigen labels
    cell.textLabel.text = meeting.title;
     cell.textLabel.backgroundColor = [UIColor redColor];
    cell.detailTextLabel.text= [NSString stringWithFormat:@"%@           %@", meeting.room, meeting.timeInterval];
        
    //   cell.lblRoom.text=meeting.room;
    //  cell.lblTime.text=meeting.timeInterval;

    
    
    return cell;
    
}


#pragma marks - Swipe related methods



- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor lightGrayColor]
                                                 icon:[UIImage imageNamed:@"edit-512.png"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor redColor]
                                                 icon:[UIImage imageNamed:@"delete-512.png"]];
    
    return rightUtilityButtons;
}


- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    
    return leftUtilityButtons;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor=[UIColor whiteColor];
    
    // Set background color of cell here if you don't want default white
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {   //TODO  edit button is pressed. Implement action: trigger edit view
            NSLog(@"More button was pressed");
            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            [alertTest show];
            
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.meetingOverview.tableView indexPathForCell:cell];
            //TODO implement delete action
          //  [_testArray[cellIndexPath.section] removeObjectAtIndex:cellIndexPath.row];
          //  [self.meetingOverview.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}


@end
