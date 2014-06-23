//
//  SPOutlineView.h
//  Sapphire
//
//  Created by John Wells on 2/4/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPTableCellView.h"

@interface SPOutlineView : NSOutlineView

@property NSInteger lastHoverRow;
@property NSInteger hoverRow;
@property BOOL hovering;

@end
