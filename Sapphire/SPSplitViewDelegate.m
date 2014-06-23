//
//  SPSplitViewDelegate.m
//  Sapphire
//
//  Created by John Wells on 1/30/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "SPSplitViewDelegate.h"
#import "SPDocument.h"

@implementation SPSplitViewDelegate

-(void)splitViewDidResizeSubviews:(NSNotification *)notification
{
    [[self.splitView.window.windowController document] adjustStatusText];
}

- (BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex
{
    switch (dividerIndex) {
        case 0:
            return YES;
            break;
            
        default: return NO;
            break;
    }
}

@end
