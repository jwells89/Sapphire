//
//  SPDownloadItemView.m
//  Sapphire
//
//  Created by John Wells on 3/31/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "SPDownloadItemView.h"
#import "SPDownloadItem.h"

@implementation SPDownloadItemView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

#pragma mark - Dummy Methods

-(void)toggleStatus:(id)sender
{

}

-(void)reveal:(id)sender
{
    [(SPDownloadItem *)[self objectValue] reveal:nil];
}

-(void)open:(id)sender
{
    [(SPDownloadItem *)[self objectValue] open:nil];
}

@end
