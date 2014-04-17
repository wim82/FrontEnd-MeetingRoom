//
//  MonthOverview.m
//  Cronos Rooms
//
//  Created by Katrien De Mey on 13/04/14.
//  Copyright (c) 2014 KaWi. All rights reserved.
//

#import "MonthOverview.h"
#import "UIColor+AppColor.h"
#import "AppState.h"



@implementation MonthOverview
NSInteger realWidth;
NSInteger realHeight;

- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate
{
    self = [super initWithFrame:frame];
    
    
    if (self) {
        
        self.backgroundColor = [UIColor app_blueGreyShaded];
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, realWidth, realHeight ) collectionViewLayout:layout];
        
        self.collectionView.delegate = delegate;
        self.collectionView.dataSource = delegate;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionView];
        
    }
    return self;
    
    
}



- (void)loadConstraintsForPortrait{
    
    if ([[AppState sharedInstance]deviceIsiPad]) {
        
        self.backgroundColor = [UIColor purpleColor];
        realWidth = 768;
        realHeight = 1024;
        
        
    } else {
        realWidth = 320;
        realHeight = 568;
        
    }
}

- (void)loadConstraintsForLandscape{
    
    if ([[AppState sharedInstance]deviceIsiPad]) {
        
        self.backgroundColor = [UIColor greenColor];
        realWidth = 1024;
        realHeight = 768;
        
        
    } else {
        
        realWidth = 568;
        realHeight = 320;
      
    }
}





@end
