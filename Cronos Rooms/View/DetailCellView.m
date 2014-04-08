//
// Created by Jean Smits on 4/04/14.
// Copyright (c) 2014 wim. All rights reserved.
//

#import "DetailCellView.h"

#define DETAIL_LABEL_TOP_PADDING 10
#define DETAIL_LABEL_HEIGHT 16
#define DETAIL_TEXTFIELD_HEIGHT 28
#define DETAIL_TEXTFIELD_TOP_PADDING 26

@interface DetailCellView () <UITextFieldDelegate>

@end

@implementation DetailCellView {
    //id _delegate;

}
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title andValue:(NSString *)value andDelegate:(id)delegate {
    self = [super initWithFrame:frame];
    if (self) {
      //  _delegate = delegate;
        self.detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];;
        [self addSubview:self.detailView];

        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, DETAIL_LABEL_TOP_PADDING, frame.size.width - 20, DETAIL_LABEL_HEIGHT)];
        self.detailLabel.textColor = [UIColor greenColor];
        self.detailLabel.font = [UIFont systemFontOfSize:10];
        self.detailLabel.text = title;

        [self.detailView addSubview:self.detailLabel];

        self.detailTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, DETAIL_TEXTFIELD_TOP_PADDING, frame.size.width - 20, DETAIL_TEXTFIELD_HEIGHT)];

        //if no value for the textfield is specified, set placeholder
        //if there is a value, show detailLabel
        if (!value) {
            self.detailLabel.hidden = YES;
            self.detailTextField.placeholder = title;
        } else {
            self.detailTextField.text = value;
        }

        self.detailTextField.delegate = delegate;
        [self.detailView addSubview:self.detailTextField];


    }
    return self;
}



@end