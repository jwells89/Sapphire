//
//  SPVerticalTabViewItem.h
//  Sapphire
//
//  Created by John Wells on 1/21/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

enum SPTabType {
    SPTabItemType = 0,
    SPTabGroupType = 1
    };

@interface SPTabItem : NSObject <NSCoding, NSPasteboardWriting, NSPasteboardReading>

@property (strong) NSView *view;
@property (readonly) id webView;
@property (strong) NSString *identifier;
@property (strong) NSString *title;
@property (nonatomic, strong) NSImage *icon;
@property (strong) NSMutableArray *children;
@property (strong) NSURL *url;
@property BOOL isSelected;
@property BOOL isGroupItem;
@property BOOL isStatic;
@property (readonly) BOOL isWebTab;
@property (readonly) BOOL canGoBack;
@property (readonly) BOOL canGoForward;

+(id)tabItemWithTitle:(NSString *)title;
+(id)groupItemWithTitle:(NSString *)title;
+(id)webTabItem;
+(id)webTabItem:(id)sender withWebDelegate:(id)webDelegate forDocument:(id)document;

-(void)close;

@end
