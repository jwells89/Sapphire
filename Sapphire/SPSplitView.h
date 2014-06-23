//
//  SPSplitView.h
//  Sapphire
//
//  Created by John Wells on 1/21/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSSplitView+DMAdditions.h"

@interface SPSplitView : NSSplitView

@property NSInteger leftPaneState;
@property float previousPosition;

- (IBAction)toggleLeftPane:(id)sender;

@end
