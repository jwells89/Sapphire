//
//  SPAddressTitleView.h
//  Sapphire
//
//  Created by John Wells on 3/28/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPWebViewController.h"

@interface SPAddressTitleView : NSView <NSTextFieldDelegate>

@property (strong) NSTextField *addressField;

@property (nonatomic) NSString *addressString;
@property (nonatomic) NSString *titleString;
@property (readonly) NSString *stringValue;

@property (nonatomic) IBOutlet SPWebViewController *webViewController;
@property (nonatomic) SEL action;

-(void)takeFirstResponder;

@end
