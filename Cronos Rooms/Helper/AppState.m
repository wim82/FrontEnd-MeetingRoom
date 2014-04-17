//
//  AppState.m
//  Club-Brugge-Video-Zone
//
//  Created by Michel Hoeylaerts on 15/11/13.
//  Copyright (c) 2013 Cozmos. All rights reserved.
//

#import "AppState.h"

@implementation AppState

#pragma mark Initialization & Dealloc

+ (AppState *)sharedInstance {
    static AppState *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^ {
        if (instance == nil) {
            instance = [[AppState alloc] init];
            [instance setUpDeviceProperties];
            //[instance setUpCurrentLanguage];
        }
    });
    
    return instance;
}

- (void)setUpDeviceProperties {
    self.deviceIsIOS7 = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0);
    self.deviceIsiPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    self.deviceIsiPhone5 = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0);
    self.deviceIsLandscape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
}

/*
- (void)setUpCurrentLanguage {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *language = [userDefaults objectForKey:kUserDefaultsLanguage];
    self.currentLanguage = (language.length==0 ? @"nl" : language);
    if(language.length == 0) {
        [userDefaults setObject:self.currentLanguage forKey:kUserDefaultsLanguage];
        [userDefaults synchronize];
    }
}
    */

- (BOOL)deviceIsLandscape{
    return UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
}


- (BOOL) deviceIsiPad
{
    static int idiom = -1;

    if (idiom == -1) {
        idiom = UI_USER_INTERFACE_IDIOM();
    }

    return idiom == UIUserInterfaceIdiomPad;
}

//- (BOOL)deviceIsiPhone5
//{
//    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height >= 568.0);
//}

//- (BOOL)deviceIsLandscape{
//    return UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
//}


- (NSString *) documentsPath
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    return [searchPaths objectAtIndex:0];
}

- (BOOL)deviceIsIOS7 {
    BOOL isIOS7;

    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        isIOS7 = YES;
    }
    else{
        isIOS7 = NO;
    }
    return isIOS7;
}

- (NSString *)currentLanguage {
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    NSString *currentLanguage = (language.length==0 ? nil : language);
    return currentLanguage;
}

- (NSString *)currentLocalizationTable {
    NSString *currentLanguage = [self currentLanguage];
    return [NSString stringWithFormat:@"Localization_%@", currentLanguage];
}

- (BOOL)freeDiskspace
{
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
       // NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
        if (((totalSpace/1024ll)/1024ll) < 100) {
            return NO;
        } else {
            return YES;
        }
    } else {
       // NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %d", [error domain], [error code]);
        return YES;
    }
    
    //return totalFreeSpace;
}



@end
