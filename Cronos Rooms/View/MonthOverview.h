//
//  MonthOverview.h
//  Cronos Rooms
//
//  Created by Katrien De Mey on 13/04/14.
//  Copyright (c) 2014 KaWi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthOverview : UIView

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;

- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate;

@end