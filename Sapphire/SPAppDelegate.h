//
//  SPAppDelegate.h
//  Sapphire
//
//  Created by John Wells on 1/31/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPDocumentController.h"
#import "SPAboutWindowController.h"
#import "MASPreferencesWindowController.h"
#import "SPDownloadsController.h"

@interface SPAppDelegate : NSObject

@property (strong) NSWindowController *preferencesWindowController;
@property (strong) SPAboutWindowController *aboutWindowController;
@property (strong) SPDocumentController *documentController;
@property (strong) SPDownloadsController *downloadsController;
@property (nonatomic) WebPreferences *webPrefs;

- (IBAction)showPreferences:(id)sender;
- (IBAction)showAbout:(id)sender;

@end
