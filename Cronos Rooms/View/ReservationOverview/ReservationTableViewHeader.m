#import "ReservationTableViewHeader.h"
#import "UIColor+AppColor.h"

@interface ReservationTableViewHeader ()
@property(nonatomic, strong) UIView *headerView;
@end

@implementation ReservationTableViewHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        //this is superweird but it works - frame always comes in as null
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.superview.frame.size.width, 24)];
        self.headerView.backgroundColor = [UIColor app_ultraLightGrey];
        [self addSubview:self.headerView];

        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, self.headerView.frame.size.height-1, self.headerView.frame.size.width, 1);
        bottomBorder.backgroundColor = [UIColor app_lightGrey].CGColor;

        [self.headerView.layer addSublayer:bottomBorder];
        self.lblDate = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width, 24)];

        self.lblDate.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        self.lblDate.textColor = [UIColor darkGrayColor];

        [self addSubview:self.lblDate];

    }
    return self;
}


@end
