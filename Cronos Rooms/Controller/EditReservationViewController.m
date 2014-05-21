#import <UIColor-Utilities/UIColor+Expanded.h>
#import "EditReservationViewController.h"
#import "EditReservationView.h"
#import "DetailReservationView.h"
#import "IDatePickerSlider.h"
#import "MeetingRoomService.h"
#import "ReservationService.h"
#import "UIColor+AppColor.h"
#import "NSDate+Helper.h"
#import "dimensions.h"
#import "UserService.h"
#import "DayViewController.h"


@interface EditReservationViewController () <IDatePickerSlider, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate>


@property(nonatomic, strong) DetailCellView *descriptionTextView;
@property(nonatomic, strong) DetailCellView *reservedByTextView;
@property(nonatomic, strong) GroupTitleView *detailTitleView;
@property(nonatomic, strong) GroupTitleView *timeTitleView;
@property(nonatomic, strong) GroupTitleView *roomTitleView;
@property(nonatomic, strong) DatePickerView *startDatePickerView;
@property(nonatomic, strong) DatePickerView *endDatePickerView;
@property(nonatomic, strong) MeetingRoomOverview *meetingRoomOverview;
@property(nonatomic, strong) UIButton *deleteButton;

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
}


- (void)viewDidLoad {
    [super viewDidLoad];


    //navigation
    [self _setUpNavigationController];

    //views
    [self _setUpTimeView];
    [self _setUpDetailView];
    [self _setUpMeetingRoomTableView];


    //data
    [self _loadAvailableMeetingRooms];
    [self _initializeReservation];

    //notifications
    [self _registerKeyboardNotifications];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidDisappear:(BOOL)animated {
    self.currentMeetingRoom = nil;
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
    self.navigationController.navigationBarHidden = NO;
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


- (void)_setUpDeleteButton {
    self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 100 * 20, -64, self.view.frame.size.width / 100 * 60, 44)];
    [self.deleteButton setBackgroundColor:[UIColor app_red]];
    [self.deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_didTapDelete)];
    [self.deleteButton addGestureRecognizer:tapGestureRecognizer];

    [self.scrollView addSubview:self.deleteButton];
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


    [self.startDatePickerView.datePicker addTarget:self action:@selector(_didChangeStartDate) forControlEvents:UIControlEventValueChanged];
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

    [self.endDatePickerView.datePicker addTarget:self action:@selector(_didChangeEndDate) forControlEvents:UIControlEventValueChanged];
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
                                                           andValue:self.reservation.user.fullName ? self.reservation.user.fullName : [[UserService sharedService] getDefaultUser].fullName
                                                        andDelegate:self];

    self.reservedByTextView.detailTextField.returnKeyType = UIReturnKeyDone;
    [self _addBottomBorder:FullBorder forView:self.reservedByTextView];
    [self.scrollView addSubview:self.reservedByTextView];
}

#pragma mark - Getters & Setters

- (Reservation *)reservation {
    if (!_reservation) {
        _reservation = [[Reservation alloc] init];
    }
    return _reservation;
}

#pragma mark - Private Methods

- (void)_initializeReservation {
    if (self.reservation.reservationId) {
        [self _setUpDeleteButton];
        self.scrollView.delegate = self;
    } else {
        self.reservation.startTime = self.startDatePickerView.datePicker.date;
        self.reservation.endTime = self.endDatePickerView.datePicker.date;
        self.reservation.reservationDescription = self.descriptionTextView.detailTextField.text;
    }
}


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
    return self.deleteButton.frame.size.height +
            self.timeTitleView.frame.size.height +
            self.startDatePickerView.frame.size.height +
            self.endDatePickerView.frame.size.height +
            self.descriptionTextView.frame.size.height +
            self.detailTitleView.frame.size.height +
            self.reservedByTextView.frame.size.height +
            self.roomTitleView.frame.size.height +
            self.meetingRoomOverview.frame.size.height;
}


//forces the date part of the endtime to always be the same as the starttime, as soon as the starttime changes
- (void)_didChangeStartDate {
    self.reservation.startTime = self.startDatePickerView.datePicker.date;

    self.endDatePickerView.datePicker.date = [self.startDatePickerView.datePicker.date dateByAddingTimeInterval:60 * 30];
    self.reservation.endTime = self.endDatePickerView.datePicker.date;
    [self.endDatePickerView updateDateValue];

    self.currentMeetingRoom = nil;
    self.reservation.meetingRoom = nil;
    [self _loadAvailableMeetingRooms];
}


- (void)_didChangeEndDate {
    if ([self.startDatePickerView.datePicker.date compare:self.endDatePickerView.datePicker.date] == NSOrderedDescending) {
        self.endDatePickerView.datePicker.date = [self.startDatePickerView.datePicker.date dateByAddingTimeInterval:60 * 30];
    }
    self.reservation.endTime = self.endDatePickerView.datePicker.date;
    [self.endDatePickerView updateDateValue];

    self.currentMeetingRoom = nil;
    self.reservation.meetingRoom = nil;
    [self _loadAvailableMeetingRooms];
}


- (void)_saveReservation {

    //TODO: i think this can be safely removed,
    self.reservation.meetingRoom = self.currentMeetingRoom;
    self.reservation.reservationId = self.reservation.reservationId;
    self.reservation.reservationDescription = self.descriptionTextView.detailTextField.text;

    //if reservation is an existing reservation, update should be triggered. Else, create reservation is triggered
    if (self.reservation.reservationId == 0) {
        [self _createReservation:self.reservation];
    }
    else {
        [self _updateReservation:self.reservation];
    }
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

    //another weird hack to solve the case when 2 datepickers are open. without the animation (no matter which length), it won't work.
    [UIView animateWithDuration:0.001 animations:^{
        //Move all fields below the datePicker
        self.detailTitleView.frame = [self slideViewForDatePicker:self.detailTitleView direction:slideDown];
        self.descriptionTextView.frame = [self slideViewForDatePicker:self.descriptionTextView direction:slideDown];
        self.reservedByTextView.frame = [self slideViewForDatePicker:self.reservedByTextView direction:slideDown];
        self.roomTitleView.frame = [self slideViewForDatePicker:self.roomTitleView direction:slideDown];
        self.meetingRoomOverview.frame = [self slideViewForDatePicker:self.meetingRoomOverview direction:slideDown];

        //if the start date is opened, move the  endDatePickerView downwards
        if (sender == self.startDatePickerView) {
            self.endDatePickerView.frame = [self slideViewForDatePicker:self.endDatePickerView direction:slideDown];
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


- (CGRect)slideViewForDatePicker:(UIView *)view direction:(BOOL)down {
    if (down) {
        return CGRectMake(view.frame.origin.x, view.frame.origin.y + 216, view.frame.size.width, view.frame.size.height);
    }
    else {
        return CGRectMake(view.frame.origin.x, view.frame.origin.y - 216, view.frame.size.width, view.frame.size.height);
    }
}


#pragma mark - Navigation

- (void)_didTapSave {
    if (!self.currentMeetingRoom) {
        //TODO: subclass alertview for a custom alertview
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Forgot something?" message:@"You didn't select a meeting room" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else if (!self.reservation.user) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unknown user" message:@"Please choose an existing user" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else {
        [self _saveReservation];
    }

}


- (void)_didTapDelete {

    [self _deleteReservation:self.reservation.reservationId];
    [self.deleteButton removeFromSuperview];

    [UIView performSystemAnimation:UISystemAnimationDelete onViews:self.scrollView.subviews options:UIViewAnimationOptionAllowAnimatedContent animations:nil completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:YES];
    }];

}

#pragma mark - Rest Calls

- (void)_loadAvailableMeetingRooms {
    MeetingRoomService *service = [MeetingRoomService sharedService];
    [service getAvailableMeetingRoomsForStartTime:self.startDatePickerView.datePicker.date andEndTime:self.endDatePickerView.datePicker.date withSuccesHandler:^(NSMutableArray *meetingRooms) {
        self.meetingRooms = [[NSMutableArray alloc] initWithArray:meetingRooms];
        if (self.reservation.meetingRoom) {
            [self.meetingRooms addObject:self.reservation.meetingRoom];
        }
        [self.meetingRoomOverview.tableView reloadData];
        [self _updateViewSizeToMatchContents];
    }                             andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];

}


- (void)_createReservation:(Reservation *)reservation {

    ReservationService *reservationService = [ReservationService sharedService];

    [reservationService createReservation:reservation withSuccesHandler:^(Reservation *savedReservation) {
        if ([self.delegate isKindOfClass:[DayViewController class]]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }

    }                     andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error " message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}


- (void)_updateReservation:(Reservation *)reservation {

    ReservationService *reservationService = [ReservationService sharedService];

    [reservationService updateReservation:reservation withSuccesHandler:^(Reservation *savedReservation) {
        [self.navigationController popViewControllerAnimated:YES];
    }                     andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error " message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];

}


- (void)_deleteReservation:(NSInteger)reservationId {
    ReservationService *reservationService = [ReservationService sharedService];

    [reservationService deleteReservation:reservationId withSuccesHandler:^(Reservation *reservation) {
        [self.navigationController popViewControllerAnimated:YES];

    }                     andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error " message:exception.reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}


- (void)_loadUserFromTextField:(UITextField *)textField {
    UserService *service = [UserService sharedService];
    [service getUserForFullName:textField.text withSuccesHandler:^(User *user) {
        self.reservation.user = user;
    }           andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unknown user" message:@"Please choose an existing user" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];

}



#pragma mark - MeetingRoom TableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.meetingRooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MeetingRoomCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }

    MeetingRoom *meetingRoom = (MeetingRoom *) [self.meetingRooms objectAtIndex:(NSUInteger) indexPath.row];
    cell.textLabel.text = meetingRoom.roomName;

    if (meetingRoom.roomId == self.reservation.meetingRoom.roomId) {
        self.currentMeetingRoom = meetingRoom;
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];

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
    if (textField == self.reservedByTextView.detailTextField) {
        [self _loadUserFromTextField:textField];
    }
    if (textField == self.descriptionTextView.detailTextField) {
        self.reservation.reservationDescription = self.descriptionTextView.detailTextField.text;
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


#pragma mark - ScrollViewDelegate Methods

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (scrollView.contentOffset.y < -30) {

        [UIView animateWithDuration:0.2 animations:^{
            [self.scrollView setContentInset:UIEdgeInsetsMake(84, 0, 0, 0)];
        }];

        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                [self.scrollView setContentInset:UIEdgeInsetsZero];
            }];
        });
    };
}

@end