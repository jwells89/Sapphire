//
//  JWAddressBarCell.m
//  Surf
//
//  Created by John Wells on 5/25/13.
//  Copyright (c) 2013 John Wells. All rights reserved.
//

#import "SPAddressBarCell.h"

@implementation SPAddressBarCell

- (void)selectWithFrame:(NSRect)cellFrame inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength {
    
    cellFrame.origin.x += 22;
    cellFrame.size.width -=23;
    [super selectWithFrame:cellFrame inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
}

-(void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    cellFrame.origin.x += 22;
    cellFrame.size.width -=23;
    [super drawInteriorWithFrame:cellFrame inView:controlView];
}


@end
