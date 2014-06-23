//
//  SPDownloadsController.h
//  Sapphire
//
//  Created by John Wells on 3/30/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "SPDownloadItemDelegate.h"

@interface SPDownloadsController : NSObject <SPDownloadItemDelegate>

@property (strong) NSMutableArray *downloadsArray;
@property (strong) NSArrayController *downloadsArrayController;
@property (strong) NSString          *downloadCountString;

- (void)addDownloadWithRequest:(NSURLRequest *)request;
- (IBAction)toggleDownloadStatus:(id)sender;
- (void)removeDownloadAtIndex:(NSInteger)index;
- (IBAction)clearDownloads:(id)sender;
- (void)openSelectedDownloads;

@end
