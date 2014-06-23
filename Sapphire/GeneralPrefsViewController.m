//
//  GeneralPrefsViewController.m
//  Sapphire
//
//  Created by John Wells on 2/2/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "GeneralPrefsViewController.h"

@interface GeneralPrefsViewController ()

@end

@implementation GeneralPrefsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [super initWithNibName:@"GeneralPrefsView" bundle:nil];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return @"GeneralPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"General", @"Toolbar item name for the General preference pane");
}

- (NSArray *)applicationsForURL:(NSURL *)url {
    NSArray *browserArray = CFBridgingRelease(LSCopyApplicationURLsForURL((__bridge CFURLRef)url,
                                                                          kLSRolesViewer));
    return browserArray;
}

-(void)awakeFromNib
{
    [self populateDefaultBrowserMenu];
}

- (void)populateDefaultBrowserMenu
{
    if ([[[_defaultBrowsersPopup menu] itemArray] count] == 1) {
        NSArray *browserURLs =  [self applicationsForURL:[NSURL URLWithString:@"http://www.google.com/"]];
        NSMutableArray *browsers = [[NSMutableArray alloc] init];
        
        
        for (NSURL *u in browserURLs)
        {
            NSDictionary *info = [[NSBundle bundleWithPath:[u relativePath]] infoDictionary];
            NSString *name = [[NSFileManager defaultManager] displayNameAtPath: [u relativePath]];
            NSString *nameWithVersion = [NSString stringWithFormat:@"%@ (%@)", name, info[@"CFBundleShortVersionString"]];
            NSString *identifier = info[@"CFBundleIdentifier"];
            NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile: [u relativePath]];
            [icon setSize:NSMakeSize(16, 16)];
            
            NSDictionary *browser = @{@"name": nameWithVersion, @"identifier": identifier, @"icon": icon};
            
            [browsers addObject:browser];
        }
        
        NSSortDescriptor *browserSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
        
        NSArray *sortedBrowsers = [browsers sortedArrayUsingDescriptors:@[browserSort]];

        
        for (NSDictionary *d in sortedBrowsers) {
            NSMenuItem *menuItem = [[NSMenuItem alloc] init];
            [menuItem setImage:[d valueForKey:@"icon"]];
            [menuItem setTitle:[d valueForKey:@"name"]];
            [menuItem setRepresentedObject:[d valueForKey:@"identifier"]];
            [menuItem setAction:@selector(setDefaultBrowserFromPopup:)];
            [menuItem setTarget:self];
            
            [[_defaultBrowsersPopup menu] addItem:menuItem];
        }
        
    }
    
    NSURL *dummyURL = [NSURL URLWithString:@"http://www.google.com/"];
    CFURLRef browserPath = NULL;
    LSGetApplicationForURL((__bridge CFURLRef)dummyURL, kLSRolesAll, NULL, &browserPath);
    
    NSDictionary *defaultInfo = [[NSBundle bundleWithPath:[(__bridge NSURL *)browserPath relativePath]] infoDictionary];
    NSString *defaultIdentifier = defaultInfo[@"CFBundleIdentifier"];
    NSDictionary *selfInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *selfIdentifier = selfInfo[@"CFBundleIdentifier"];

    
    for (NSMenuItem *i in [_defaultBrowsersPopup itemArray])
    {
        if ([i representedObject] == selfIdentifier)
        {
            NSMenuItem *selfItem = i;
            [[_defaultBrowsersPopup menu] removeItem:i];
            [[_defaultBrowsersPopup menu] insertItem:selfItem atIndex:0];
        }
        
        if ([i representedObject] == defaultIdentifier)
        {
            [_defaultBrowsersPopup selectItem:i];
        }
    }
    
}


- (void)setDefaultBrowserFromPopup:(id)sender
{
    NSString *bundleID = [sender representedObject];
    LSSetDefaultHandlerForURLScheme(CFSTR("http"), (__bridge CFStringRef)bundleID);
    LSSetDefaultHandlerForURLScheme(CFSTR("https"), (__bridge CFStringRef)bundleID);
}

- (IBAction)setHomePagePreset:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *frontmostPage = [[[[NSApp orderedDocuments][0] webViewController] selectedTabItemWebView] mainFrameURL];
    
    NSLog(@"%ld", (long)[sender indexOfSelectedItem]);
    
    switch ([sender indexOfSelectedItem]) {
        case 1:
            [defaults setValue:@"about:blank" forKey:@"homePage"];
            break;
            
        case 2:
            [defaults setValue:@"about:home" forKey:@"homePage"];
            break;
            
        case 3:
            if (frontmostPage) {
                [defaults setValue:frontmostPage forKey:@"homePage"];
            }
            
            break;
            
        default:
            break;
    }
}

@end
