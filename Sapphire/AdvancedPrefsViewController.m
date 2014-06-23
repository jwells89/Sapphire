//
//  AdvancedPrefsViewController.m
//  Sapphire
//
//  Created by John Wells on 4/3/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "AdvancedPrefsViewController.h"

@interface AdvancedPrefsViewController ()

@end

@implementation AdvancedPrefsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [super initWithNibName:@"AdvancedPrefsView" bundle:nil];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return @"AdvancedPreferences";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:@"NSAdvanced"];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Advanced", @"Toolbar item name for the Advanced preference pane");
}

@end
