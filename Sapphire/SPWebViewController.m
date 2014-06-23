//
//  SPWebViewController.m
//  Sapphire
//
//  Created by John Wells on 1/26/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "SPWebViewController.h"
#import "SPDocumentController.h"
#import "SPSessionController.h"
#import "SPDocument.h"
#import "SPAppDelegate.h"

@implementation SPWebViewController

- (id)init
{
    self = [super init];
    if (self) {
        [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(webViewProgressEstimateChanged:) name:@"tabWebViewEstimatedProgressDidChange" object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self name:@"tabWebViewEstimatedProgressDidChange" object:nil];
}

-(void)goToURLFromSender:(id)sender
{
    if ([[sender stringValue] isNotEqualTo:@""] && self.selectedTabItemWebView != nil) {
        NSURL *senderURL = [SPURLFormatter URLFromString:[sender stringValue]];
        [self goToURL:senderURL];
    }
}

-(void)goToURLString:(NSString *)urlString
{
    if ([urlString isNotEqualTo:@""] && self.selectedTabItemWebView != nil) {
        NSURL *senderURL = [SPURLFormatter URLFromString:urlString];
        [self goToURL:senderURL];
    }
}

-(void)goToURL:(NSURL *)url
{
    if ([url isNotEqualTo:@""] && self.selectedTabItemWebView != nil) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [[self.selectedTabItemWebView mainFrame] loadRequest:request];
        [[self.selectedTabItemWebView hostWindow] makeFirstResponder:self.selectedTabItemWebView];
    }
}

- (IBAction)goBack:(id)sender {
    [self.selectedTabItemWebView goBack:nil];
}

- (IBAction)goForward:(id)sender {
    [self.selectedTabItemWebView goForward:nil];
}

- (IBAction)reload:(id)sender {
    [self.selectedTabItemWebView isLoading] ? [self.selectedTabItemWebView stopLoading:nil] : [self.selectedTabItemWebView reload:nil];
}

-(WebView *)selectedTabItemWebView
{
    return [[self.tabController selectedTabItem] webView];
}

-(void)webViewClose:(SPWebView *)sender
{
    [self.tabController closeTab:sender.hostTabItem];
}

-(void)webView:(WebView *)sender setFrame:(NSRect)frame
{
    
}

-(void)webView:(SPWebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame
{
    if (frame == [sender mainFrame]) {
        [[sender hostTabItem] setTitle:title];
        [self.tabController.hostDocument updateUIForTab:sender.hostTabItem];
    }
}

-(void)webView:(SPWebView *)sender didReceiveIcon:(NSImage *)image forFrame:(WebFrame *)frame
{
    if (frame == [sender mainFrame]) {
        [[sender hostTabItem] setIcon:image];
        [self.tabController.hostDocument updateUIForTab:sender.hostTabItem];
    }
}

-(void)webView:(SPWebView *)sender didCommitLoadForFrame:(WebFrame *)frame
{
    if (frame == [sender mainFrame] && sender == self.selectedTabItemWebView) {
        [self.tabController.hostDocument updateUIForTab:sender.hostTabItem];
    }
}

-(void)webView:(SPWebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
    if (frame == [sender mainFrame] && sender == self.selectedTabItemWebView) {
        [self.tabController.hostDocument updateUIForTab:sender.hostTabItem];
        [self.tabController.hostDocument updateProgressBarFromTab:self.tabController.selectedTabItem];
    }
}


-(void)webView:(SPWebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    if (frame == [sender mainFrame]) {
        if (sender == self.selectedTabItemWebView) {
            [self.tabController.hostDocument updateUIForTab:sender.hostTabItem];
            [SPSessionController saveSession];
        }
    }
}

-(WebView *)webView:(WebView *)sender createWebViewWithRequest:(NSURLRequest *)request
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"openWindowRequestsInTabs"] boolValue]) {
        return [self.tabController newTabWithURLRequest:request];
    } else {
        return [[NSDocumentController sharedDocumentController] newDocument:self withURLRequest:request];
    }
    return nil;
}

- (void)webViewProgressEstimateChanged:(NSNotification *)notification
{
    if ([notification object] == self.tabController.selectedTabItem) {
        [self.tabController.hostDocument updateProgressBarFromTab:self.tabController.selectedTabItem];
    }
}

- (NSArray *) webView: (WebView *) sender contextMenuItemsForElement: (NSDictionary *) element defaultMenuItems: (NSArray *) defaultMenuItems {
	// 
    
	NSMutableArray *modifiedMenuItems = [defaultMenuItems mutableCopy];
	NSMenuItem *mItem;
    NSMenuItem *mItemTwo;
	NSURL *linkURL = element[WebElementLinkURLKey];
    
	/*for (NSString *s in [element allKeys])
     {
     NSLog(s);
     }*/
	
	if (linkURL) {
		mItem = [[NSMenuItem alloc] init];
		[mItem setTitle: @"Open Link in New Tab"];
		[mItem setTarget: self.tabController];
		[mItem setRepresentedObject:linkURL];
		[mItem setAction: @selector(newTabFromContextMenu:)];
        
        mItemTwo = [[NSMenuItem alloc] init];
		[mItemTwo setTitle: @"Open Link in Background Tab"];
		[mItemTwo setTarget: self.tabController];
		[mItemTwo setRepresentedObject:linkURL];
		[mItemTwo setAction: @selector(newBackgroundTabFromContextMenu:)];
        
        
        NSMenuItem *tabInGroupItem = [[NSMenuItem alloc] init];
        NSMenu *tabInGroupMenu = [[NSMenu alloc] init];
        [tabInGroupItem setSubmenu:tabInGroupMenu];
		[tabInGroupItem setTitle: @"Open Link in Group"];
        
        //    [tabInGroupMenu addItem:[NSMenuItem separatorItem]];
        
        //	[tabInGroupItem setAction: @selector(newBackgroundTab:withURL:)];
        
        //[modifiedMenuItems insertObject:mItem atIndex:1];
        
        for (SPTabItem *i in [self.tabController tabItemArray]) {
            if ([[i title] isNotEqualTo:@"PERSONAL"]) {
                NSMenuItem *n = [[NSMenuItem alloc] init];
                
                NSDictionary *info = [NSDictionary dictionaryWithObjects:@[linkURL, i] forKeys:@[@"url", @"tabGroup"]];
                
                [n setTitle:i.title];
                [n setRepresentedObject:info];
                [n setTarget:self];
       //         [n setAction:@selector(openTabInGroupFromMenu:)];
                
                if (![[tabInGroupMenu itemArray] containsObject:n]) {
                    [tabInGroupMenu addItem:n];
                }
            }
        }
        
        NSMenuItem *newGroupItem = [[NSMenuItem alloc] init];
        [newGroupItem setTitle:@"New Group..."];
        [tabInGroupMenu addItem:[NSMenuItem separatorItem]];
        [tabInGroupMenu addItem:newGroupItem];
        
        [modifiedMenuItems insertObjects:@[mItem, mItemTwo, tabInGroupItem] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 3)]];
        
        
        
        
        NSMenuItem *mItemThree = [[NSMenuItem alloc] init];
		[mItemThree setTitle: @"Preview Link"];
		[mItemThree setTarget: self];
		[mItemThree setRepresentedObject:linkURL];
	//	[mItemThree setAction: @selector(previewLink:withURL:)];
        
        [modifiedMenuItems insertObjects:@[[NSMenuItem separatorItem], mItemThree] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(5, 2)]];
        
        NSMenuItem *newWindowItem = modifiedMenuItems[4];
        [newWindowItem setRepresentedObject:linkURL];
    //    [newWindowItem setAction:@selector(newWindow:withURL:)];
        
	}
	//[ mItem release ]; 
    
	return (modifiedMenuItems);
}

-(void)webView:(WebView *)sender mouseDidMoveOverElement:(NSDictionary *)elementInformation modifierFlags:(NSUInteger)modifierFlags
{
    NSString *linkTarget = elementInformation[WebElementLinkTargetFrameKey];
	NSString *linkURL = elementInformation[WebElementLinkURLKey];
    
    if (linkURL && !linkTarget) {
        [[self.tabController.hostDocument statusTextField] setStringValue:[NSString stringWithFormat:@"Go to %@ in a new window",linkURL]];
    } else if (linkURL) {
        [[self.tabController.hostDocument statusTextField] setStringValue:[NSString stringWithFormat:@"Go to %@",linkURL]];
    } else {
        [[self.tabController.hostDocument statusTextField] setStringValue:@""];
    }
}

-(BOOL)webView:(SPWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame
{
    NSAlert *alert = [NSAlert alertWithMessageText:sender.mainFrameTitle
                                     defaultButton:@"OK"
                                   alternateButton:@"Cancel"
                                       otherButton:nil
                         informativeTextWithFormat:@"%@", message];
    
    [alert setIcon:sender.mainFrameIcon];
    [alert setAlertStyle:NSCriticalAlertStyle];
    
    NSInteger result = [alert runModal];

    
    
    return NSAlertDefaultReturn == result;
    
}


- (void)webView:(SPWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame
{
    NSAlert *alert = [NSAlert alertWithMessageText:sender.mainFrameTitle
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@"%@", message];
    
    [alert setIcon:sender.mainFrameIcon];
    
  //  [alert runAsPopoverForView:senderCell preferredEdge:NSMaxYEdge withCompletionBlock:^(NSInteger result) {
    //    NSLog(@"foo");
   // }];
   [alert runModal];
}

- (void) webView:(WebView *)sender runOpenPanelForFileButtonWithResultListener:(id<WebOpenPanelResultListener>)resultListener
{
    NSOpenPanel *panel = [[NSOpenPanel alloc] init];
    [panel setAllowsMultipleSelection:NO];
    
    [panel beginSheetModalForWindow:[sender window] completionHandler:^(NSInteger returnCode)
     {
         if (returnCode != NSOKButton)
             [resultListener cancel];
         else {
             [resultListener chooseFilename:[[panel URL] relativeString]];
         }}];
    // [panel beginSheetForDirectory:NSHomeDirectory() file:nil types:nil modalForWindow:[sender window]
    //               modalDelegate:self didEndSelector:@selector(openPanelEnded:code:context:) contextInfo:resultListener];
    
}

- (void)webView:(WebView *)sender runOpenPanelForFileButtonWithResultListener:(id<WebOpenPanelResultListener>)resultListener allowMultipleFiles:(BOOL)allowMultipleFiles
{
    NSOpenPanel *panel = [[NSOpenPanel alloc] init];
    [panel setAllowsMultipleSelection:YES];
    
    [panel beginSheetModalForWindow:[sender window] completionHandler:^(NSInteger returnCode)
     {
         if (returnCode != NSOKButton)
             [resultListener cancel];
         else {
             NSArray *selectedFiles = [[panel URLs] valueForKey: @"relativePath"];
             [resultListener chooseFilenames: selectedFiles];
         }}];
    //[panel beginSheetForDirectory:NSHomeDirectory() file:nil types:nil modalForWindow:[sender window]
    //                modalDelegate:self didEndSelector:@selector(openPanelEnded:code:context:) contextInfo:resultListener];
    
}


- (void)webView:(WebView *)sender decidePolicyForMIMEType:(NSString *)type request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener
{
	if ([[sender class] canShowMIMEType:type]) // Why sender class.  In case this is actually a WebView subclass that can show extra mime types
	{
		// This is a type of file that the webview says it can show.  Let it
		[listener use];
	}
	else
	{
		// Download that!
		//[listener download];
        [listener ignore];
        [[(SPAppDelegate *)[NSApp delegate] downloadsController] addDownloadWithRequest:request];
        NSLog(@"%@", request);
	}
}

@end
