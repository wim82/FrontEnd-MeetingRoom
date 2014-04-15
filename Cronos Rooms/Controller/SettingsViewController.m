//
// Created by Jean Smits on 15/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsView.h"

@interface SettingsViewController () {

}

@property(nonatomic, strong) SettingsView *settingsView;

@end

@implementation SettingsViewController {

}
- (void)loadView {
    self.settingsView = [[SettingsView alloc] initWithFrame:[UIScreen mainScreen].bounds andDelegate:self];
    self.view = self.settingsView;
}

@end