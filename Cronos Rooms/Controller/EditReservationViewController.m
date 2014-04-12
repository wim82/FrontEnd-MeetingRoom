//
// Created by Jean Smits on 4/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import "EditReservationViewController.h"
#import "EditReservationView.h"
#import "DetailReservationView.h"
#import "IDatePickerSlider.h"
#import "MeetingRoomService.h"
#import "ReservationService.h"
#import "UIColor+AppColor.h"
#import "NSDate+Helper.h"
#import "dimensions.h"


@interface EditReservationViewController () <IDatePickerSlider, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>


@property(nonatomic, strong) DetailCellView *descriptionTextView;
@property(nonatomic, strong) DetailCellView *reservedByTextView;
@property(nonatomic, strong) GroupTitleView *detailTitleView;
@property(nonatomic, strong) GroupTitleView *timeTitleView;
@property(nonatomic, strong) GroupTitleView *roomTitleView;
@property(nonatomic, strong) DatePickerView *startDatePickerView;
@property(nonatomic, strong) DatePickerView *endDatePickerView;
@property(nonatomic, strong) MeetingRoomOverview *meetingRoomOverview;
@property(nonatomic, strong) UIButton *deleteButton;


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
    [self.scrollView setBackgroundColor:[UIColor app_snowWhite]];
    self.view = self.scrollView;

    [self loadMeetingRooms];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self _setUpNavigationController];


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

- (void)_setUpNavigationController {

    //if the title hasn't been set, set it to "Edit Reservation"
    self.navigationItem.title = self.navigationItem.title ? self.navigationItem.title : @"Edit Reservation";

    self.navigationController.navigationBar.translucent = NO;

    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                 target:self
                                 action:@selector(_didTapSave)];
    self.navigationItem.rightBarButtonItem = saveButton;
}


- (void)_setUpMeetingRoomTableView {
    self.roomTitleView = [[GroupTitleView alloc] initWithFrame:CGRectMake(0, self.reservedByTextView.frame.origin.y + self.reservedByTextView.frame.size.height, self.view.frame.size.width, DIMENSIONS_GROUP_TITLE_VIEW_HEIGHT)
                                                      andTitle:@"Meeting Room"];
    [self.scrollView addSubview:self.roomTitleView];


    //init overview with correct position, height is set to 0, because we set this dynamically after the data is loaded.
    self.meetingRoomOverview = [[MeetingRoomOverview alloc] initWithFrame:CGRectMake(0, self.roomTitleView.frame.origin.y + self.roomTitleView.frame.size.height, self.view.frame.size.width, 0)
                                                              andDelegate:self];
    [self.meetingRoomOverview.tableView reloadData];
    [self _updateViewSizeToMatchContents];

    self.meetingRoomOverview.tableView.tintColor = [UIColor app_red];
    [self.scrollView addSubview:self.meetingRoomOverview];

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
    self.timeTitleView = [[GroupTitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, DIMENSIONS_GROUP_TITLE_VIEW_HEIGHT)
                                                      andTitle:@"Time"];
    [self.scrollView addSubview:self.timeTitleView];

    //START DATE
    self.startDatePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, self.timeTitleView.frame.origin.y + self.timeTitleView.frame.size.height, self.view.frame.size.width, 44)
                                                               title:@"Start"
                                                                date:self.reservation.startTime ? self.reservation.startTime : [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24]
                                                                mode:(UIDatePickerModeDateAndTime)
                                                         andDelegate:self];
    [self _addBottomBorder:IndentedBorder forView:self.startDatePickerView];
    //sets minimum date to now minus one quarter hour, no matter what
    self.startDatePickerView.datePicker.minimumDate = [[NSDate alloc] initWithTimeIntervalSinceNow:(-60 * 15)];


    [self.startDatePickerView.datePicker addTarget:self action:@selector(didChangeStartDate) forControlEvents:UIControlEventValueChanged];
    [self.startDatePickerView updateDateValue];
    [self.scrollView addSubview:self.startDatePickerView];



    //END TIME
    self.endDatePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, self.startDatePickerView.frame.origin.y + self.startDatePickerView.frame.size.height, self.view.frame.size.width, 44)
                                                             title:@"End"
                                                              date:self.reservation.endTime ? self.reservation.endTime : [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24.5]
                                                              mode:(UIDatePickerModeTime)
                                                       andDelegate:self];
    [self _addBottomBorder:FullBorder forView:self.endDatePickerView];


    //sets minimum date to now.
    self.endDatePickerView.datePicker.minimumDate = [[NSDate alloc] init];
    [self.endDatePickerView updateDateValue];
    [self.scrollView addSubview:self.endDatePickerView];

}


- (void)_setUpDetailView {
    self.detailTitleView = [[GroupTitleView alloc] initWithFrame:CGRectMake(0, self.endDatePickerView.frame.origin.y + self.endDatePickerView.frame.size.height, self.view.frame.size.width, DIMENSIONS_GROUP_TITLE_VIEW_HEIGHT)
                                                        andTitle:@"Details"];
    [self.scrollView addSubview:self.detailTitleView];

    self.descriptionTextView = [[DetailCellView alloc] initWithFrame:CGRectMake(0, self.detailTitleView.frame.origin.y + self.detailTitleView.frame.size.height, self.view.frame.size.width - 20, 64)
                                                               title:@"Description"
                                                            andValue:self.reservation.reservationDescription
                                                         andDelegate:self];

    self.descriptionTextView.detailTextField.returnKeyType = UIReturnKeyNext;
    [self _addBottomBorder:IndentedBorder forView:self.descriptionTextView];
    [self.scrollView addSubview:self.descriptionTextView];

    self.reservedByTextView = [[DetailCellView alloc] initWithFrame:CGRectMake(0, self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.size.height, self.view.frame.size.width, 64)
                                                              title:@"Reserved by"
                                                           andValue:self.reservation.user.fullName
                                                        andDelegate:self];

    self.reservedByTextView.detailTextField.returnKeyType = UIReturnKeyDone;
    [self _addBottomBorder:FullBorder forView:self.reservedByTextView];
    [self.scrollView addSubview:self.reservedByTextView];
}



#pragma mark - Private Methods

- (void)_updateViewSizeToMatchContents {
    //autoresizing tableview to match contents, happens after reloadData
    CGRect loadedTableViewFrame = CGRectMake(0, self.roomTitleView.frame.origin.y + self.roomTitleView.frame.size.height, self.view.frame.size.width, 0);  //general property of the meetingroom frame
    loadedTableViewFrame.size.height = self.meetingRoomOverview.tableView.contentSize.height; //get the dynamic height depending on the rows
    self.meetingRoomOverview.frame = loadedTableViewFrame; //set the overview frame to the new one

    self.meetingRoomOverview.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, loadedTableViewFrame.size.height);

    //update the general scrollview with the size of all elements + dynamically set table heigth
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width, [self _heigthForAllElementsInCurrentView])];
}


//TODO: make this a public method for other views?
- (void)_addBottomBorder:(BorderStyle)borderStyle forView:(UIView *)view {

    CALayer *bottomBorder = [CALayer layer];

    switch (borderStyle) {
        case FullBorder:
            bottomBorder.frame = CGRectMake(0, view.frame.size.height - 0.5, view.frame.size.width, 0.5f);
            break;
        case IndentedBorder:
            bottomBorder.frame = CGRectMake(20, view.frame.size.height - 0.5, view.frame.size.width, 0.5f);
            break;
        default:;
    }

    bottomBorder.backgroundColor = [UIColor app_ultraLightGrey].CGColor;
    [view.layer addSublayer:bottomBorder];

}


- (CGFloat)_heigthForAllElementsInCurrentView {
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


//forces the date part of the endtime to always be the same as the starttime, as soon as the starttime changes
- (void)didChangeStartDate {
    NSDate *date = [self.startDatePickerView.datePicker.date dateWithoutTime];
    self.endDatePickerView.datePicker.date = [date dateByAddingTimeInterval:[self.endDatePickerView.datePicker.date timeWithoutDate]];
}


//TODO: make this nicer
- (void)_saveReservation {

    //build element that needs to be "posted"
    int userNumber = 1; //TODO zoek met rest call op wat userid is van de Full Name die ingevuld staat -> als de usernaam niet gewijzigd is, is geen restcall nodig : de userid is reeds aanwezig

    Reservation *finalReservation = [[Reservation alloc] init];

    User *user = [[User alloc] init];
    user.userId = userNumber;
    user.fullName = @"";
    finalReservation.user = user;

    finalReservation.meetingRoom = self.currentMeetingRoom;
    finalReservation.reservationId = self.reservation.reservationId;
    finalReservation.reservationDescription = self.descriptionTextView.detailTextField.text;
    finalReservation.startTime = self.startDatePickerView.datePicker.date;
    finalReservation.endTime = self.endDatePickerView.datePicker.date;

    NSLog(@"in didtapSave: ");

    //if reservation is an existing reservation, update should be triggered. Else, create reservation is triggered
    NSLog(@"reservation id : %d", self.reservation.reservationId);
    if (self.reservation.reservationId == 0) {
        NSLog(@"create");
        NSLog(@"reservation id : %d", self.reservation.reservationId);
        [self createReservation:finalReservation];
    }
    else {
        NSLog(@"update");
        NSLog(@"reservation id : %d", self.reservation.reservationId);
        [self updateReservation:finalReservation];
    }

    //REMARK: katrien, hier stond de popviewcontroller -> zolang we zonder lokale database werken, heb ik die in de respectievelijke completionblocks gezet
    //op die manier staat op de overview altijd exact wat er op de database staat
}




#pragma mark - Keyboard Methods

- (void)keyboardWasShown:(NSNotification *)notification {

    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0.0, keyboardSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;


    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, [self _heigthForAllElementsInCurrentView]);
    if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin)) {
        [self.scrollView scrollRectToVisible:self.activeTextField.frame animated:NO];
    }
}


- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }];
}


#pragma mark - DatePickerDelegate Methods

- (void)datePickerDidSlideOpen:(BOOL)slideDown sentBy:(id)sender {

    //another weird hack to solve the case when 2 datepickers are open. without the animation (no matter which length, it won't work)
    [UIView animateWithDuration:0.001 animations:^{
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
    }                completion:^(BOOL finished) {

        //if both are open, close the other one
        if (self.startDatePickerView.datePickerSlideOpen && slideDown) {
            NSLog(@"both are open! Do Something with this! -> animation timing problems");
            [self.startDatePickerView slideDatePicker];
        }
    }];

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





#pragma mark - Navigation

- (void)_dismissController {
    //FIX IT : keert nog niet terug
    [self dismissViewControllerAnimated:YES completion:nil];
}


//hebben wij een cancel methode nodig? we hebben al back?
- (void)_didTapCancel {
    NSLog(@"tapped cancel");
    [self _dismissController];
}


- (void)_didTapSave {
    //TODO: perform necessary checks before actual saving.
    if (!self.currentMeetingRoom) {
        //TODO: subclass alertview for a custom alertview
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Forgot something?" message:@"You didn't select a meeting room" delegate:nil cancelButtonTitle:@"Sorry, i'll correct that" otherButtonTitles:nil];
        [alertView show];
    } else {
        [self _saveReservation];

    }

}


//TODO een delete button creeren waar deze actie getriggered wordt
- (void)_didTapDelete {
    [self deleteReservation:(NSInteger) self.reservation.reservationId];

}


#pragma mark - Rest Calls

- (void)loadMeetingRooms {
    MeetingRoomService *service = [MeetingRoomService sharedService];
    [service getAllMeetingRoomsWithSuccessHandler:^(NSMutableArray *meetingRooms) {
        self.meetingRooms = [[NSArray alloc] initWithArray:meetingRooms];
        NSLog(@"meeting rooms: %@", self.meetingRooms);

        [self.meetingRoomOverview.tableView reloadData];
        [self _updateViewSizeToMatchContents];

    }                             andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:exception.reason delegate:self cancelButtonTitle:@"het zou niet mogen" otherButtonTitles:nil];
        [alertView show];
    }];

}


- (void)createReservation:(Reservation *)reservation {

    ReservationService *reservationService = [ReservationService sharedService];

    [reservationService createReservation:reservation withSuccesHandler:^(Reservation *reservation) {
        [self.navigationController popViewControllerAnimated:YES];

    }                     andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error " message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}


- (void)updateReservation:(Reservation *)reservation {

    ReservationService *reservationService = [ReservationService sharedService];

    [reservationService updateReservation:reservation withSuccesHandler:^(Reservation *reservation) {
        [self.navigationController popViewControllerAnimated:YES];
    }                     andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error " message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];

}


- (void)deleteReservation:(NSInteger)reservationId {
    ReservationService *reservationService = [ReservationService sharedService];
    NSLog(@"reservationId in deletreservation method,%i", reservationId);

    [reservationService deleteReservation:reservationId withSuccesHandler:^(Reservation *reservation) {
        [self.navigationController popViewControllerAnimated:YES];

    }                     andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error " message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}





#pragma mark - MeetingRoom TableView Delegate Methods

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

    MeetingRoom *meetingRoom = (MeetingRoom *) [self.meetingRooms objectAtIndex:indexPath.row];
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



#pragma mark - TextField Delegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeTextField = nil;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;


    if (textField == self.descriptionTextView.detailTextField || textField.text.length == 0) {
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