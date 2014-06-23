//
//  SPVerticalTabViewItem.m
//  Sapphire
//
//  Created by John Wells on 1/21/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "SPTabItem.h"
#import "SPDocument.h"
#import "SPAppDelegate.h"
#import "SPWebView.h"
#import "NSURLRequest+SPURLRequestAdditions.h"

@implementation SPTabItem

- (id)init
{
    self = [super init];
    if (self) {
        self.children = [[NSMutableArray alloc] init];
        self.identifier = [[[NSUUID alloc] init] UUIDString];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self) {
        
        if ([coder containsValueForKey:@"url"]) {
            self.url = [coder decodeObjectForKey:@"url"];
        }
        
        if ([coder containsValueForKey:@"children"]) {
            self.children = [coder decodeObjectForKey:@"children"];
        }

        self.identifier = [coder decodeObjectForKey:@"identifier"];
        self.isSelected = [coder decodeBoolForKey:@"isSelected"];
        self.isGroupItem = [coder decodeBoolForKey:@"isGroupItem"];
        
        NSLog(@"Tab item restored");
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeBool:self.isSelected forKey:@"isSelected"];
    [aCoder encodeBool:self.isGroupItem forKey:@"isGroupItem"];
    
    if ([self.children count] > 0) {
        [aCoder encodeObject:self.children forKey:@"children"];
    }
    
    if (self.webView) {
        [aCoder encodeObject:[self.webView mainFrameURL] forKey:@"url"];
    }
}

-(void)dealloc
{
    if (self.isWebTab) {
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}

-(NSImage *)icon
{
    if (!_icon) {
        return [NSImage imageNamed:@"webTabIconTemplate"];
    }
    return _icon;
}

+(id)tabItemWithTitle:(NSString *)title
{
    SPTabItem *newTab = [[SPTabItem alloc] init];
    
    newTab.title = title;
    
    return newTab;
}

+(id)groupItemWithTitle:(NSString *)title
{
    SPTabItem *newTab = [self tabItemWithTitle:title];
    
    newTab.isGroupItem = YES;
    
    return newTab;
}

+(id)webTabItem
{
    SPTabItem *newTab = [self tabItemWithTitle:@"Untitled"];
    
    SPWebView *n = [[SPWebView alloc] init];
    NSView *containerView = [[NSView alloc] init];
    
    [newTab setView:containerView];
    [containerView addSubview:n];
    [n setFrameOrigin:NSMakePoint(0, 0)];
    [n setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
//    [n setPolicyDelegate:sender];
    [n setDownloadDelegate:[(SPAppDelegate *)[NSApp delegate] downloadsController]];
    
   // NSLog(@"%@", [(SPAppDelegate *)[NSApp delegate] downloadsController]);
    
    [n setMaintainsBackForwardList:YES];
    NSString *agentBase = [n userAgentForURL:[NSURL URLWithString:@"http://google.com/"]];
    NSString *agentVersion = [agentBase substringWithRange:NSMakeRange(agentBase.length-29, 9)];
    [n setCustomUserAgent:[NSString stringWithFormat:@"%@ Version/7.0.1 Safari/%@", agentBase, agentVersion]];
                           
    //@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/536.29.13 (KHTML, like Gecko) Version/6.0.4 Safari/536.29.13"
	[n setGroupName:@"SPDocument"];
    [[n backForwardList] setCapacity:15];
    [n setShouldUpdateWhileOffscreen:YES];
    [n setPreferences:[[NSApp delegate] webPrefs]];
    
    [n setHostTabItem:newTab];
    
 /*   if (url) {
        [n loadRequest:nil withURL:[NSURL URLWithString:url]];
    }*/
    
    [n addObserver:newTab forKeyPath:@"estimatedProgress" options:0 context:NULL];
    
    return newTab;
}

+(id)webTabItem:(id)sender withWebDelegate:(id)webDelegate forDocument:(id)document
{
    SPTabItem *newTab = [self webTabItem];
    
    [newTab.webView setFrameLoadDelegate:webDelegate];
    [newTab.webView setPolicyDelegate:webDelegate];
    [newTab.webView setUIDelegate:webDelegate];
    [newTab.webView setHostWindow:[(SPDocument *)document mainWindow]];
    
    return newTab;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [[[NSWorkspace sharedWorkspace] notificationCenter] postNotificationName:@"tabWebViewEstimatedProgressDidChange" object:self];
    }
}

-(id)webView
{
    if ([[self.view subviews][0] class] == [SPWebView class]) {
        return (SPWebView *)[self.view subviews][0];
    }
    
    return nil;
}

-(BOOL)isWebTab
{
    return self.webView != nil ? YES : NO;
}

-(void)close
{
    if (self.webView) {
        [self.webView close];
    }
    
}

-(BOOL)canGoBack
{
    return [self.webView canGoBack];
}

-(BOOL)canGoForward
{
    return [self.webView canGoForward];
}

@end
