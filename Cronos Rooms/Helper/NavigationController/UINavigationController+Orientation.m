//
//  UINavigationController+Orientation.h
//   thanks to Michel
//

#import "UINavigationController+Orientation.h"

@implementation UINavigationController (Orientation)

-(BOOL)shouldAutorotate
{
    if (!self.viewControllers) {
        return NO;
    }
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    if (!self.viewControllers) {
        return UIInterfaceOrientationMaskPortrait;
    }
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (!self.viewControllers) {
        return UIInterfaceOrientationPortrait;
    }
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end
