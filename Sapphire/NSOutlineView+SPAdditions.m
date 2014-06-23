//
//  NSOutlineView+SPAdditions.m
//  Sapphire
//
//  Created by John Wells on 2/3/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "NSOutlineView+SPAdditions.h"

@implementation NSOutlineView (SPAdditions)

-(NSView *)viewAtColumn:(NSInteger)column rowWithRepresentedObject:(id)representedObject
{
    for (int i = 0; i < [self numberOfRows]; i++)
    {
        if ([[self itemAtRow:i] representedObject] == representedObject) {
            return [self viewAtColumn:column row:i makeIfNecessary:NO];
        }
    }
    
    return nil;
}

@end
