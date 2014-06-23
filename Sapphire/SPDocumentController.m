//
//  SPDocumentController.m
//  Sapphire
//
//  Created by John Wells on 1/31/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "SPDocumentController.h"

@implementation SPDocumentController

-(void)newDocument:(id)sender
{
    [super newDocument:sender];
    
}

-(id)openUntitledDocumentAndDisplay:(BOOL)displayDocument error:(NSError *__autoreleasing *)outError
{
    SPDocument *newDocument = [super openUntitledDocumentAndDisplay:displayDocument error:outError];
    
    [newDocument newTab:nil];
    
    return newDocument;
}

-(void)newDocument:(id)sender withURL:(NSURL *)url
{
    SPDocument *newDocument = [[SPDocument alloc] init];
    
    [self addDocument:newDocument];
    [newDocument.tabController newTabWithURL:url];
    
    [newDocument makeWindowControllers];
    [newDocument showWindows];
}

-(SPWebView *)newDocument:(id)sender withURLRequest:(NSURLRequest *)urlRequest
{
    SPDocument *newDocument = [super openUntitledDocumentAndDisplay:YES error:nil];
    [newDocument.tabController newTabWithURLRequest:urlRequest];
    
    return (SPWebView *)newDocument.webViewController.selectedTabItemWebView;
}

-(void)restoreWindowsWithArchiveArray:(NSArray *)archivedWindows
{
    NSLog(@"Array: %@", archivedWindows);
    for (SPDocument *d in archivedWindows) {
        [self addDocument:d];
        
        NSLog(@"%@", d.tabController);
        [d.tabController restoreUserTabsWithArray:d.tabGroups];
        
        [d makeWindowControllers];
        [d showWindows];
    }
}

@end
