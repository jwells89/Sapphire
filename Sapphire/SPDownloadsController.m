//
//  SPDownloadsController.m
//  Sapphire
//
//  Created by John Wells on 3/30/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "SPDownloadsController.h"
#import "SPDownloadItem.h"
#import "NSFileManager+DirectoryLocations.h"

@implementation SPDownloadsController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _downloadsArray = [[NSMutableArray alloc] init];
        _downloadsArrayController = [[NSArrayController alloc] initWithContent:_downloadsArray];
        _downloadCountString = @"No Downloads";
        
        [self restoreDownloadsList];
    }
    return self;
}

-(void)awakeFromNib
{
    
}

-(void)addDownloadWithRequest:(NSURLRequest *)request
{
    SPDownloadItem *download = [SPDownloadItem initWithURLRequest:request];
    
    if (download) {
        download.delegate = self;
        [self.downloadsArrayController insertObject:download atArrangedObjectIndex:0];
        [self updateCountString];
        [self saveDownloadsList];
    }
}

-(void)toggleDownloadStatus:(id)sender
{
    if ([[sender target] class] == [SPDownloadItem class]) {
        SPDownloadItem *targetItem = (SPDownloadItem *)[sender target];
                                      
        if ([targetItem isRunning]) {
            [targetItem cancel];
        } else {
            [targetItem resume];
        }
    }
}

-(void)removeDownloadAtIndex:(NSInteger)index
{
    [self updateCountString];
}

-(void)clearDownloads:(id)sender
{
    [self.downloadsArrayController removeObjects:[self.downloadsArrayController arrangedObjects]];
    
    for (SPDownloadItem *d in [self.downloadsArrayController arrangedObjects]) {
        if (d.isRunning == NO) {
            [self.downloadsArrayController removeObject:d];
        }
    }
    
    [self saveDownloadsList];
    [self updateCountString];
}

-(void)updateCountString
{
    NSInteger downloadsCount = [self.downloadsArray count];
    
    if (downloadsCount == 0) {
        self.downloadCountString = @"No Downloads";
    } else if (downloadsCount == 1) {
        self.downloadCountString = @"1 Download";
    } else {
        self.downloadCountString = [NSString stringWithFormat:@"%ld Downloads", (long)downloadsCount];
    }
}

-(void)downloadItemDidChange
{
    [self saveDownloadsList];
}

-(void)saveDownloadsList
{
    NSString *appSupportPath = [[NSFileManager defaultManager] applicationSupportDirectory];
    NSString *downloadListFilePath = [NSString stringWithFormat:@"%@/downloads.plist", appSupportPath];
    
    //   NSLog(@"%@", downloadListFilePath);
    
    [NSKeyedArchiver archiveRootObject:self.downloadsArray toFile:downloadListFilePath];
}

-(void)restoreDownloadsList
{
    if ([self.downloadsArray count] == 0) {
        NSString *appSupportPath = [[NSFileManager defaultManager] applicationSupportDirectory];
        NSString *downloadListFilePath = [NSString stringWithFormat:@"%@/downloads.plist", appSupportPath];
        
        [self.downloadsArrayController addObjects:[NSKeyedUnarchiver unarchiveObjectWithFile:downloadListFilePath]];
        [self updateCountString];
    }
    
}

-(void)openSelectedDownloads
{
    for (SPDownloadItem *d in [self.downloadsArrayController selectedObjects]) {
        [d open:nil];
    }
}

@end
