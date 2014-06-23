//
//  NSTreeNode+SPAdditions.h
//  Sapphire
//
//  Created by John Wells on 1/30/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSTreeNode (SPAdditions)

-(NSTreeNode *)subnodeClosestToIndex:(NSInteger)index;
-(NSTreeNode *)subnodeClosestToSubnode:(NSTreeNode *)subnode;

@end
