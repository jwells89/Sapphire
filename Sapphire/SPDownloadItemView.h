//
//  SPDownloadItemView.h
//  Sapphire
//
//  Created by John Wells on 3/31/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SPDownloadItemView : NSTableCellView

- (IBAction)toggleStatus:(id)sender;
- (IBAction)reveal:(id)sender;
- (IBAction)open:(id)sender;

@end
