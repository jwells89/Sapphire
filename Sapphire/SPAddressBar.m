//
//  JWAddressBar.m
//  Surf
//
//  Created by John Wells on 5/25/13.
//  Copyright (c) 2013 John Wells. All rights reserved.
//

#import "SPAddressBar.h"

@implementation SPAddressBar

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _icon = [[NSImage alloc] init];
    }
    
    return self;
}

-(void)awakeFromNib
{
     [self setIcon:[NSImage imageNamed:@"BookmarkIcon"]];
}

-(void)setIcon:(NSImage *)icon
{
    _icon = icon;
    [self setNeedsDisplay: YES];
}


-(void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect:NSMakeRect(3, 3, 21, 17)];
    
    [self.icon drawInRect:NSMakeRect(6, 3, 16, 16) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
}


@end
