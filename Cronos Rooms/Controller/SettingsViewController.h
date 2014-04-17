//
// Created by Jean Smits on 15/04/14.
// Copyright (c) 2014 KaWi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CountDownViewController.h"


@protocol SettingsDelegate <NSObject>

@optional
- (void)launchCountDownViewController:(CountDownViewController *)countDownViewController;

@end


@interface SettingsViewController : UIViewController
@property (nonatomic, assign) id delegate;
@end