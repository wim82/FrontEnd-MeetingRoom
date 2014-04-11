#import "DatePickerView.h"
#import "IDatePickerSlider.h"
#import "NSDate+Helper.h"
#import "UIColor+AppColor.h"

@interface DatePickerView ()
@end

@implementation DatePickerView {
    id <IDatePickerSlider> _delegate;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title date:(NSDate *)date mode:(UIDatePickerMode)mode andDelegate:(id <IDatePickerSlider>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        self.clipsToBounds = YES;
        self.datePickerSlideOpen = NO;
        self.dateView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, frame.size.width, 44)];

        UITapGestureRecognizer *uiTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slideDatePicker)];
        [self.dateView addGestureRecognizer:uiTapGestureRecognizer];
        [self addSubview:self.dateView];

        self.dateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        self.dateTitleLabel.text = title;
        [self.dateView addSubview:self.dateTitleLabel];

        self.dateValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 40, 44)];
        self.dateValueLabel.textAlignment = NSTextAlignmentRight;
        self.dateValueLabel.text = @"";

        [self.dateView addSubview:self.dateValueLabel];

        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, frame.size.width, 216)];
        [self.datePicker setDate:date];
        [self.datePicker setDatePickerMode:mode];
        [self.datePicker setMinuteInterval:15];
        [self.datePicker addTarget:self action:@selector(updateDateValue) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.datePicker];

        [self updateDateValue];
    }
    return self;
}

- (void)updateDateValue {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:self.datePicker.datePickerMode == UIDatePickerModeDateAndTime ? DATEFORMAT_SHORT_DATE_AND_SHORT_TIME : DATEFORMAT_SHORT_TIME];
    self.dateValueLabel.text = [formatter stringFromDate:self.datePicker.date];
}

- (void)slideDatePicker {
    [UIView animateWithDuration:0.3 animations:^{
        if (self.datePickerSlideOpen) {
            [_delegate datePickerDidSlideOpen:NO sentBy:self];
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - 216);
        }
        else {
            [_delegate datePickerDidSlideOpen:YES sentBy:self];
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + 216);
        }
    }];

    self.datePickerSlideOpen = !self.datePickerSlideOpen;
}


@end