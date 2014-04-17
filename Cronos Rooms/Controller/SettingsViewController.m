//
// Created by Jean Smits on 15/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsView.h"
#import "DetailCellView.h"
#import "User.h"
#import "UserService.h"
#import "CountDownViewController.h"
#import "MeetingRoomService.h"
#import "ReservationOverviewController.h"


@interface SettingsViewController () <UITextFieldDelegate, SettingsDelegate>

@property(nonatomic, strong) SettingsView *settingsView;
@property(nonatomic, strong) User *defaultUser;

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

    User *defaultUser = [UserService getDefaultUser];
    if (defaultUser) {
        self.settingsView.userNameDetail.detailTextField.text = defaultUser.fullName;
    } else {
        MeetingRoom *defaultMeetingRoom = [MeetingRoomService getDefaultMeetingRoom];
        if (defaultMeetingRoom) {
            self.settingsView.userNameDetail.detailTextField.text = defaultMeetingRoom.roomName;
        }
    }
}


- (void)didTapSave {
    [self _loadMeetingRoom:self.settingsView.userNameDetail.detailTextField.text];
}


//01. check if the name entered is a meeting room
- (void)_loadMeetingRoom:(NSString *)roomName {

    MeetingRoomService *service = [MeetingRoomService sharedService];
    [service getMeetingRoomWithRoomName:roomName withSuccesHandler:^(MeetingRoom *room) {

        //02. if it is, save it in the user defaults.
        [self _saveRoom:room];
        CountDownViewController *countDownViewController = [[CountDownViewController alloc] init];
        countDownViewController.meetingRoom = room;

        if ([self.delegate isKindOfClass:[ReservationOverviewController class]])
        [self.delegate launchCountDownViewController:countDownViewController];
        else{
            [self.delegate didChangeSettingsToDefaultMeetingRoom:room];
        }


    }                   andErrorHandler:^(NSException *exception) {
        //03. if we don't find a meeting room, try to load a user
        [self _loadUser:self.settingsView.userNameDetail.detailTextField.text];

    }];

}

- (void)_loadUser:(NSString *)userName {
    UserService *service = [UserService sharedService];
    [service getUserForFullName:userName withSuccesHandler:^(User *user) {
        //  self.defaultUser = user;

        //04.save default user
        [self _saveUser:user];
        [[self presentingViewController] viewWillAppear:YES];
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

        [self.delegate didChangeSettingsToDefaultUser:user];

    }           andErrorHandler:^(NSException *exception) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No account?" message:@"Please ask about your account name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];

    }];
}

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


@end