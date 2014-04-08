//
// Created by Jean Smits on 4/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import "EditReservationView.h"
#import "IDatePickerSlider.h"
#import "MeetingRoomOverview.h"

@interface EditReservationView () <IDatePickerSlider, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
typedef NS_ENUM(NSInteger, BorderStyle) {
    FullBorder,
    IndentedBorder,
};

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UITextField *activeTextField;

@end

@implementation EditReservationView

- (instancetype)initWithFrame:(CGRect)frame {
    NSLog(@"in editreservationview init with frame");
    self = [super initWithFrame:frame];
    if (self) {


        self.meetingRooms = [[NSArray alloc] initWithObjects:@"China", @"Rusland", @"IJsland", @"Groenland", nil];
        self.backgroundColor = [UIColor whiteColor];

        [self _setUpScrollView:frame];
        [self _setUpTimeView:frame];
        [self _setUpDetailView:frame];

        self.roomTitleView = [[GroupTitleView alloc] initWithFrame:CGRectMake(0, self.reservedByTextView.frame.origin.y + self.reservedByTextView.frame.size.height, frame.size.width, 64) andTitle:@"Meeting Room"];
        [self.scrollView addSubview:self.roomTitleView];



        //FIXME: this code works, but i don't *really* understand it.
        //init overview with correct position, height is set to 0, because we set this dynamically after the data is loaded.
        self.meetingRoomOverview = [[MeetingRoomOverview alloc] initWithFrame:CGRectMake(0, self.roomTitleView.frame.origin.y + self.roomTitleView.frame.size.height, frame.size.width, 0) andDelegate:self];
        [self.meetingRoomOverview.tableView reloadData];

        //autoresizing tableview to match contents, happens after reloadData;
        CGRect loadedTableViewFrame = self.meetingRoomOverview.tableView.frame;  //general property of the meetingroom frame
        loadedTableViewFrame.size.height = self.meetingRoomOverview.tableView.contentSize.height; //get the dynamic height depending on the rows
        self.meetingRoomOverview.frame = loadedTableViewFrame; //set the overview frame to the new one

        //this is the mystery line that needs to be added.
        self.meetingRoomOverview.tableView.frame = CGRectMake(0, 0, frame.size.width, loadedTableViewFrame.size.height);

        //update the general scrollview with the size of all elements + dynamically set table heigth
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width, [self heigthForAllElementsInCurrentView])];


        [self.scrollView addSubview:self.meetingRoomOverview];
        //END OF FIXME;


    }
    return self;
}

#pragma mark - TimeView Methods

- (void)_setUpTimeView:(CGRect)frame {

    //TITLE
    self.timeTitleView = [[GroupTitleView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 64) andTitle:@"Time"];
    [self.scrollView addSubview:self.timeTitleView];

    //START DATE
    self.startDatePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, self.timeTitleView.frame.origin.y + self.timeTitleView.frame.size.height, frame.size.width, 44)
                                                               title:@"Start"
                                                                date:[NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24]
                                                                mode:(UIDatePickerModeDateAndTime)
                                                         andDelegate:self];
    [self addBottomBorder:IndentedBorder forView:self.startDatePickerView];
    [self.scrollView addSubview:self.startDatePickerView];

    //END TIME
    self.endDatePickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, self.startDatePickerView.frame.origin.y + self.startDatePickerView.frame.size.height, frame.size.width, 44)
                                                             title:@"End"
                                                              date:[NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24.5]
                                                              mode:(UIDatePickerModeTime)
                                                       andDelegate:self];
    [self addBottomBorder:FullBorder forView:self.endDatePickerView];
    [self.scrollView addSubview:self.endDatePickerView];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWasShown:(NSNotification *)notification {

    NSLog(@"hophop");
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect bkgndRect = self.frame;
    bkgndRect.size.height += kbSize.height;
    [self setFrame:bkgndRect];
    [self.scrollView setContentOffset:CGPointMake(0.0, self.activeTextField.frame.origin.y) animated:YES];


}

- (void)keyboardWillHide:(NSNotification *)notification {
    //need to make it 64, to have room for navigation controller
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


- (void)datePickerDidSlideOpen:(BOOL)slideDown sentBy:(id)sender {

    //if the start date is opened, move the  endDatePickerView downwards
    if (sender == self.startDatePickerView) {
        self.endDatePickerView.frame = [self slideFrame:self.endDatePickerView down:slideDown];
    }

    //FIXME: i can't get this to work
    //if both are open, close the other one
    if (self.startDatePickerView.datePickerSlideOpen && self.endDatePickerView.datePickerSlideOpen) {
        NSLog(@"both are open! Do Something with this! -> animation timing problems");
    }

    //Move all fields below the datePicker
    self.detailTitleView.frame = [self slideFrame:self.detailTitleView down:slideDown];
    self.descriptionTextView.frame = [self slideFrame:self.descriptionTextView down:slideDown];
    self.reservedByTextView.frame = [self slideFrame:self.reservedByTextView down:slideDown];
    self.roomTitleView.frame = [self slideFrame:self.roomTitleView down:slideDown];
    self.meetingRoomOverview.frame = [self slideFrame:self.meetingRoomOverview down:slideDown];

    //don't forget to resize the scrollview's content size
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, (slideDown ? self.scrollView.contentSize.height + 216 : self.scrollView.contentSize.height - 216));
}

- (CGRect)slideFrame:(UIView *)view down:(BOOL)down {
    if (down) {
        return CGRectMake(view.frame.origin.x, view.frame.origin.y + 216, view.frame.size.width, view.frame.size.height);
    }
    else {
        return CGRectMake(view.frame.origin.x, view.frame.origin.y - 216, view.frame.size.width, view.frame.size.height);
    }
}



#pragma mark - Set Up Methods

- (void)_setUpScrollView:(CGRect)frame {
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    [self addSubview:self.scrollView];
}

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



#pragma mark - DetailView Methods

- (void)_setUpDetailView:(CGRect)frame {
    self.detailTitleView = [[GroupTitleView alloc] initWithFrame:CGRectMake(0, self.endDatePickerView.frame.origin.y + self.endDatePickerView.frame.size.height, frame.size.width, 64) andTitle:@"Details"];
    [self.scrollView addSubview:self.detailTitleView];

    self.descriptionTextView = [[DetailCellView alloc] initWithFrame:CGRectMake(0, self.detailTitleView.frame.origin.y + self.detailTitleView.frame.size.height, frame.size.width - 20, 64) title:@"Description" andValue:@"Gasthuisberg" andDelegate:self];
    self.descriptionTextView.detailTextField.returnKeyType = UIReturnKeyNext;
    [self addBottomBorder:IndentedBorder forView:self.descriptionTextView];
    [self.scrollView addSubview:self.descriptionTextView];

    self.reservedByTextView = [[DetailCellView alloc] initWithFrame:CGRectMake(0, self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.size.height, frame.size.width, 64) title:@"Reserved by" andValue:nil andDelegate:self];
    self.reservedByTextView.detailTextField.returnKeyType = UIReturnKeyDone;
    [self addBottomBorder:FullBorder forView:self.reservedByTextView];
    [self.scrollView addSubview:self.reservedByTextView];
}



#pragma mark - MeetingRoom TableView Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.meetingRooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }

    cell.textLabel.text = [self.meetingRooms objectAtIndex:indexPath.row];
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
    //[self.textField resignFirstResponder];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"ik tikte op %@", textField.text);
    self.activeTextField = textField;
    if (textField == self.descriptionTextView.detailTextField) {
        self.descriptionTextView.detailLabel.hidden = NO;
    }

    if (textField == self.reservedByTextView.detailTextField) {
        self.reservedByTextView.detailLabel.hidden = NO;
    }

    NSLog(@"raak ik hier?");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"heb geduwd op enter");
    if (textField.returnKeyType == UIReturnKeyNext) {
        [self.reservedByTextView.detailTextField becomeFirstResponder];
    }
    else if (textField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
    }
    return YES;
}


@end