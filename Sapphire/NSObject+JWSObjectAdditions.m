//
//  NSObject+JWSObjectAdditions.m
//  JWSTreeControllerDemo
//
//  Created by John Wells on 4/11/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "NSObject+JWSObjectAdditions.h"

@implementation NSObject (JWSObjectAdditions)

-(BOOL)hasChildren
{
    if ([self respondsToSelector:@selector(count)]) {
        return YES;
    }
    
    return NO;
}

@end
