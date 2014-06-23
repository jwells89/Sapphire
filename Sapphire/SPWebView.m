//
//  SPWebView.m
//  Sapphire
//
//  Created by John Wells on 1/29/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "SPWebView.h"
#import "SPSwipeIndicator.h"

@implementation SPWebView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)viewDidMoveToWindow
{
    [super viewDidMoveToWindow];
    
    if (self.swipeIndicator == nil) {
        self.swipeIndicator = [[SPSwipeIndicator alloc] initWithWebView:self];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

-(void)pageControllerWillStartLiveTransition:(NSPageController *)pageController
{
   // [self goToBackForwardItem:(WebHistoryItem *)pageController.arrangedObjects[pageController.selectedIndex]];
}

-(void)pageController:(NSPageController *)pageController didTransitionToObject:(id)object
{
    if ([[self backForwardList] currentItem] != (WebHistoryItem *)object) {
        //[pageController setSelectedIndex:[pageController.arrangedObjects indexOfObject:object]];
        [self goToBackForwardItem:(WebHistoryItem *)object];
    }
}

-(void)pageControllerDidEndLiveTransition:(NSPageController *)pageController
{
    [pageController completeTransition];
}

@end
