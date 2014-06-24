//
//  SPURLFormatter.m
//  Sapphire
//
//  Created by John Wells on 1/26/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "SPURLFormatter.h"
#import "NSString+SPURLAdditions.h"

@implementation SPURLFormatter

+(NSArray *)allowedSchemes
{
    return @[@"http://", @"https://", @"file:///"];
}

+(NSURL *)URLFromString:(NSString *)urlString
{
    NSString *encodedURL = [urlString fullyEncodedURLString];
    
    if ([urlString isNotEqualTo:@""] && [urlString hasValidURLScheme]) {
        return [NSURL URLWithString:urlString];
    } else {
        NSString *preferredScheme = [self allowedSchemes][0];
        
        NSString *urlWithScheme = [preferredScheme stringByAppendingString:encodedURL];
        
        return [NSURL URLWithString:urlWithScheme];
    }
    
    return nil;
}

@end
