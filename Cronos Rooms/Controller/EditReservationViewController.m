//
// Created by Jean Smits on 4/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import "EditReservationViewController.h"
#import "EditReservationView.h"
#import "DetailReservationView.h"
#import "IDatePickerSlider.h"
#import "Reservation.h"
#import "MeetingRoomService.h"
#import "ReservationService.h"



@interface EditReservationViewController () <IDatePickerSlider, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property(nonatomic, strong) DetailCellView *descriptionTextView;
@property(nonatomic, strong) DetailCellView *reservedByTextView;
@property(nonatomic, strong) GroupTitleView *detailTitleView;
@property(nonatomic, strong) GroupTitleView *timeTitleView;
@property(nonatomic, strong) GroupTitleView *roomTitleView;
@property(nonatomic, strong) DatePickerView *startDatePickerView;
@property(nonatomic, strong) DatePickerView *endDatePickerView;
@property(nonatomic, strong) MeetingRoomOverview *meetingRoomOverview;
@property(nonatomic, strong) MeetingRoom *currentMeetingRoom;
@property(nonatomic, strong) UITextField *activeTextField;
@property(nonatomic, strong) UIScrollView *scrollView;

typedef NS_ENUM(NSInteger, BorderStyle) {
    FullBorder,
    IndentedBorder,
};

@end

@implementation EditReservationViewController

- (void)loadView {

    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    self.view = self.scrollView;

    self.navigationItem.title = @"Reservations";
    self.navigationController.navigationBar.translucent = NO;
    [self loadMeetingRooms];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                  target:self
                                  action:@selector(_didTapSave)];
    self.navigationItem.rightBarButtonItem=saveButton;
    
    /*
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                   target:self
                                   action:@selector(_didTapDelete)];
    self.navigationItem.rightBarButtonItem=deleteButton;
    */
    
    
    //TODO make left nav bar button to be cancel button
   // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(_didTapCancel)];

    
    [self _setUpTimeView];
    [self _setUpDetailView];
    [self _setUpMeetingRoomTableView];
    [self _registerKeyboardNotifications];

}


- (void)viewWillAppear:(BOOL)animated {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


#pragma mark - Set Up Methods

- (void)loadMeetingRooms {
    MeetingRoomService *service = [MeetingRoomService sharedService];
    [service getAllMeetingRoomsWithSuccessHandler:^(NSMutableArray *meetingRooms) {
        self.meetingRooms = [[NSArray alloc] initWithArray:meetingRooms];
        NSLog(@"meeting rooms: %@", self.meetingRooms);

        [self.meetingRoomOverview.tableView reloadData];
        [self updateViewSizeToMatchContents];


    }                             andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:exception.reason delegate:self cancelButtonTitle:@"het zou niet mogen" otherButtonTitles:nil];
        [alertView show];
    }];

}


- (void)_setUpMeetingRoomTableView {
    self.roomTitleView = [[GroupTitleView alloc] initWithFrame:CGRectMake(0, self.reservedByTextView.frame.origin.y + self.reservedByTextView.frame.size.height, self.view.frame.size.width, 64)
                                                      andTitle:@"Meeting Room"];
    [self.scrollView addSubview:self.roomTitleView];


    //init overview with correct position, height is set to 0, because we set this dynamically after the data is loaded.
    self.meetingRoomOverview = [[MeetingRoomOverview alloc] initWithFrame:CGRectMake(0, self.roomTitleView.frame.origin.y + self.roomTitleView.frame.size.height, self.view.frame.size.width, 0)
                                                              andDelegate:self];
    [self.meetingRoomOverview.tableView reloadData];
    [self updateViewSizeToMatchContents];


    [self.scrollView addSubview:self.meetingRoomOverview];

}

- (void)updateViewSizeToMatchContents {
    //autoresizing tableview to match contents, happens after reloadData
    CGRect loadedTableViewFrame = CGRectMake(0, self.roomTitleView.frame.origin.y + self.roomTitleView.frame.size.height, self.view.frame.size.width, 0);  //general property of the meetingroom frame
    loadedTableViewFrame.size.height = self.meetingRoomOverview.tableView.contentSize.height; //get the dynamic height depending on the rows
    self.meetingRoomOverview.frame = loadedTableViewFrame; //set the overview frame to the new one

    self.meetingRoomOverview.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, loadedTableViewFrame.size.height);

    //update the general scrollview with the size of all elements + dynamically set table heigth
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width, [self heigthForAllElementsInCurrentView])];
}


- (void)_registerKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


- (void)_setUpTimeView {
    self.timeTitleView = [[GroupTitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)
                                                      andTitle:@"Time"];
    [self.scrollView addSubview:self.timeTitleView];

    //START DATE
    self.startDatePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, self.timeTitleView.frame.origin.y + self.timeTitleView.frame.size.height, self.view.frame.size.width, 44)
                                                               title:@"Start"
                                                                date:self.reservation.startTime ? self.reservation.startTime : [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24]
                                                                mode:(UIDatePickerModeDateAndTime)
                                                         andDelegate:self];
    [self addBottomBorder:IndentedBorder forView:self.startDatePickerView];
    [self.scrollView addSubview:self.startDatePickerView];


    //END TIME
    self.endDatePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, self.startDatePickerView.frame.origin.y + self.startDatePickerView.frame.size.height, self.view.frame.size.width, 44)
                                                             title:@"End"
                                                              date:self.reservation.endTime ? self.reservation.endTime : [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24.5]
                                                              mode:(UIDatePickerModeTime)
                                                       andDelegate:self];
    [self addBottomBorder:FullBorder forView:self.endDatePickerView];
    [self.scrollView addSubview:self.endDatePickerView];
}



#pragma mark - Set Up Methods

- (void)addBottomBorder:(BorderStyle)borderStyle forView:(UIView *)view {

    CALayer *bottomBorder = [CALayer layer];

    switch (borderStyle) {
        case FullBorder:
            bottomBorder.frame = CGRectMake(0, view.frame.size.height - 1, view.frame.size.width, 0.5f);
            break;
        case IndentedBorder:
            bottomBorder.frame = CGRectMake(20, view.frame.size.height - 1, view.frame.size.width, 0.5f);
            break;
        default:;
    }

    bottomBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [view.layer addSublayer:bottomBorder];

}


- (void)keyboardWasShown:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0.0, keyboardSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;

    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, [self heigthForAllElementsInCurrentView]);

    if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin)) {
        [self.scrollView scrollRectToVisible:self.activeTextField.frame animated:YES];
    }


}


- (void)keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


- (void)datePickerDidSlideOpen:(BOOL)slideDown sentBy:(id)sender {

    //Move all fields below the datePicker
    self.detailTitleView.frame = [self slideFrame:self.detailTitleView direction:slideDown];
    self.descriptionTextView.frame = [self slideFrame:self.descriptionTextView direction:slideDown];
    self.reservedByTextView.frame = [self slideFrame:self.reservedByTextView direction:slideDown];
    self.roomTitleView.frame = [self slideFrame:self.roomTitleView direction:slideDown];
    self.meetingRoomOverview.frame = [self slideFrame:self.meetingRoomOverview direction:slideDown];

    //if the start date is opened, move the  endDatePickerView downwards
    if (sender == self.startDatePickerView) {
        self.endDatePickerView.frame = [self slideFrame:self.endDatePickerView direction:slideDown];
    }

    //FIXME: i can't get this to work
    //if both are open, close the other one
    if (self.startDatePickerView.datePickerSlideOpen && self.endDatePickerView.datePickerSlideOpen) {
        NSLog(@"both are open! Do Something with this! -> animation timing problems");
    }

    //don't forget to resize the scrollview's content size
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, (slideDown ? self.scrollView.contentSize.height + 216 : self.scrollView.contentSize.height - 216));
}


- (CGRect)slideFrame:(UIView *)view direction:(BOOL)down {
    if (down) {
        return CGRectMake(view.frame.origin.x, view.frame.origin.y + 216, view.frame.size.width, view.frame.size.height);
    }
    else {
        return CGRectMake(view.frame.origin.x, view.frame.origin.y - 216, view.frame.size.width, view.frame.size.height);
    }
}


- (CGFloat)heigthForAllElementsInCurrentView {
    return self.timeTitleView.frame.size.height +
            self.startDatePickerView.frame.size.height +
            self.endDatePickerView.frame.size.height +
            self.descriptionTextView.frame.size.height +
            self.detailTitleView.frame.size.height +
            self.reservedByTextView.frame.size.height +
            self.roomTitleView.frame.size.height +
            self.meetingRoomOverview.frame.size.height +
            20;
}



#pragma mark - Navigation

- (void)_dismissController{
    //FIX IT : keert nog niet terug
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)_didTapCancel{
    NSLog(@"tapped cancel");
    [self _dismissController];
}


- (void)_didTapSave {
    
    //todo  continue working on save
    
    //build element that needs to be "posted"
    int userNumber=1; //TODO zoek met rest call op wat userid is van de meeting owner
    Reservation *finalReservation=[[Reservation alloc]init];
    
    User *user=[[User alloc]init];
    user.userId=userNumber;
    user.fullName=@"";
    finalReservation.user=user;
    
    MeetingRoom *meetingRoom = self.currentMeetingRoom;
    finalReservation.meetingRoom=meetingRoom;
    finalReservation.reservationId=self.reservation.reservationId;
    finalReservation.reservationDescription=self.descriptionTextView.detailTextField.text;
    finalReservation.startTime=self.startDatePickerView.datePicker.date;
    finalReservation.endTime=self.endDatePickerView.datePicker.date;
    
    NSLog(@"in didtapSave: ");
    
    //if reservation is an existing reservation, update should be triggered. Else, create reservation is triggered
    NSLog(@"reservation id : %d", self.reservation.reservationId);
    if (self.reservation.reservationId==0){
        NSLog(@"create");
        NSLog(@"reservation id : %d", self.reservation.reservationId);
        [self createReservation:(Reservation *) finalReservation];
    }
    else{
        NSLog(@"update");
        NSLog(@"reservation id : %d", self.reservation.reservationId);
        [self updateReservation:(Reservation *) finalReservation];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
        
}

//TODO een delete button creeren waar deze actie getriggered wordt

- (void)_didTapDelete {
    
    [self deleteReservation:(NSInteger) self.reservation.reservationId];
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - access database


- (void)createReservation: (Reservation *)reservation{
   
    ReservationService *reservationService = [ReservationService sharedService];
    
    [reservationService createReservation:reservation withSuccesHandler:^(Reservation *reservation) {
        
    } andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error " message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void)updateReservation: (Reservation *)reservation{
        
        ReservationService *reservationService = [ReservationService sharedService];
        
        [reservationService updateReservation:reservation withSuccesHandler:^(Reservation *reservation) {
            
        } andErrorHandler:^(NSException *exception) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error " message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }];
    
}

- (void)deleteReservation: (NSInteger)reservationId{
    ReservationService *reservationService = [ReservationService sharedService];
   NSLog(@"reservationId in deletreservation method,%i", reservationId);
    
    [reservationService deleteReservation:reservationId withSuccesHandler:^(Reservation *reservation) {
        ;
        
    } andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error " message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}



#pragma mark - DetailView Methods

- (void)_setUpDetailView {
    self.detailTitleView = [[GroupTitleView alloc] initWithFrame:CGRectMake(0, self.endDatePickerView.frame.origin.y + self.endDatePickerView.frame.size.height, self.view.frame.size.width, 64)
                                                        andTitle:@"Details"];
    [self.scrollView addSubview:self.detailTitleView];

    self.descriptionTextView = [[DetailCellView alloc] initWithFrame:CGRectMake(0, self.detailTitleView.frame.origin.y + self.detailTitleView.frame.size.height, self.view.frame.size.width - 20, 64)
                                                               title:@"Description"
                                                            andValue:self.reservation.reservationDescription
                                                         andDelegate:self];

    self.descriptionTextView.detailTextField.returnKeyType = UIReturnKeyNext;
    [self addBottomBorder:IndentedBorder forView:self.descriptionTextView];
    [self.scrollView addSubview:self.descriptionTextView];

    self.reservedByTextView = [[DetailCellView alloc] initWithFrame:CGRectMake(0, self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.size.height, self.view.frame.size.width, 64)
                                                              title:@"Reserved by"
                                                           andValue:self.reservation.user.fullName
                                                        andDelegate:self];

    self.reservedByTextView.detailTextField.returnKeyType = UIReturnKeyDone;
    [self addBottomBorder:FullBorder forView:self.reservedByTextView];
    [self.scrollView addSubview:self.reservedByTextView];
}


#pragma mark - MeetingRoom TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"hop %i", self.meetingRooms.count);
    return self.meetingRooms.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }

    MeetingRoom *meetingRoom = (MeetingRoom*) [self.meetingRooms objectAtIndex:indexPath.row];
    cell.textLabel.text = meetingRoom.roomName;

    if (meetingRoom.roomId == self.reservation.meetingRoom.roomId) {
        self.currentMeetingRoom = meetingRoom;  //TODO krijgen we die warning weg??
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


    NSInteger currentMeetingRoomIndex = [self.meetingRooms indexOfObject:self.currentMeetingRoom];
    if (currentMeetingRoomIndex == indexPath.row) {
        return;
    }
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:currentMeetingRoomIndex inSection:0];

    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.currentMeetingRoom = [self.meetingRooms objectAtIndex:indexPath.row];
    }

    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
}



#pragma - TextField Delegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeTextField = nil;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
    if (textField == self.descriptionTextView.detailTextField) {
        self.descriptionTextView.detailLabel.hidden = NO;
    }

    if (textField == self.reservedByTextView.detailTextField) {
        self.reservedByTextView.detailLabel.hidden = NO;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyNext) {
        [self.reservedByTextView.detailTextField becomeFirstResponder];
    }
    else if (textField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
    }
    return YES;
}


@end