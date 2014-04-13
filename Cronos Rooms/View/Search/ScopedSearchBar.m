

@interface ScopedSearchBar : UISearchBar {
}

@end


@implementation ScopedSearchBar

- (void)setShowsScopeBar:(BOOL)show {
    [super setShowsScopeBar:YES]; // always show!
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self setShowsCancelButton:NO animated:NO];
}

@end