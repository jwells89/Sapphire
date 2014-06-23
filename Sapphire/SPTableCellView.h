//
//  SPTableCellView.h
//  Sapphire
//
//  Created by John Wells on 1/26/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPTabItem.h"

@interface SPTableCellView : NSTableCellView

@property (weak) IBOutlet NSButton *accessoryButton;
@property (nonatomic) BOOL shouldShowAccessoryButton;
@property BOOL setShowsCloseButton;

@end
