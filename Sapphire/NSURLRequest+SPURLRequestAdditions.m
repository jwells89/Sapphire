//
//  NSURLRequest+SPURLRequestAdditions.m
//  Sapphire
//
//  Created by John Wells on 5/22/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "NSURLRequest+SPURLRequestAdditions.h"

@implementation NSURLRequest (SPURLRequestAdditions)

+(id)requestWithURLString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    return [NSURLRequest requestWithURL:url];
}

@end
