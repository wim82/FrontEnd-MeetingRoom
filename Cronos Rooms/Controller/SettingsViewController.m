//
// Created by Jean Smits on 15/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsView.h"
#import "DetailCellView.h"
#import "UserService.h"
#import "CountDownViewController.h"
#import "MeetingRoomService.h"
#import "ReservationOverviewController.h"


@interface SettingsViewController () <UITextFieldDelegate, SettingsDelegate>

@property(nonatomic, strong) SettingsView *settingsView;

@end

@implementation SettingsViewController {

}
- (void)loadView {
    self.settingsView = [[SettingsView alloc] initWithFrame:[UIScreen mainScreen].bounds andDelegate:self];
    self.view = self.settingsView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.settingsView.saveButton addTarget:self action:@selector(didTapSave) forControlEvents:UIControlEventTouchUpInside];
    [self _setUpSettingsTextField];

}


#pragma mark - Setup Methods

//prefills the textfield with the user's name or the room's name
- (void)_setUpSettingsTextField {

    User *defaultUser = [[UserService sharedService] getDefaultUser];
    if (defaultUser) {
        self.settingsView.userNameDetail.detailTextField.text = defaultUser.fullName;
    } else {
        MeetingRoom *defaultMeetingRoom = [[MeetingRoomService sharedService] getDefaultMeetingRoom];
        if (defaultMeetingRoom) {
            self.settingsView.userNameDetail.detailTextField.text = defaultMeetingRoom.roomName;
        }
    }

    //listen for delegate methods
    self.settingsView.userNameDetail.detailTextField.delegate = self;
}

#pragma mark - Save Methods

- (void)_saveUser:(User *)object {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"defaultUser"];
    [defaults setObject:nil forKey:@"defaultMeetingRoom"];
    [defaults synchronize];

}

- (void)_saveRoom:(MeetingRoom *)object {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"defaultMeetingRoom"];
    [defaults setObject:nil forKey:@"defaultUser"];
    [defaults synchronize];

}

#pragma mark - Actions

- (void)didTapSave {
    [self _tryLoadingMeetingRoom:self.settingsView.userNameDetail.detailTextField.text completion:^(BOOL roomIsLoaded) {

        if (!roomIsLoaded) {
            NSLog(@"'t is gene room maar een userrrr!");
            [self _loadUser:self.settingsView.userNameDetail.detailTextField.text];
        }
    }];
}


#pragma mark - Rest Calls

//01. check if the name entered is a meeting room
- (void)_tryLoadingMeetingRoom:(NSString *)roomName completion:(void (^)(BOOL))roomIsLoaded {

    MeetingRoomService *service = [MeetingRoomService sharedService];
    [service getMeetingRoomWithRoomName:roomName withSuccesHandler:^(MeetingRoom *room) {

        //02. if it is, save it in the user defaults.
        [self _saveRoom:room];
        CountDownViewController *countDownViewController = [[CountDownViewController alloc] init];
        countDownViewController.meetingRoom = room;

        if ([self.delegate isKindOfClass:[ReservationOverviewController class]])    {
            ((ReservationOverviewController *)self.delegate).user = nil;
            [self.delegate shouldLaunchCountDownViewController:countDownViewController];
        }
        else {
            [self.delegate didChangeSettingsToDefaultMeetingRoom:room];
        }

        roomIsLoaded(YES);


    }                   andErrorHandler:^(NSException *exception) {
        roomIsLoaded(NO);


    }];

}

- (void)_loadUser:(NSString *)userName {
    UserService *service = [UserService sharedService];
    [service getUserForFullName:userName withSuccesHandler:^(User *user) {
        //  self.defaultUser = user;

        //04.save default user
        [self _saveUser:user];
        ///   [[self presentingViewController] viewWillAppear:YES];
        //  [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

        NSLog(@"vlak voor delegate user aanroepen");
        if ([self.delegate isKindOfClass:[CountDownViewController class]]) {
            ReservationOverviewController *reservationOverviewController = [[ReservationOverviewController alloc] init];
            reservationOverviewController.user = user;
            [self.delegate shouldLaunchReservationOverviewController:reservationOverviewController];

        }
        else {
            [self.delegate didChangeSettingsToDefaultUser:user];
        }


    }           andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No account?" message:@"Please ask about your account name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];

    }];
}


#pragma mark - UITextField Delegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end