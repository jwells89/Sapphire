//
//  SPTableCellView.m
//  Sapphire
//
//  Created by John Wells on 1/26/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "SPTableCellView.h"

@implementation SPTableCellView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.accessoryButton setHidden:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

-(void)viewWillDraw
{
    [super viewWillDraw];
    if (self.shouldShowAccessoryButton) {
        [self.accessoryButton setHidden:NO];
    } else {
        [self.accessoryButton setHidden:YES];
    }
}

-(BOOL)shouldShowAccessoryButton
{
    if ([self.objectValue isStatic]) {
        return NO;
    } else {
        return _shouldShowAccessoryButton;
    }
}

@end
