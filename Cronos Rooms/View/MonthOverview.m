//
//  MonthOverview.m
//  Cronos Rooms
//
//  Created by Katrien De Mey on 13/04/14.
//  Copyright (c) 2014 KaWi. All rights reserved.
//

#import "MonthOverview.h"
#import "UIColor+AppColor.h"


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
        {realWidth=1024;
        NSLog(@"realWidth : %ld", (long)realWidth);}
        
        else{realWidth=768;
        NSLog(@"realWidth : %ld", (long)realWidth);}
                
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


@end
