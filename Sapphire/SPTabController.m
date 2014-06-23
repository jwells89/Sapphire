//
//  SPTabController.m
//  Sapphire
//
//  Created by John Wells on 1/24/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "SPTabController.h"
#import "SPDocument.h"
#import "NSIndexPath+JWSIndexPathAdditions.h"

@implementation SPTabController

- (id)init
{
    self = [super init];
    if (self) {
        self.tabItemArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)doInitialSetup
{
    SPTabItem *personalItem = [SPTabItem groupItemWithTitle:@"PERSONAL"];
    SPTabItem *bookmarksItem = [SPTabItem tabItemWithTitle:@"Bookmarks"];
    SPTabItem *historyItem = [SPTabItem tabItemWithTitle:@"History"];
    
    personalItem.isStatic = YES;
    bookmarksItem.icon = [NSImage imageNamed:@"bookmarksTemplate"];
    bookmarksItem.isStatic = YES;
    historyItem.icon = [NSImage imageNamed:@"historyTemplate"];
    historyItem.isStatic = YES;
    
    [personalItem.children addObjectsFromArray:@[bookmarksItem, historyItem]];
    
    [self.tabItemsTreeController addObject:personalItem];
    
    SPTabItem *defaultTabGroup = [SPTabItem groupItemWithTitle:@"GENERAL"];
    
    [self.tabItemsTreeController addObject:defaultTabGroup];
    [self.tabItemsTreeController selectNodeAtIndex:1 withSubnodeAtIndex:0];
    
    if ([self.hostDocument fileURL] != nil) {
        [self newTabWithURL:[self.hostDocument fileURL]];
    } else {
        [self.tabItemsTreeController selectNodeWithIndexString:@"0:0"];
    }
}

-(void)restoreUserTabsWithArray:(NSArray *)tabArray
{
    for (SPTabItem *i in tabArray) {
        NSLog(@"title: %@", i.title);
        [self.tabItemsTreeController addObject:i];
    }
}

#pragma mark - NSOutlineView Delegate/Data Source Methods

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item{
    return ![[item representedObject] isGroupItem];
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    
    if ([[item representedObject] isGroupItem]) {
        return [outlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
    } else {
        return [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    return [[item representedObject] isGroupItem];
}


-(void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    [self.mainViewController changeViewWithTabItem:self.selectedTabItem];
    [self.hostDocument updateUIForTab:self.selectedTabItem];
}

#pragma mark Drag & Drop

- (id <NSPasteboardWriting>)outlineView:(NSOutlineView *)outlineView pasteboardWriterForItem:(id)item{
    // No dragging if <some condition isn't met>
    BOOL dragAllowed = ![[item representedObject] isStatic];
    if (!dragAllowed)  {
        return nil;
    }
    
    NSTreeNode *tabNode = (NSTreeNode *)item;
  //  SPTabItem *tabItem = (SPTabItem *)(((NSTreeNode *)item).representedObject);
    
    NSPasteboardItem *pboardItem = [[NSPasteboardItem alloc] init];
    [pboardItem setString:[tabNode.indexPath stringRepresentation] forType: @"public.text"];
    
    return pboardItem;
}


- (NSDragOperation)outlineView:(NSOutlineView *)outlineView validateDrop:(id < NSDraggingInfo >)info proposedItem:(id)targetItem proposedChildIndex:(NSInteger)index{
    
    NSString *pathString = [[info draggingPasteboard] stringForType:@"public.text"];
    SPTabItem *sourceItem = [self.tabItemsTreeController[pathString] representedObject];
    
    BOOL canDrag;
    
    if ([sourceItem isGroupItem]) {
        canDrag = index >= 1 && !targetItem && ![[targetItem representedObject] isStatic] ;
    } else {
        canDrag = index >= 0 && targetItem && ![[targetItem representedObject] isStatic];
    }
    
    if (canDrag) {
        return NSDragOperationMove;
    }else {
        return NSDragOperationNone;
    }
}


- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id < NSDraggingInfo >)info item:(id)targetItem childIndex:(NSInteger)index{
    
    NSPasteboard *p = [info draggingPasteboard];
    NSString *pathString = [p stringForType:@"public.text"];
    NSTreeNode *sourceNode = [self.tabItemsTreeController nodeAtIndexPath:[NSIndexPath indexPathWithString:pathString]];
    
    if(!sourceNode){
        // Not found
        return NO;
    }

    NSIndexPath *toIndexPATH = [[targetItem indexPath] indexPathByAddingIndex:index];
    
    [self.tabItemsTreeController moveNode:sourceNode toIndexPath:toIndexPATH];
    
    return YES;
}

#pragma mark - Tab Management
#pragma mark Selected Tab

-(SPTabItem *)selectedTabItem
{
    return [[self.tabItemsTreeController selectedObjects] count] > 0 ? [self.tabItemsTreeController selectedObjects][0] : nil;
}

-(SPTabItem *)selectedTabParent
{
    return [[self.tabItemsTreeController selectedObjects] count] > 0 ? [[[self.tabItemsTreeController selectedNode] parentNode] representedObject] : nil;
}

-(void)selectPreviousTab:(id)sender
{
    SPTabItem *selectedTabParent = [self selectedTabParent];
    SPTabItem *selectedTabItem = [self selectedTabItem];
    
    if ([[selectedTabParent children] indexOfObject:selectedTabItem] > 0) {
        [self.tabItemsTreeController selectNodeAtIndex:[self.tabItemArray indexOfObject:selectedTabParent]
                                    withSubnodeAtIndex:[[selectedTabParent children] indexOfObject:selectedTabItem]-1];
    } else if ([self.tabItemArray indexOfObject:selectedTabParent] > 1) {
        NSInteger targetTabGroupIndex = [self.tabItemArray indexOfObject:selectedTabParent]-1;
        SPTabItem *targetTabGroup = [self.tabItemArray objectAtIndex:targetTabGroupIndex];
        
        [self.tabItemsTreeController selectNodeAtIndex:targetTabGroupIndex
                                    withSubnodeAtIndex:[[targetTabGroup children] count]-1];
    }
}

-(void)selectNextTab:(id)sender
{
    SPTabItem *selectedTabParent = [self selectedTabParent];
    SPTabItem *selectedTabItem = [self selectedTabItem];
    
    if ([[selectedTabParent children] indexOfObject:selectedTabItem] < [[selectedTabParent children] count]-1) {
        [self.tabItemsTreeController selectNodeAtIndex:[self.tabItemArray indexOfObject:selectedTabParent]
                                    withSubnodeAtIndex:[[selectedTabParent children] indexOfObject:selectedTabItem]+1];
    } else if ([self.tabItemArray indexOfObject:selectedTabParent] < [self.tabItemArray count]-1) {
        NSInteger targetTabGroupIndex = [self.tabItemArray indexOfObject:selectedTabParent]+1;
        
        [self.tabItemsTreeController selectNodeAtIndex:targetTabGroupIndex
                                    withSubnodeAtIndex:0];
    }
}

-(void)selectBookmarksItem:(id)sender
{
    [self.tabItemsTreeController selectNodeWithIndexString:@"0:0"];
}

-(void)selectHistoryItem:(id)sender
{
    [self.tabItemsTreeController selectNodeWithIndexString:@"0:1"];
}

#pragma mark Tab Item Creation

- (IBAction)newGroup:(id)sender {
    SPTabItem *newGroupItem = [SPTabItem groupItemWithTitle:@"Group"];
    SPTabItem *child = [SPTabItem webTabItem:self
                             withWebDelegate:[self.hostDocument webViewController]
                                 forDocument:self.hostDocument];
    
    NSInteger newGroupIndex = [self.tabItemArray count];
    NSIndexPath *newGroupIndexPath = [NSIndexPath indexPathWithIndex:newGroupIndex];
    
    [newGroupItem.children addObject:child];
    
    [self.tabItemsTreeController insertObject:newGroupItem
                    atArrangedObjectIndexPath:newGroupIndexPath];
    
    [self didAddTabItem:newGroupItem toNode:nil];
}

-(void)newGroupWithTitle:(NSString *)title
{
    SPTabItem *newGroupItem = [SPTabItem groupItemWithTitle:title];
    SPTabItem *child = [SPTabItem webTabItem:self
                             withWebDelegate:[self.hostDocument webViewController]
                                 forDocument:self.hostDocument];
    
    NSInteger newGroupIndex = [self.tabItemArray count];
    NSIndexPath *newGroupIndexPath = [NSIndexPath indexPathWithIndex:newGroupIndex];
    
    [newGroupItem.children addObject:child];
    
    [self.tabItemsTreeController insertObject:newGroupItem
                    atArrangedObjectIndexPath:newGroupIndexPath];
    
    [self didAddTabItem:newGroupItem toNode:nil];
}

- (IBAction)newTabFromGroupHeader:(id)sender
{
    SPTabItem *senderTabItem = [(NSTableCellView *)[sender superview] objectValue];
    NSInteger senderIndex = [self.tabItemArray indexOfObject:senderTabItem];
    NSInteger senderChildrenCount = [senderTabItem.children count];
    NSUInteger newTabIndexes[2] = {senderIndex, senderChildrenCount};
    NSIndexPath *newTabIndexPath = [NSIndexPath indexPathWithIndexes:newTabIndexes length:2];
    
    [self newTabAtIndexPath:newTabIndexPath withURL:nil shouldSelect:YES];
}

-(NSIndexPath *)generateIndexPathForNewTab
{
    NSInteger parentIndex = 1;
    NSInteger selectedIndex = [self.tabItemArray indexOfObject:self.selectedTabItem];
    NSInteger selectedParentIndex = [self.tabItemArray indexOfObject:self.selectedTabParent];
    
    if (![self.selectedTabItem isGroupItem] && selectedParentIndex > -1 && selectedParentIndex != 0) {
        parentIndex = selectedParentIndex;
        
    } else if ([self.selectedTabItem isGroupItem] && selectedIndex != 0) {
        parentIndex = selectedIndex;
    } else if (selectedParentIndex < [self.tabItemArray count] && selectedParentIndex != 0) {
        parentIndex = selectedParentIndex;
    }
    
    NSInteger parentChildrenCount = [[[self.tabItemArray objectAtIndex:parentIndex] children] count];
    
    
    NSInteger secondIndex = 0;
    
    if (parentChildrenCount > 0 && selectedParentIndex > -1 && selectedParentIndex != 0) {
        secondIndex = [[[self.tabItemArray objectAtIndex:selectedParentIndex] children] indexOfObject:self.selectedTabItem]+1;
    } else {
        secondIndex = 0;
    }
    
    NSUInteger newTabIndexes[2] = {parentIndex, secondIndex};
    
    NSIndexPath *newTabIndexPath = [NSIndexPath indexPathWithIndexes:newTabIndexes length:2];
    
    return newTabIndexPath ? newTabIndexPath : nil;
}

-(IBAction)newTab:(id)sender
{
    [self newTabAtIndexPath:[self generateIndexPathForNewTab] withURL:nil shouldSelect:YES];
}

-(void)newTabAtIndexPath:(NSIndexPath *)indexPath withURL:(NSURL *)url shouldSelect:(BOOL)shouldSelect
{
    SPTabItem *newTabItem = [SPTabItem webTabItem:self
                                  withWebDelegate:[self.hostDocument webViewController]
                                      forDocument:self.hostDocument];
    
    [self.tabItemsTreeController insertObject:newTabItem
                    atArrangedObjectIndexPath:indexPath];
    
    if (shouldSelect == YES) {
        [self.tabItemsTreeController setSelectionIndexPath:indexPath];
    }
    
    if (url) {
        [[newTabItem.webView mainFrame] loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

-(void)newTabWithURL:(NSURL *)url
{
    [self newTabAtIndexPath:[self generateIndexPathForNewTab] withURL:url shouldSelect:YES];
}

-(SPWebView *)newTabWithURLRequest:(NSURLRequest *)urlRequest
{
    SPTabItem *newTabItem = [SPTabItem webTabItem:self
                                  withWebDelegate:[self.hostDocument webViewController]
                                      forDocument:self.hostDocument];
    NSIndexPath *newTabIndexPath = [self generateIndexPathForNewTab];
    
    [self.tabItemsTreeController insertObject:newTabItem
                    atArrangedObjectIndexPath:newTabIndexPath];
    
    [[newTabItem.webView mainFrame] loadRequest:urlRequest];
    
    [self.tabItemsTreeController setSelectionIndexPath:newTabIndexPath];
    
    return newTabItem.webView;
}

-(void)newTabFromContextMenu:(id)sender
{
    if ([sender class] == [NSMenuItem class] && [[sender representedObject] class] == [NSURL class]) {
        [self newTabWithURL:(NSURL *)[sender representedObject]];
    }
}

-(void)newBackgroundTabFromContextMenu:(id)sender
{
    if ([sender class] == [NSMenuItem class] && [[sender representedObject] class] == [NSURL class]) {
        [self newTabAtIndexPath:[self generateIndexPathForNewTab]
                        withURL:(NSURL *)[sender representedObject]
                   shouldSelect:NO];
    }
}

#pragma mark Tab Closing

-(void)closeTab:(SPTabItem *)tabItem
{
    NSIndexPath *hostIndexPath = [self.tabItemsTreeController indexPathOfObject:tabItem];
    
    [tabItem close];
    [self.tabItemsTreeController removeObjectAtArrangedObjectIndexPath:hostIndexPath];
}

- (IBAction)closeTabFromTab:(id)sender {
    NSOutlineView *senderOutlineView = (NSOutlineView *)[[[sender superview] superview] superview];
    NSInteger senderRow = [senderOutlineView rowForView:[sender superview]];
    NSTreeNode *senderTreeNode = [senderOutlineView itemAtRow:senderRow];
    SPTabItem *senderTabItem = [senderTreeNode representedObject];
    
    //   NSTreeNode *selectedNode = [self.tabItemsTreeController selectedNode];
    // NSTreeNode *closestTabNode = [[senderTreeNode parentNode] subnodeClosestToSubnode:senderTreeNode];
    
    [senderTabItem close];
    [self.tabItemsTreeController removeObjectAtArrangedObjectIndexPath:[senderTreeNode indexPath]];
}

-(void)closeSelectedTab:(id)sender
{
    NSTreeNode *selectedTreeNode = [self.tabItemsTreeController selectedNodes][0];
    
    [self.selectedTabItem close];
    
    [self.tabItemsTreeController removeObjectAtArrangedObjectIndexPath:[selectedTreeNode indexPath]];
}

#pragma mark Utility

-(NSArray *)userTabGroups
{
    if ([self.tabItemArray count] > 0) {
        return [self.tabItemArray arrayByRemovingObject:[self.tabItemArray objectAtIndex:0]];
    }
    return nil;
}

- (void)didAddTabItem:(SPTabItem *)tabItem toNode:(NSTreeNode *)parentNode
{
    NSOutlineView *mainSourceList = [self.hostDocument mainSourceList];
    if (parentNode == nil) {
        for (NSTreeNode *n in [self.tabItemsTreeController.arrangedObjects childNodes]) {
            if (n.representedObject == tabItem) {
                [mainSourceList expandItem:n];
                [mainSourceList editColumn:0
                                       row:[mainSourceList rowForItem:n]
                                 withEvent:nil
                                    select:YES];
                [self.tabItemsTreeController setSelectedNode:n.childNodes[0]];
            }
        }
    } else {
        [mainSourceList expandItem:parentNode];

    }
}

-(NSIndexPath *)indexPathForTabItem:(SPTabItem *)tabItem
{
    if ([tabItem isGroupItem]) {
        return [NSIndexPath indexPathWithIndex:[self.tabItemArray indexOfObject:tabItem]];
    } else {
        for (SPTabItem *t in self.tabItemArray) {
            if ([t.children containsObject:tabItem]) {
                NSUInteger tabIndexes[] = {[self.tabItemArray indexOfObject:t], [t.children indexOfObject:tabItem]};
                return [NSIndexPath indexPathWithIndexes:tabIndexes length:2];
            }
        }
    }
    
    return nil;
}

-(SPTabItem *)parentForTabItem:(SPTabItem *)tabItem
{
    if (![tabItem isGroupItem]) {
        for (SPTabItem *t in self.tabItemArray) {
            if ([t.children containsObject:tabItem]) {
                return t;
            }
        }
    }
    return nil;
}

-(SPTabItem *)tabItemPrecedingItem:(SPTabItem *)tabItem
{
    SPTabItem *tabItemParent = [self parentForTabItem:tabItem];
    
    if (tabItemParent) {
        NSInteger precidingTabItemIndex = [tabItemParent.children indexOfObject:tabItem]-1;
        if (precidingTabItemIndex > 0 && precidingTabItemIndex < [tabItemParent.children count]) {
            return [tabItemParent.children objectAtIndex:precidingTabItemIndex];
        }
    }
    return nil;
}

-(SPTabItem *)tabItemFollowingItem:(SPTabItem *)tabItem
{
    SPTabItem *tabItemParent = [self parentForTabItem:tabItem];
    
    if (tabItemParent) {
        NSInteger followingTabItemIndex = [tabItemParent.children indexOfObject:tabItem]+1;
        if (followingTabItemIndex > 0 && followingTabItemIndex < [tabItemParent.children count]) {
            return [tabItemParent.children objectAtIndex:followingTabItemIndex];
        }
    }
    return nil;
}

@end
