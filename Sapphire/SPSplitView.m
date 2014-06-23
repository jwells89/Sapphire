//
//  SPSplitView.m
//  Sapphire
//
//  Created by John Wells on 1/21/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "SPSplitView.h"

@implementation SPSplitView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        self.leftPaneState = 0;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

-(void)toggleLeftPane:(id)sender
{
    if (self.leftPaneState == 0) {
        self.previousPosition = [self positionOfDividerAtIndex:0];
        self.leftPaneState = 1;
        [self setPosition:0 ofDividerAtIndex:0 animated:YES];
    } else {
        self.leftPaneState = 0;
        [self setPosition:self.previousPosition ofDividerAtIndex:0 animated:YES];
    }
    
}

@end
