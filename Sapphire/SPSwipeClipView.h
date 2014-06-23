#import <Cocoa/Cocoa.h>
#import "SPWebView.h"

@interface SPSwipeClipView : NSClipView {
    CGFloat currentSum;
    NSTimer *drawTimer;
    BOOL canGoLeft;
    BOOL canGoRight;
    SPWebView *webView;
    BOOL isHandlingEvent;
    BOOL _haveAdditionalClip;
    NSRect _additionalClip;
    CGFloat scrollDeltaX;
    CGFloat scrollDeltaY;
}

@property (retain) NSTimer *drawTimer;
@property (assign) CGFloat currentSum;
@property (retain) SPWebView *webView;
@property (assign) BOOL isHandlingEvent;

- (id)initWithFrame:(NSRect)frame webView:(SPWebView *)aWebView;

@end
