//
//  SPWebViewController.h
//  Sapphire
//
//  Created by John Wells on 1/26/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OmniFoundation/OmniFoundation.h>
#import <WebKit/WebKit.h>
#import "SPTabController.h"
#import "SPURLFormatter.h"
#import "SPWebView.h"
#import "NSOutlineView+SPAdditions.h"

@interface SPWebViewController : NSObject

@property (weak) IBOutlet SPTabController *tabController;
@property (readonly) WebView *selectedTabItemWebView;

- (void)goToURLString:(NSString *)urlString;
- (void)goToURL:(NSURL *)url;

- (IBAction)goToURLFromSender:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)goForward:(id)sender;
- (IBAction)reload:(id)sender;

@end
