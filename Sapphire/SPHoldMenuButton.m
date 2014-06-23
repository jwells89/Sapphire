//
//  SPHoldMenuButton.m
//  Sapphire
//
//  Created by John Wells on 5/13/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "SPHoldMenuButton.h"

@implementation SPHoldMenuButton


- (void)mouseDown:(NSEvent *)theEvent {
    
    // if a menu is defined let the cell handle its display
    if (self.menu) {
        if ([theEvent type] == NSLeftMouseDown) {
            [[self cell] setMenu:[self menu]];
        } else {
            [[self cell] setMenu:nil];
        }
    }
    
    [super mouseDown:theEvent];
}


@end
