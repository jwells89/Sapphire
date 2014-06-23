//Based on DHSwipeIndicator

#import "SPSwipeIndicator.h"

@implementation SPSwipeIndicator {
    NSImage  *backGlyph;
    NSImage  *forwardGlyph;
}

@synthesize webView;
@synthesize clipView;

#define kSwipeMinimumLength 0.3

- (id)initWithWebView:(SPWebView *)aWebView
{
    self = [self initWithFrame:NSMakeRect(0, 0, aWebView.frame.size.width, aWebView.frame.size.height)];
    if(self)
    {
        self.webView = aWebView;
        [self setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [self setWantsLayer:YES];
        [aWebView addSubview:self];
        id docView = [[[webView mainFrame] frameView] documentView];
        NSScrollView *scrollView = [docView enclosingScrollView];
        self.clipView = [[SPSwipeClipView alloc] initWithFrame:[[scrollView contentView] frame] webView:webView];
        [scrollView setContentView:clipView];
        [scrollView setDocumentView:docView];
        
        
        backGlyph = [NSImage imageNamed:@"backSwipe"];
        forwardGlyph = [NSImage imageNamed:@"forwardSwipe"];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    if(clipView.currentSum != 0 && clipView.isHandlingEvent)
    {
        CGFloat sum = clipView.currentSum;
        NSRect drawRect = NSZeroRect;
        CGFloat absoluteSum = fabsf(sum);
        CGFloat percent = (absoluteSum) / kSwipeMinimumLength;
        percent = (percent > 1.0) ? 1.0 : percent;
        
        CGFloat alphaPercent = (percent == 1.0) ? 1.0 : (percent <= 0.7) ? percent : 0.7f;
        if(sum < 0)
        {
            drawRect = NSMakeRect(0-(49-49*percent), self.frame.size.height/2-60, 88, 120);
            NSRect frame = NSIntegralRect(drawRect);
            
            [backGlyph drawInRect:frame
                         fromRect:NSMakeRect(0, 0, backGlyph.size.width, backGlyph.size.height)
                        operation:NSCompositeSourceOver
                         fraction:alphaPercent];
        }
        else
        {
            drawRect = NSMakeRect(self.frame.size.width-(88*percent)+1, self.frame.size.height/2-60, 88, 120);
            NSRect frame = NSIntegralRect(drawRect);
            
            [forwardGlyph drawInRect:frame
                            fromRect:NSMakeRect(0, 0, forwardGlyph.size.width, forwardGlyph.size.height)
                           operation:NSCompositeSourceOver
                            fraction:alphaPercent];
        }
    }
    else
    {
        [[[webView mainFrame] frameView] setAllowsScrolling:YES];
    }
}

- (NSView *)hitTest:(NSPoint)aPoint
{
    return nil;
}

@end
