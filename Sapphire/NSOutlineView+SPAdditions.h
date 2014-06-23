//
//  NSOutlineView+SPAdditions.h
//  Sapphire
//
//  Created by John Wells on 2/3/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSOutlineView (SPAdditions)

- (NSView *)viewAtColumn:(NSInteger)column rowWithRepresentedObject:(id)representedObject;

@end
