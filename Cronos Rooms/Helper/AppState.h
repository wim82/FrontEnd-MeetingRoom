//
//  AppState.h
//  Club-Brugge-Video-Zone
//
//  Created by Michel Hoeylaerts on 15/11/13.
//  Copyright (c) 2013 Cozmos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppState : NSObject

+ (AppState *)sharedInstance;


//@property (nonatomic, assign) BOOL deviceIsiPad;

@property (nonatomic, assign) BOOL deviceIsiPhone5;

@property (nonatomic, assign) BOOL deviceIsLandscape;

@property (nonatomic, assign) BOOL deviceIsIOS7;

@property (nonatomic, strong) NSString *documentsPath;

@property (nonatomic, strong) NSString *currentLanguage;

- (NSString *)currentLocalizationTable;

- (BOOL)freeDiskspace;

@end
