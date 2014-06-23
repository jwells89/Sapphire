//
//  SPDownloadItem.m
//  Sapphire
//
//  Created by John Wells on 3/30/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "SPDownloadItem.h"

@implementation SPDownloadItem

- (id)init
{
    self = [super init];
    if (self) {
        _samples = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self.filename = [decoder decodeObjectForKey:@"filename"];
    self.destination = [decoder decodeObjectForKey:@"destination"];
    self.size = [decoder decodeDoubleForKey:@"size"];
    self.progress = [decoder decodeDoubleForKey:@"progress"];
    self.icon = [[NSWorkspace sharedWorkspace] iconForFileType:[self.filename pathExtension]];
    self.completedSuccessfully = [decoder decodeBoolForKey:@"completedSuccessfully"];
    self.isRunning = NO;
    
    if (self.completedSuccessfully == YES) {
        self.timeRemainingString = @"Complete";
        self.downloadRateString = [NSByteCountFormatter stringFromByteCount:self.size
                                       countStyle:NSByteCountFormatterCountStyleFile];
    } else {
        self.timeRemainingString = @"Interrupted";
    }
    
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.filename forKey:@"filename"];
    [encoder encodeObject:self.destination forKey:@"destination"];
    [encoder encodeDouble:self.size forKey:@"size"];
    [encoder encodeDouble:self.progress forKey:@"progress"];
    [encoder encodeBool:self.completedSuccessfully forKey:@"completedSuccessfully"];
}


+(SPDownloadItem *)initWithURLRequest:(NSURLRequest *)request
{
    SPDownloadItem *downloadItem = [[SPDownloadItem alloc] init];
    NSURLDownload *download = [[NSURLDownload alloc] initWithRequest:request delegate:downloadItem];

    if (download) {
        downloadItem.download = download;
        downloadItem.isRunning = YES;
        
        downloadItem.updateTimer = [MSWeakTimer scheduledTimerWithTimeInterval:1.0
                                                                        target:downloadItem selector:@selector(updateRate)
                                                                      userInfo:nil repeats:YES
                                                                 dispatchQueue:dispatch_get_main_queue()];
        return downloadItem;
    }
    
    return nil;
}

-(void)cancel
{
    [self.download cancel];
    self.isRunning = NO;
    [self.delegate downloadItemDidChange];
}

-(void)resume
{
    self.isRunning = YES;
}

-(void)toggleStatus:(id)sender
{
    if (self.isRunning) {
        [self cancel];
    } else {
        [self resume];
    }
}

-(void)reveal:(id)sender
{
    if (self.destination) {
        [[NSWorkspace sharedWorkspace] selectFile:self.destination inFileViewerRootedAtPath:nil];
    }
}

-(void)open:(id)sender
{
    if (self.destination) {
        [[NSWorkspace sharedWorkspace] openFile:self.destination];
    }
}

-(void)addSample:(NSUInteger)sample
{
    if ([self.samples count] == 5) {
        [self.samples removeObject:[self.samples firstObject]];
    }
    [self.samples addObject:[NSNumber numberWithInteger:sample]];
}

-(void)updateRate
{
    double total = 0.0;
    for (NSNumber *n in self.samples) {
        total = total+[n doubleValue];
    }
    
    self.downloadRate = total/[self.samples count];
    NSByteCountFormatter *byteFormatter = [[NSByteCountFormatter alloc] init];
    
    self.downloadRateString = [NSString stringWithFormat:@"%@/s", [byteFormatter stringFromByteCount:self.downloadRate]];
    
    int seconds = (self.size - self.downloaded)/self.downloadRate;
    int hours = floor(seconds /  (60 * 60) );
    float minute_divisor = seconds % (60 * 60);
    int minutes = floor(minute_divisor / 60);
    
    float seconds_divisor = seconds % 60;
    seconds = ceil(seconds_divisor);
    
    NSString *timeString;
    
    if (hours < 1) {
        timeString = [NSString stringWithFormat:@"%d sec remaining", seconds];
        if (minutes > 1) {
            timeString = [NSString stringWithFormat:@"%d min, %@", minutes, timeString];
        }
    } else {
        timeString = [NSString stringWithFormat:@"%d min remaining", minutes];
    }
    
    if (hours > 1) {
        timeString = [NSString stringWithFormat:@"%d hours, %@", hours, timeString];
    }
    
    if (seconds == 0) {
        timeString = @"Unknown";
    }
    
    self.timeRemainingString = timeString;
}

#pragma mark - NSURLDownload Delegate

-(void)download:(NSURLDownload *)download decideDestinationWithSuggestedFilename:(NSString *)filename
{
    NSURL *downloadPathURL = [[NSFileManager defaultManager] URLsForDirectory:NSDownloadsDirectory inDomains:NSUserDomainMask][0];
    NSString *downloadPath = [downloadPathURL relativePath];
    
    self.destination = [downloadPath stringByAppendingPathComponent:filename];
    [self.download setDestination:self.destination allowOverwrite:NO];
    [self setIcon:[[NSWorkspace sharedWorkspace] iconForFileType:[filename pathExtension]]];
    
    [self.delegate downloadItemDidChange];
  //  NSLog(@"%@", self.destination);
}

-(void)download:(NSURLDownload *)download didCreateDestination:(NSString *)path
{
    NSString *filename = [path lastPathComponent];
    [self setFilename:filename];
    self.destination = path;
    [self.delegate downloadItemDidChange];
}

-(void)download:(NSURLDownload *)download didReceiveResponse:(NSURLResponse *)response
{
    self.size = response.expectedContentLength;
    
    [self.delegate downloadItemDidChange];
}

-(void)download:(NSURLDownload *)download didReceiveDataOfLength:(NSUInteger)length
{
    self.downloaded = self.downloaded+length;
    [self addSample:length];
    
    if (self.size) {
        self.progress = self.downloaded/self.size;
    }
}

-(void)downloadDidBegin:(NSURLDownload *)download
{
   // NSLog(@"Download began");
}

-(void)downloadDidFinish:(NSURLDownload *)download
{
    NSUserNotification *finishNotification = [[NSUserNotification alloc] init];
    
    finishNotification.title = @"Download Finished";
    finishNotification.subtitle = self.filename;
    finishNotification.informativeText = [NSString stringWithFormat:@"%f", self.size/1024];
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:finishNotification];
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.apple.DownloadFileFinished" object:self.destination];
    
    self.timeRemainingString = @"Complete";
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.destination
                                                                                    error:nil];

    self.size = [fileAttributes fileSize];
    
    self.downloadRateString = [NSByteCountFormatter stringFromByteCount:self.size
                                                             countStyle:NSByteCountFormatterCountStyleFile];


    self.completedSuccessfully = YES;
    
    [self.updateTimer invalidate];
    
    self.isRunning = NO;
    [self.delegate downloadItemDidChange];
}

@end
