//
//  GeneralPrefsViewController.h
//  Sapphire
//
//  Created by John Wells on 2/2/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPDocument.h"

@interface GeneralPrefsViewController : NSViewController

@property (weak) IBOutlet NSPopUpButton *defaultBrowsersPopup;
- (IBAction)setHomePagePreset:(id)sender;

@end
