//
//  SPAddressTitleView.m
//  Sapphire
//
//  Created by John Wells on 3/28/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "SPAddressTitleView.h"

@implementation SPAddressTitleView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
    }
    return self;
}

-(void)awakeFromNib
{
    self.addressField = [[NSTextField alloc] initWithFrame:NSMakeRect(48, self.bounds.size.height/2-11, self.bounds.size.width-96, 22)];
    [self.addressField setAutoresizingMask:NSViewWidthSizable|NSViewMinXMargin|NSViewMaxXMargin];
    [[self.addressField cell] setPlaceholderString:@"Enter an address and press enter"];
    [self.addressField setDelegate:self];
    [self.addressField setTarget:self];
    [self.addressField setAction:@selector(navigate)];

    [self.addressField setAlphaValue:0];
    
    [self addSubview:self.addressField];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    NSShadow *titleShadow = [[NSShadow alloc] init];
    [titleShadow setShadowColor:[NSColor colorWithDeviceWhite:1 alpha:.55]];
    [titleShadow setShadowOffset:NSMakeSize(0, -1)];
    [titleShadow setShadowBlurRadius:0];
    
    [titleShadow set];
    
    if ([self.titleString isNotEqualTo:@""] && [self.addressString isNotEqualTo:@""])
    {
        
        // TODO: responsive title scaling
        
        NSMutableAttributedString *combinedString = [[NSMutableAttributedString alloc] init];
        
        
        NSAttributedString *separator        = [[NSAttributedString alloc] initWithString:@" — "
                                                                               attributes:@{ NSFontAttributeName : [NSFont systemFontOfSize:13],
                                                                                             NSForegroundColorAttributeName : [NSColor colorWithDeviceRed:0.45 green:0.45 blue:0.45 alpha:1]}];
        NSAttributedString *formattedAddress = [[NSAttributedString alloc] initWithString:self.addressString
                                                                               attributes:@{ NSFontAttributeName : [NSFont systemFontOfSize:13],
                                                                                             NSForegroundColorAttributeName : [NSColor colorWithDeviceRed:0.45 green:0.45 blue:0.45 alpha:1]}];
        
        NSRect separatorBounds = [separator boundingRectWithSize:CGSizeMake(4000, CGFLOAT_MAX) options:0];
        //      NSRect titleBounds = [formattedTitle boundingRectWithSize:CGSizeMake(4000, CGFLOAT_MAX) options:0];
        NSRect domainBounds = [formattedAddress boundingRectWithSize:CGSizeMake(4000, CGFLOAT_MAX) options:0];
        
        float maxWidth = self.bounds.size.width - domainBounds.size.width - separatorBounds.size.width;
        
        NSAttributedString *formattedTitle = [[NSAttributedString alloc] initWithString:[self substringWithString:self.titleString
                                                                                                         forWidth:maxWidth]
                                                                               attributes:@{ NSFontAttributeName : [NSFont systemFontOfSize:13],
                                                                                             NSForegroundColorAttributeName : [NSColor colorWithDeviceRed:0.21 green:0.21 blue:0.21 alpha:1]}];
        
        [combinedString appendAttributedString:formattedTitle];
        [combinedString appendAttributedString:separator];
        [combinedString appendAttributedString:formattedAddress];
        
        NSRect combinedBounds = [combinedString boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX) options:0];
        float xpos = self.bounds.size.width/2 - combinedBounds.size.width/2;
        float ypos = self.bounds.size.height/2 - combinedBounds.size.height/2+1;
        NSPoint position = NSMakePoint(xpos, ypos);
        
        [combinedString drawAtPoint:position];
    }
      else if ([self.titleString isNotEqualTo:@""])
      {
          NSRect titleBounds = [self.titleString boundingRectWithSize:CGSizeMake(4000, CGFLOAT_MAX)
                                                              options:0
                                                           attributes:@{ NSFontAttributeName : [NSFont systemFontOfSize:13]}];
          float xpos = self.bounds.size.width/2 - titleBounds.size.width/2;
          float ypos = self.bounds.size.height/2 - titleBounds.size.height/2+1;
          NSPoint position = NSMakePoint(xpos, ypos);
          
          [self.titleString drawAtPoint:position withAttributes:@{ NSFontAttributeName : [NSFont systemFontOfSize:13], NSForegroundColorAttributeName : [NSColor colorWithDeviceRed:0.21 green:0.21 blue:0.21 alpha:1]}];
      }
    
    // Drawing code here.
}

-(void)navigate
{
    if ([self.addressField.stringValue isNotEqualTo:@""]) {
        [self.webViewController goToURLString:[self.addressField stringValue]];

    }
}

-(void)setAddressString:(NSString *)addressString
{
    NSURL *URL = [NSURL URLWithString:addressString];
    _addressString = [URL host];
    
    [self.addressField setStringValue:addressString];
    
    [self setNeedsDisplay:YES];
}

-(void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    
    [self setNeedsDisplay:YES];
}

-(void)viewDidMoveToWindow
{
    [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:NO];
}

-(void)mouseEntered:(NSEvent *)theEvent
{
    [[self.addressField animator] setAlphaValue:1];
}

-(void)mouseExited:(NSEvent *)theEvent
{
    if (![self isTextFieldInFocus:self.addressField]) {
        [[self.addressField animator] setAlphaValue:0];
    }
}

- (NSString *)substringWithString:(NSString *)string forWidth:(float)width
{
    // Obtain a mutable copy of this NSString.
	NSMutableString *truncatedString = [string mutableCopy];
    
	// If this NSString is longer than the desired width, truncate.
	if ([string sizeWithAttributes:@{ NSFontAttributeName : [NSFont systemFontOfSize:13]}].width > width) {
		// Subtract an ellipsis' worth of width from the desired width to obtain the
		// truncation width.
		width -= [@"…" sizeWithAttributes:@{ NSFontAttributeName : [NSFont systemFontOfSize:13]}].width;
        
		// While the string is longer than the truncation width, remove characters
		// from the end of the string.
		NSRange range = {truncatedString.length - 1, 1};
		while ([truncatedString sizeWithAttributes:@{ NSFontAttributeName : [NSFont systemFontOfSize:13]}].width > width) {
			[truncatedString deleteCharactersInRange:range];
			range.location -= 1;
		}
        
		// Once truncation is complete, append an ellipsis to the end of the string.
		[truncatedString replaceCharactersInRange:range withString:@"…"];
	}
    
	return [truncatedString copy];
}

-(void)controlTextDidBeginEditing:(NSNotification *)aNotification
{
    [[self.addressField animator] setAlphaValue:1];
}

-(void)controlTextDidEndEditing:(NSNotification *)obj
{
    if ([self isTextFieldInFocus:self.addressField]) {
        [[self.addressField animator] setAlphaValue:0];
    }
}

- (BOOL)isTextFieldInFocus:(NSTextField *)textField
{
	BOOL inFocus = NO;
	
	inFocus = ([[[textField window] firstResponder] isKindOfClass:[NSTextView class]]
			   && [[textField window] fieldEditor:NO forObject:nil]!=nil
			   && [textField isEqualTo:(id)[(NSTextView *)[[textField window] firstResponder]delegate]]);
	
	return inFocus;
}

-(void)takeFirstResponder
{
    [[self window] makeFirstResponder:self.addressField];
    [[self.addressField animator] setAlphaValue:1];
}


@end
