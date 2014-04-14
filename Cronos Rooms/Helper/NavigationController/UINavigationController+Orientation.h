//
//  UINavigationController+Orientation.h
//   thanks to Michel

#import <UIKit/UIKit.h>

@interface UINavigationController (Orientation)

- (BOOL)shouldAutorotate;

- (NSUInteger)supportedInterfaceOrientations;

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation;

@end
