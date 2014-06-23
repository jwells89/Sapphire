//
//  SPDocumentController.h
//  Sapphire
//
//  Created by John Wells on 1/31/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPDocument.h"
#import "SPWebView.h"

@interface SPDocumentController : NSDocumentController

-(void)newDocument:(id)sender withURL:(NSURL *)url;
-(SPWebView *)newDocument:(id)sender withURLRequest:(NSURLRequest *)urlRequest;
-(void)restoreWindowsWithArchiveArray:(NSArray *)archivedWindows;

@end
