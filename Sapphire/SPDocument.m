//
//  SPDocument.m
//  Sapphire
//
//  Created by John Wells on 1/20/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "SPDocument.h"
#import "SPAppDelegate.h"

@implementation SPDocument

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

#pragma mark Sessions

- (id)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self) {
        self.tabGroups = [coder decodeObjectForKey:@"tabGroups"];
        NSLog(@"tabgroups: %@", self.tabGroups);
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.tabController.userTabGroups forKey:@"tabGroups"];
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"SPDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    
    self.UUID = [NSUUID UUID];
    
    self.mainWindow.titleBarHeight = 32;
    self.mainWindow.showsTitle = NO;
    self.mainWindow.showsDocumentProxyIcon = NO;
    self.mainWindow.centerFullScreenButton = YES;
    [[self.mainWindow standardWindowButton:NSWindowDocumentIconButton] setHidden:YES];
    [[self.mainWindow standardWindowButton:NSWindowDocumentVersionsButton] setHidden:YES];
    [self.mainWindow.titleBarView addSubview:self.toolbarView];

    [self.mainSourceList setFloatsGroupRows:NO];
    
    [self.tabController setHostDocument:self];
    [self.tabController doInitialSetup];
    
    [self.mainSourceList expandItem:nil expandChildren:YES];
    [self.mainSourceList registerForDraggedTypes: [NSArray arrayWithObject: @"public.text"]];
    
    [self.downloadsTableView setDoubleAction:@selector(openSelectedDownloads)];
    [self.downloadsTableView setTarget:[[NSApp delegate] downloadsController]];
    
    
    self.appDelegate = [NSApp delegate];
    
  //  NSLog(@"%@", [[NSDocumentController sharedDocumentController] class]);
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    
    NSLog(@"%@", [self.UUID UUIDString]);
}

-(void)adjustStatusText
{
    NSInteger splitViewWidth;
    
    if (self.mainSplitView.leftPaneState == 0) {
        splitViewWidth = self.mainSourceList.frame.size.width+5;
    } else {
        splitViewWidth = 60;
    }
    [self.statusTextField setFrameOrigin:NSMakePoint(splitViewWidth, self.statusTextField.frame.origin.y)];
    [self.statusTextField setFrameSize:NSMakeSize(self.mainWindow.frame.size.width-splitViewWidth-108, self.statusTextField.frame.size.height)];

}

- (IBAction)showAddGroupPopOver:(id)sender
{
    [self.addGroupPopOver showRelativeToRect:NSZeroRect ofView:self.addGroupButton preferredEdge:NSMinYEdge];
}

- (IBAction)toggleDownloadsPopover:(id)sender
{
    if (![self.downloadsPopOver isShown]) {
        [self.downloadsPopOver showRelativeToRect:NSZeroRect ofView:sender preferredEdge:NSMaxYEdge];
    } else {
        [self.downloadsPopOver close];
    }
}

- (IBAction)showAddDownloadPane:(id)sender
{
    [self.downloadsViewController setView:self.addDownloadsView];
    [self.downloadsPopOver showRelativeToRect:NSZeroRect ofView:sender preferredEdge:NSMaxYEdge];
}

- (IBAction)hideAddDownloadPane:(id)sender
{
    [self.downloadsViewController setView:self.downloadsView];
    [self.downloadsPopOver showRelativeToRect:NSZeroRect ofView:sender preferredEdge:NSMaxYEdge];
}

+ (BOOL)autosavesInPlace
{
    return NO;
}

- (BOOL)isDocumentEdited
{
	return NO;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

-(BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    //[self.tabController newTabWithURL:url];
    
    return YES;
}

-(void)updateUIForTab:(SPTabItem *)tabItem
{
    if (tabItem == [self.tabController selectedTabItem]) {
        [self.backButton setEnabled:tabItem.canGoBack];
        [self.forwardButton setEnabled:tabItem.canGoForward];
        if ([tabItem.webView mainFrameURL]) {
            [self setFileURL:nil];
            [self.urlTitleView setAddressString: [tabItem.webView mainFrameURL]];
         //   [self.urlField setIcon: tabItem.icon];
        } else {
            [self.urlTitleView setAddressString: @""];
         //   [self.urlField setIcon: [NSImage imageNamed:@"webTabIconTemplate"]];
        }
        [self.mainWindow setTitle: tabItem.title ? tabItem.title : @"Untitled"];
        [self.urlTitleView setTitleString: tabItem.title ? tabItem.title : @"Untitled"];
        
        [self.reloadButton setImage:[tabItem.webView isLoading] ? [NSImage imageNamed:@"NSStopProgressTemplate"] : [NSImage imageNamed:@"NSRefreshTemplate"]];
        if ([self.mainWindow firstResponder] != tabItem.webView) {
            if ([tabItem.title isEqualToString:@"Untitled"]) {
                [self.urlTitleView takeFirstResponder];
            }
        }
    }
}

-(void)updateProgressBarFromTab:(SPTabItem *)tabItem
{
    if ([tabItem.webView isLoading] == YES) {
        [self.progressBar startAnimation:nil];
        if ([tabItem.webView estimatedProgress] > 0) {
            [self.progressBar setHidden:NO];
            [self.progressBar setIndeterminate:NO];
            [self.progressBar setDoubleValue:[tabItem.webView estimatedProgress]];
        } else {
            [self.progressBar setIndeterminate:YES];
        }
        
    } else {
        [self.progressBar setDoubleValue:[tabItem.webView estimatedProgress]];
        [self.progressBar stopAnimation:nil];
        [self.progressBar setHidden:YES];
    }
}

- (IBAction)addGroup:(id)sender
{
    [self.tabController newGroupWithTitle:[self.addGroupTitleField stringValue]];
    [self.addGroupTitleField setStringValue:@""];
    [self.addGroupPopOver performClose:nil];
}

-(IBAction)focusAddressField:(id)sender
{
    [self.urlTitleView takeFirstResponder];
}

#pragma mark - Dummy Methods
//These methods are necessary for NSMenuItem validation or
//for passing methods on to other parts of the application

-(void)newTab:(id)sender
{
    [self.tabController newTab:nil];
}

-(void)newGroup:(id)sender
{
    [self.tabController newGroup:nil];
}

-(void)closeSelectedTab:(id)sender
{
    [self.tabController closeSelectedTab:nil];
}

-(void)clearDownloads:(id)sender
{
    [[(SPAppDelegate *)[NSApp delegate] downloadsController] clearDownloads:nil];
}

-(void)selectPreviousTab:(id)sender
{
    [self.tabController selectPreviousTab:nil];
}

-(void)selectNextTab:(id)sender
{
    [self.tabController selectNextTab:nil];
}

-(void)selectBookmarksItem:(id)sender
{
    [self.tabController selectBookmarksItem:nil];
}

-(void)selectHistoryItem:(id)sender
{
    [self.tabController selectHistoryItem:nil];
}

@end
