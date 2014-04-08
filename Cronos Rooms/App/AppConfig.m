//
// Created by Jean Smits on 7/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import "AppConfig.h"

@interface AppConfig ()

@property(nonatomic, strong) NSDictionary *configDictionary;

@end

@implementation AppConfig

+ (AppConfig *)sharedAppConfig {

    static AppConfig *instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[AppConfig alloc] init];
        }
    });

    return instance;
}

- (NSString *)baseURL {
    return [self _configValueForKey:@"baseURL"];
}



#pragma mark - Private Methods

- (id)_configValueForKey:(NSString *)key {

    @synchronized (self) {
        if (self.configDictionary == nil) {
            NSBundle *mainBundle = [NSBundle mainBundle];
            NSString *path = [mainBundle pathForResource:@"config" ofType:@"plist"];
            self.configDictionary = [NSDictionary dictionaryWithContentsOfFile:path];

        }
    }

    NSArray *keyPath = [key componentsSeparatedByString:@":"];
    NSDictionary *dict = self.configDictionary;
    for (NSString *keyPathElement in keyPath) {
        id value = [dict objectForKey:keyPathElement];
        if (value == nil) {
            return nil;
        }

        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            return value;
        }

        if ([value isKindOfClass:[NSDictionary class]]) {
            dict = value;
        }
    }

    return nil;
}
@end