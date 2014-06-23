#import <Cocoa/Cocoa.h>
#import "SPWebView.h"
#import "SPSwipeClipView.h"

@interface SPSwipeIndicator : NSView {
    SPWebView *webView;
    SPSwipeClipView *clipView;
}

@property (retain) SPWebView *webView;
@property (retain) SPSwipeClipView *clipView;

- (id)initWithWebView:(SPWebView *)aWebView;

@end
