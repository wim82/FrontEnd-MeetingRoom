//
// Found this code at http://www.cocoanetics.com/2010/10/custom-colored-disclosure-indicators/
//

#import <Foundation/Foundation.h>


@interface DTCustomColoredAccessory : UIControl
{
    UIColor *_accessoryColor;
    UIColor *_highlightedColor;
}

@property (nonatomic, retain) UIColor *accessoryColor;
@property (nonatomic, retain) UIColor *highlightedColor;

+ (DTCustomColoredAccessory *)accessoryWithColor:(UIColor *)color;

@end