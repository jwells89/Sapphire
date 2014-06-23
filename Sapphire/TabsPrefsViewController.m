//
//  TabsPrefsViewController.m
//  Sapphire
//
//  Created by John Wells on 2/3/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "TabsPrefsViewController.h"

@interface TabsPrefsViewController ()

@end

@implementation TabsPrefsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [super initWithNibName:@"TabsPrefsView" bundle:nil];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return @"TabsPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:@"webTabIconTemplate"];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Tabs", @"Toolbar item name for the Tabs preference pane");
}


@end
