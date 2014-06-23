//
//  SPAppDelegate.m
//  Sapphire
//
//  Created by John Wells on 1/31/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "SPAppDelegate.h"
#import "GeneralPrefsViewController.h"
#import "TabsPrefsViewController.h"
#import "AdvancedPrefsViewController.h"
#import "SPSessionController.h"

@implementation SPAppDelegate

- (id)init
{
    self = [super init];
    if (self) {
        self.documentController = [[SPDocumentController alloc] init];
        
        NSAppleEventManager *appleEventManager = [NSAppleEventManager sharedAppleEventManager];
        [appleEventManager setEventHandler:self andSelector:@selector(handleGetURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
        
        [appleEventManager setEventHandler:self andSelector:@selector(handleGetURLEvent:withReplyEvent:) forEventClass:'WWW!'
                                andEventID:'OURL'];
        
        [self setupPrefsWindow];
        self.aboutWindowController = [[SPAboutWindowController alloc] initWithWindowNibName:@"SPAboutWindow"];
        self.downloadsController = [[SPDownloadsController alloc] init];
        
        [[NSUserDefaults standardUserDefaults] addObserver:self
                                                forKeyPath:@"javaEnabled" options:NSKeyValueObservingOptionNew
                                                   context:NULL];
        [[NSUserDefaults standardUserDefaults] addObserver:self
                                                forKeyPath:@"javaScriptEnabled" options:NSKeyValueObservingOptionNew
                                                   context:NULL];
        [[NSUserDefaults standardUserDefaults] addObserver:self
                                                forKeyPath:@"plugInsEnabled" options:NSKeyValueObservingOptionNew
                                                   context:NULL];
    }
    return self;
}

-(void)dealloc
{
    [[NSUserDefaults standardUserDefaults] removeObserver:self
                                               forKeyPath:@"javaEnabled"];
    [[NSUserDefaults standardUserDefaults] removeObserver:self
                                               forKeyPath:@"javaScriptEnabled"];
    [[NSUserDefaults standardUserDefaults] removeObserver:self
                                               forKeyPath:@"plugInsEnabled"];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    if ([SPSessionController defaultArchivedSessionExists]) {
        NSLog(@"Restoring!");
        
        [self.documentController closeAllDocumentsWithDelegate:nil didCloseAllSelector:NULL contextInfo:NULL];
        [SPSessionController restoreSession];
    }
}

- (void)setupPrefsWindow
{
    NSViewController *generalViewController = [[GeneralPrefsViewController alloc] init];
    NSViewController *tabsViewController = [[TabsPrefsViewController alloc] init];
    NSViewController *advancedViewController = [[AdvancedPrefsViewController alloc] init];
    NSArray *controllers = @[[NSNull null], generalViewController, tabsViewController, advancedViewController, [NSNull null]];
    
    // To add a flexible space between General and Advanced preference panes insert [NSNull null]:
    //     NSArray *controllers = [[NSArray alloc] initWithObjects:generalViewController, [NSNull null], advancedViewController, nil];
    
    NSString *title = NSLocalizedString(@"Preferences", @"Common title for Preferences window");
    self.preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers title:title];
}

- (void)handleGetURLEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
    NSURL *sentURL = [NSURL URLWithString:[[event paramDescriptorForKeyword:keyDirectObject] stringValue]];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"openLinkRequestsInTabs"] boolValue]) {
        if ([[[NSDocumentController sharedDocumentController] documents] count] > 0) {
            [[[NSApp orderedDocuments][0] tabController] newTabWithURL:sentURL];
            
            [[[NSApp orderedDocuments][0] mainWindow] makeKeyAndOrderFront:self];
            
            //  NSLog(@"Loofa");
        } else {
            id newDoc = [[NSDocumentController sharedDocumentController] openUntitledDocumentOfType:@"DocumentType" display:YES];
            
            
            [[newDoc tabController] newTabWithURL:sentURL];
            [[newDoc mainWindow] makeKeyAndOrderFront:self];
            //    NSLog(@"Poofa");
        }
    } else {
        id newDoc = [[NSDocumentController sharedDocumentController] openUntitledDocumentOfType:@"DocumentType" display:YES];
        
        [[newDoc tabController] newTabWithURL:sentURL];
        [[newDoc mainWindow] makeKeyAndOrderFront:self];
        
        //  NSLog(@"Doofa");
    }
    
    [[NSApplication sharedApplication] activateIgnoringOtherApps : YES];
}

- (IBAction)showPreferences:(id)sender
{
    [self.preferencesWindowController showWindow:nil];
}

- (IBAction)showAbout:(id)sender {
    [self.aboutWindowController showWindow:nil];
}

-(WebPreferences *)webPrefs
{
    if (_webPrefs) {
        return _webPrefs;
    } else {
        WebPreferences *prefs = [[WebPreferences alloc] init];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [prefs setJavaEnabled:[defaults boolForKey:@"javaEnabled"]];
        [prefs setJavaScriptEnabled:[defaults boolForKey:@"javaScriptEnabled"]];
        
        _webPrefs = prefs;
        return prefs;
    }
}

-(void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)anObject
                       change:(NSDictionary *)aChange context:(void *)aContext
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [self.webPrefs setValue:[defaults valueForKey:aKeyPath] forKey:aKeyPath];
}


@end
