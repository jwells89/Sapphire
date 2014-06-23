//
//  NSTreeController+SPAdditions.h
//  Sapphire
//
//  Created by John Wells on 1/29/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSTreeController (SPAdditions)

@property (nonatomic, weak) NSTreeNode *selectedNode;
@property (nonatomic) NSInteger selectedIndex;

-(NSTreeNode *)nodeAtIndexPath:(NSIndexPath *)indexPath;
-(NSTreeNode *)nodeAtIndex:(NSInteger)index;
-(NSTreeNode *)subnodeWithParentIndex:(NSInteger)parentIndex subIndex:(NSInteger)childIndex;
-(NSTreeNode *)subnodeFromParentNode:(NSTreeNode *)parentNode withIndex:(NSInteger)childIndex;
-(id)representedObjectForNodeAtIndexPath:(NSIndexPath *)indexPath;
-(void)selectNodeAtIndex:(NSInteger)index withSubnodeAtIndex:(NSInteger)childIndex;
-(void)selectNodeWithIndexString:(NSString *)indexString;

- (NSIndexPath *)indexPathOfObject:(id)anObject;
- (NSIndexPath *)indexPathOfObject:(id)anObject inNodes:(NSArray*)nodes;

- (id)objectForKeyedSubscript:(id)key;


@end
