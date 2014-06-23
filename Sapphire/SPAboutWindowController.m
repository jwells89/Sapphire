//
//  SPAboutWindowController.m
//  Sapphire
//
//  Created by John Wells on 2/3/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "SPAboutWindowController.h"

@interface SPAboutWindowController ()

@end

@implementation SPAboutWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* versionNum = [infoDict objectForKey:@"CFBundleShortVersionString"];
    NSString* buildNum = [infoDict objectForKey:@"CFBundleVersion"];
    
    [self.versionField setStringValue:[NSString stringWithFormat:@"Version %@ (%@)", versionNum, buildNum]];
    
    NSData *creditsRTF = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Credits" ofType:@"rtf"]];
    NSAttributedString *creditsRTFString = [[NSAttributedString alloc] initWithRTF:creditsRTF documentAttributes:nil];
    [[self.acknowledgementsTextView textStorage] setAttributedString:creditsRTFString];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)showAcknowledgementsPopover:(id)sender {
    [self.acknowledgementsPopover showRelativeToRect:NSZeroRect ofView:sender preferredEdge:NSMaxYEdge];
}

@end
