//
//  SPOutlineView.m
//  Sapphire
//
//  Created by John Wells on 2/4/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "SPOutlineView.h"

@implementation SPOutlineView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

- (BOOL)acceptsFirstResponder
{
    return NO;
}

-(void)viewDidMoveToWindow
{
    int opts = (NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved);
    NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                        options:opts
                                                          owner:self
                                                       userInfo:nil];
    
    [self addTrackingArea:area];
}

-(void)mouseExited:(NSEvent *)theEvent
{
    if (self.hoverRow > -1 && self.hoverRow < [self numberOfRows]) {
        SPTableCellView *hoverCell = [self viewAtColumn:0 row:self.hoverRow makeIfNecessary:NO];
        
        [hoverCell setShouldShowAccessoryButton:NO];
        [self setNeedsDisplayInRect:[self rectOfRow:self.hoverRow]];
    }
    
    if (self.lastHoverRow && self.lastHoverRow < [self numberOfRows]) {
        SPTableCellView *lastCell = [self viewAtColumn:0 row:self.lastHoverRow makeIfNecessary:NO];
        
        [lastCell setShouldShowAccessoryButton:NO];
        
        [self setNeedsDisplayInRect:[self rectOfRow:self.lastHoverRow]];
    }
}

-(void)mouseMoved:(NSEvent *)theEvent
{
    self.hoverRow = [self rowAtPoint:[self convertPoint:theEvent.locationInWindow fromView:nil]];
    
    if (self.hoverRow > -1 && self.hoverRow < [self numberOfRows]) {
        SPTableCellView *hoverCell = [self viewAtColumn:0 row:self.hoverRow makeIfNecessary:NO];
        
        [hoverCell setShouldShowAccessoryButton:YES];
        [self setNeedsDisplayInRect:[self rectOfRow:self.hoverRow]];
        
        if (self.lastHoverRow == self.hoverRow)
			return;
		else {
            if (self.lastHoverRow && self.lastHoverRow < [self numberOfRows]) {
                SPTableCellView *lastCell = [self viewAtColumn:0 row:self.lastHoverRow makeIfNecessary:NO];
                
                [lastCell setShouldShowAccessoryButton:NO];
                
                [self setNeedsDisplayInRect:[self rectOfRow:self.lastHoverRow]];
            }
			self.lastHoverRow = self.hoverRow;
		}
        
        
    }
}

@end
