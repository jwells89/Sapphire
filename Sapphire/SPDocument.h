//
//  SPDocument.h
//  Sapphire
//
//  Created by John Wells on 1/20/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "SPWebView.h"
#import "INAppStoreWindow.h"
#import "SPTabController.h"
#import "SPWebViewController.h"
#import "SPTabItem.h"
#import "SPSplitView.h"
#import "SPAddressTitleView.h"

@interface SPDocument : NSDocument

@property (weak) IBOutlet id appDelegate;
@property (weak) IBOutlet INAppStoreWindow *mainWindow;
@property (strong) IBOutlet NSView *toolbarView;
@property (weak) IBOutlet SPSplitView *mainSplitView;
@property (strong) IBOutlet SPTabController *tabController;
@property (strong) IBOutlet SPWebViewController *webViewController;
@property (strong) IBOutlet NSPopover *addGroupPopOver;
@property (weak) IBOutlet NSTextField *addGroupTitleField;
@property (weak) IBOutlet NSButton *addGroupButton;
@property (weak) IBOutlet NSOutlineView *mainSourceList;
@property (weak) IBOutlet SPAddressTitleView *urlTitleView;
@property (weak) IBOutlet NSTextField *urlField;
@property (weak) IBOutlet NSButton *backButton;
@property (weak) IBOutlet NSButton *forwardButton;
@property (weak) IBOutlet NSButton *reloadButton;
@property (weak) IBOutlet NSTextField *statusTextField;
@property (weak) IBOutlet NSProgressIndicator *progressBar;
@property (strong) IBOutlet NSViewController *downloadsViewController;
@property (strong) IBOutlet NSPopover *downloadsPopOver;
@property (strong) IBOutlet NSView *addDownloadsView;
@property (strong) IBOutlet NSView *downloadsView;
@property (weak) IBOutlet NSTableView *downloadsTableView;
@property (strong) NSUUID *UUID;

@property (strong) NSArray *tabGroups;


-(void)updateUIForTab:(SPTabItem *)tabItem;
-(void)updateProgressBarFromTab:(SPTabItem *)tabItem;
-(IBAction)addGroup:(id)sender;
-(IBAction)newTab:(id)sender;
-(IBAction)newGroup:(id)sender;
-(IBAction)closeSelectedTab:(id)sender;
-(IBAction)focusAddressField:(id)sender;
-(void)adjustStatusText;
- (IBAction)showAddGroupPopOver:(id)sender;
- (IBAction)toggleDownloadsPopover:(id)sender;
- (IBAction)showAddDownloadPane:(id)sender;
- (IBAction)hideAddDownloadPane:(id)sender;
- (IBAction)clearDownloads:(id)sender;
- (IBAction)selectPreviousTab:(id)sender;
- (IBAction)selectNextTab:(id)sender;
- (IBAction)selectBookmarksItem:(id)sender;
- (IBAction)selectHistoryItem:(id)sender;

@end
