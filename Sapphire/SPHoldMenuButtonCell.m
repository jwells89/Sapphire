//
//  SPHoldMenuButtonCell.m
//  Sapphire
//
//  Created by John Wells on 5/13/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "SPHoldMenuButtonCell.h"

@implementation SPHoldMenuButtonCell

- (BOOL)trackMouse:(NSEvent *)event inRect:(NSRect)cellFrame ofView:(NSView *)controlView untilMouseUp:(BOOL)untilMouseUp
{
    // if menu defined show on left mouse
    if ([event type] == NSLeftMouseDown && [self menu]) {
        
        NSPoint result = [controlView convertPoint:NSMakePoint(NSMidX(cellFrame), NSMidY(cellFrame)) toView:nil];
        
        NSEvent *newEvent = [NSEvent mouseEventWithType: [event type]
                                               location: result
                                          modifierFlags: [event modifierFlags]
                                              timestamp: [event timestamp]
                                           windowNumber: [event windowNumber]
                                                context: [event context]
                                            eventNumber: [event eventNumber]
                                             clickCount: [event clickCount]
                                               pressure: [event pressure]];
        
        // need to generate a new event otherwise selection of button
        // after menu display fails
        [NSMenu popUpContextMenu:[self menu] withEvent:newEvent forView:controlView];
        
        return YES;
    }
    
    return [super trackMouse:event inRect:cellFrame ofView:controlView untilMouseUp:untilMouseUp];
}

@end
