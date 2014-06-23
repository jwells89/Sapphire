//
//  SPMainViewController.h
//  Sapphire
//
//  Created by John Wells on 1/26/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPTabItem.h"

@interface SPMainViewController : NSObject

@property (weak) IBOutlet NSBox *mainBoxView;
@property (weak, nonatomic) NSView *tabCollectionView;

-(void)changeViewWithTabItem:(SPTabItem *)tabItem;
-(void)showCollectionViewForTabGroup:(SPTabItem *)tabGroup;

@end
