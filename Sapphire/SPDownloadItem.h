//
//  SPDownloadItem.h
//  Sapphire
//
//  Created by John Wells on 3/30/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPDownloadItemDelegate.h"
#import "MSWeakTimer.h"

@interface SPDownloadItem : NSObject <NSURLDownloadDelegate>

@property (strong) MSWeakTimer *updateTimer;
@property (strong) NSURLDownload *download;
@property (strong) NSString *filename;
@property (strong) NSString *destination;
@property (strong) NSImage  *icon;
@property (strong) NSMutableArray *samples;
@property (strong) NSString *downloadRateString;
@property (strong) NSString *timeRemainingString;
@property (weak) id<SPDownloadItemDelegate> delegate;
@property double size;
@property double downloaded;
@property double downloadRate;
@property double progress;
@property BOOL isRunning;
@property BOOL completedSuccessfully;

+(SPDownloadItem *)initWithURLRequest:(NSURLRequest *)request;

-(IBAction)toggleStatus:(id)sender;
-(IBAction)reveal:(id)sender;
-(IBAction)open:(id)sender;
-(void)cancel;
-(void)resume;

@end
