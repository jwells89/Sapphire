//
//  NSTreeController+SPAdditions.m
//  Sapphire
//
//  Created by John Wells on 1/29/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "NSTreeController+SPAdditions.h"
#import "NSIndexPath+JWSIndexPathAdditions.h"

@implementation NSTreeController (SPAdditions)

///Shortcut methods, because who wants to take the scenic route every time?

-(NSTreeNode *)nodeAtIndexPath:(NSIndexPath *)indexPath
{
    NSTreeNode *treeNode = [self.arrangedObjects descendantNodeAtIndexPath:indexPath];
    
    return treeNode ? treeNode : nil;
}

-(NSTreeNode *)nodeAtIndex:(NSInteger)index
{
    NSTreeNode *treeNode = [self nodeAtIndexPath:[NSIndexPath indexPathWithIndex:index]];
    
    return treeNode ? treeNode : nil;
}

-(NSTreeNode *)subnodeWithParentIndex:(NSInteger)parentIndex subIndex:(NSInteger)childIndex
{
    NSUInteger itemIndexes[] = {parentIndex, childIndex};
    NSIndexPath *itemIndexPath = [NSIndexPath indexPathWithIndexes:itemIndexes length:2];
    NSTreeNode *treeNode = [self nodeAtIndexPath:itemIndexPath];
    
    return treeNode ? treeNode : nil;
}

-(NSTreeNode *)subnodeFromParentNode:(NSTreeNode *)parentNode withIndex:(NSInteger)childIndex
{
    if (childIndex > 0 && childIndex <= [parentNode.childNodes count]) {
        return [[parentNode childNodes] objectAtIndex:childIndex];
    }
    
    return nil;
}

-(id)representedObjectForNodeAtIndexPath:(NSIndexPath *)indexPath
{
    NSTreeNode *treeNode = [self nodeAtIndexPath:indexPath];
    
    return [treeNode representedObject] ? [treeNode representedObject] : nil;
}

-(NSTreeNode *)selectedNode
{
    if ([self.selectedNodes count] > 0) {
        return self.selectedNodes[0];
    }
    
    return nil;
}

-(void)setSelectedNode:(NSTreeNode *)treeNode
{
    if (treeNode) {
        [self setSelectionIndexPath:[treeNode indexPath]];
    }
}

-(NSInteger)selectedIndex
{
    NSTreeNode *selectedTreeNode = [self selectedNode];
    if (selectedTreeNode) {
        return [[selectedTreeNode indexPath] indexAtPosition:0];
    }
    return -1;
}

-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (selectedIndex > -1 && selectedIndex <= [[[self arrangedObjects] childNodes] count]) {
        [self setSelectionIndexPath:[NSIndexPath indexPathWithIndex:selectedIndex]];
    }
}

-(void)selectNodeAtIndex:(NSInteger)index withSubnodeAtIndex:(NSInteger)childIndex
{
    NSTreeNode *treeNode = [self subnodeWithParentIndex:index subIndex:childIndex];
    
    if (treeNode) {
        [self setSelectedNode:treeNode];
    }
}

-(void)selectNodeWithIndexString:(NSString *)indexString
{
    NSIndexPath *targetPath = [NSIndexPath indexPathWithString:indexString];
    
    [self setSelectionIndexPath:targetPath];
}

- (NSIndexPath *)indexPathOfObject:(id)anObject
{
    return [self indexPathOfObject:anObject inNodes:[[self arrangedObjects] childNodes]];
}

- (NSIndexPath *)indexPathOfObject:(id)anObject inNodes:(NSArray*)nodes
{
    for (int i = 0; i < [nodes count]; i++) {
        NSTreeNode *node = nodes[i];
        
        if ([[node representedObject] isEqual:anObject])
        {
            return [node indexPath];
        }
        
        if([[node childNodes] count])
        {
            NSIndexPath* path = [self indexPathOfObject:anObject inNodes:[node childNodes]];
            if (path)
            {
                return path;
            }
        }
    }
    
    return nil;
}

-(id)objectForKeyedSubscript:(id)key
{
    NSIndexPath *path = [NSIndexPath indexPathWithString:key];
    
    if (path != nil) {
        return [self nodeAtIndexPath:path];
    }
    return nil;
}



@end
