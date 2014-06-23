//
//  SPTabController.h
//  Sapphire
//
//  Created by John Wells on 1/24/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPTabItem.h"
#import "SPMainViewController.h"
#import "NSTreeController+SPAdditions.h"
#import "NSTreeNode+SPAdditions.h"
#import "SPWebView.h"

@interface SPTabController : NSObject <NSOutlineViewDelegate>

@property (weak) IBOutlet NSTreeController *tabItemsTreeController;
@property (strong) NSMutableArray *tabItemArray;
@property (readonly) NSArray *userTabGroups;
@property (weak) id hostDocument;
@property (weak) IBOutlet SPMainViewController *mainViewController;
@property (readonly) SPTabItem *selectedTabItem;
@property (readonly) SPTabItem *selectedTabParent;
@property (readonly) SPTabItem *precedingTabItem;
@property (readonly) SPTabItem *followingTabItem;

- (void)doInitialSetup;
- (IBAction)newGroup:(id)sender;
- (IBAction)newTabFromGroupHeader:(id)sender;
- (IBAction)closeTabFromTab:(id)sender;
- (IBAction)newTab:(id)sender;
- (IBAction)closeSelectedTab:(id)sender;
- (void)newGroupWithTitle:(NSString *)title;
- (void)closeTab:(SPTabItem *)tabItem;
- (void)newTabAtIndexPath:(NSIndexPath *)indexPath withURL:(NSURL *)url  shouldSelect:(BOOL)shouldSelect;
- (void)newTabWithURL:(NSURL *)url;
- (SPWebView *)newTabWithURLRequest:(NSURLRequest *)urlRequest;
- (void)newTabFromContextMenu:(id)sender;
- (void)newBackgroundTabFromContextMenu:(id)sender;
- (NSIndexPath *)indexPathForTabItem:(SPTabItem *)tabItem;
- (SPTabItem *)parentForTabItem:(SPTabItem *)tabItem;
- (SPTabItem *)tabItemPrecedingItem:(SPTabItem *)tabItem;
- (SPTabItem *)tabItemFollowingItem:(SPTabItem *)tabItem;

- (IBAction)selectPreviousTab:(id)sender;
- (IBAction)selectNextTab:(id)sender;
- (IBAction)selectBookmarksItem:(id)sender;
- (IBAction)selectHistoryItem:(id)sender;

- (void)restoreUserTabsWithArray:(NSArray *)tabArray;


@end
