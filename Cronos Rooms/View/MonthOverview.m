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
        
        //TODO how to check orientation? This if test doesn't seem to work
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        
        NSLog(@"orientation:%d",orientation);
        
    /*    if (UIInterfaceOrientationIsLandscape(orientation))
        {realWidth=1024;
        NSLog(@"realWidth : %ld", (long)realWidth);}
        
        else{realWidth=768;
        NSLog(@"realWidth : %ld", (long)realWidth);} */
                
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
        realWidth=768;
        realHeight=1024;
        
        
    } else {
        realWidth=320;
        realHeight=568;
        
        if ([[AppState sharedInstance]deviceIsIOS7]) {
            //i4 + iOS7
         /*   self.const_btn_dismiss_leading.constant = 220;
            self.constr_btn_dismiss_top.constant = 40;
            
            self.constr_lbl_title_leading.constant = 10;
            self.constr_lbl_title_top.constant = 100;
            
            self.constr_scrollView_top.constant = 140;
            self.constr_scrollView_leading.constant = 0;
            self.constr_constr_scrollView_width.constant = 320;
            self.contr_scrollView_height.constant = 200;
            
            
            self.constr_btn_download_top.constant = 370;
            self.constr_btn_download_leading.constant = 80;   */
            
        }
    }
}

- (void)loadConstraintsForLandscape{
    
    if ([[AppState sharedInstance]deviceIsiPad]) {
        
        self.backgroundColor= [UIColor greenColor];
        realWidth = 1024;
        realHeight = 768;
        
        
    } else {
        
        realWidth=568;
        realHeight=320;
        //i4 + iOS7
    /*    if ([[AppState sharedInstance]deviceIsIOS7]) {
            self.const_btn_dismiss_leading.constant = 390;
            self.constr_btn_dismiss_top.constant = 20;
            
            self.constr_lbl_title_leading.constant = 90;
            self.constr_lbl_title_top.constant = 25;
            
            self.constr_scrollView_top.constant = 60;
            self.constr_scrollView_leading.constant = 0;
            self.constr_constr_scrollView_width.constant = 480;
            self.contr_scrollView_height.constant = 260;
            
            self.constr_btn_download_top.constant = 20;
            self.constr_btn_download_leading.constant = 0;
        }  */
    }
}





@end
