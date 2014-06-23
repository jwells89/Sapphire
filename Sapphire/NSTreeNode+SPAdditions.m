//
//  NSTreeNode+SPAdditions.m
//  Sapphire
//
//  Created by John Wells on 1/30/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "NSTreeNode+SPAdditions.h"

@implementation NSTreeNode (SPAdditions)

-(NSTreeNode *)subnodeClosestToIndex:(NSInteger)index
{
    if (index - 1 > -1) {
        return [self childNodes][index-1];
    } else if (index + 1 < [self.childNodes count]) {
        return [self childNodes][index+1];
    }
    
    return nil;
}

-(NSTreeNode *)subnodeClosestToSubnode:(NSTreeNode *)subnode
{
    NSInteger subnodeIndex = [self.childNodes indexOfObject:subnode];
    
    if (subnodeIndex > 0 && subnodeIndex < [self.childNodes count]) {
        return [self subnodeClosestToIndex:subnodeIndex];
    }
    
    return nil;
}

@end
