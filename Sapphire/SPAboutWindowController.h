//
//  SPAboutWindowController.h
//  Sapphire
//
//  Created by John Wells on 2/3/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SPAboutWindowController : NSWindowController


@property (weak) IBOutlet NSTextField *versionField;
@property (strong) IBOutlet NSPopover *acknowledgementsPopover;
@property (unsafe_unretained) IBOutlet NSTextView *acknowledgementsTextView;


- (IBAction)showAcknowledgementsPopover:(id)sender;

@end
