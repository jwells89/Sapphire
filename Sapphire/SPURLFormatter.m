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
    return @[@"http://", @"https://"];
}

+(NSURL *)URLFromString:(NSString *)urlString
{
    if ([urlString isNotEqualTo:@""] && [urlString hasValidURLScheme]) {
        return [NSURL URLWithString:[urlString fullyEncodeAsIURIReference]];
    } else {
        NSString *prefferedScheme = [self allowedSchemes][0];
        NSString *compositeString = [prefferedScheme stringByAppendingString:urlString];
        
        return [NSURL URLWithString:[compositeString fullyEncodeAsIURIReference]];
    }
    return nil;
}

@end
