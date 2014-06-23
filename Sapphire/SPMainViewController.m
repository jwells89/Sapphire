//
//  SPMainViewController.m
//  Sapphire
//
//  Created by John Wells on 1/26/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "SPMainViewController.h"

@implementation SPMainViewController

-(void)changeViewWithTabItem:(SPTabItem *)tabItem
{
    if (tabItem.isGroupItem == NO) {
        if (tabItem.view != nil) {
            [self.mainBoxView setContentView:tabItem.view];
        }
    } else {
        [self.mainBoxView setContentView:self.tabCollectionView];
    }
}

-(NSView *)tabCollectionView
{
    return [[NSView alloc] init];
}

-(void)showCollectionViewForTabGroup:(SPTabItem *)tabGroup
{
    
}

@end
