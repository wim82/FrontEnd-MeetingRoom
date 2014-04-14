//
//  MonthOverview.m
//  Cronos Rooms
//
//  Created by Katrien De Mey on 13/04/14.
//  Copyright (c) 2014 KaWi. All rights reserved.
//

#import "MonthOverview.h"


@implementation MonthOverview
NSInteger realWidth;

- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate
{
    self = [super initWithFrame:frame];
    
    
    if (self) {
        
        //TODO how to check orientation? This if test doesn't seem to work
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        
        NSLog(@"orientation:%d",orientation);
        
        if (UIInterfaceOrientationIsLandscape(orientation))
        {realWidth=1024;}
        else{realWidth=768;}
                
        self.backgroundColor = [UIColor blueColor];
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.height ) collectionViewLayout:layout];
        self.collectionView.delegate = delegate;
        self.collectionView.dataSource = delegate;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionView];
        
    }
    return self;
    
    
}

/*

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    self.itemSize = CGSizeMake(125.0f, 125.0f);
    self.interItemSpacingY = 12.0f;
    self.numberOfColumns = 2;
}

 */



@end
