//
//  SPWebView.h
//  Sapphire
//
//  Created by John Wells on 1/29/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "SPTabItem.h"

@class SPSwipeIndicator;

@interface SPWebView : WebView <NSPageControllerDelegate>

@property (strong) SPSwipeIndicator *swipeIndicator;

@property (weak) SPTabItem *hostTabItem;


@end
