//
//  NSIndexPath+JWSIndexPathAdditions.m
//  JWSTreeControllerDemo
//
//  Created by John Wells on 4/11/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "NSIndexPath+JWSIndexPathAdditions.h"

@implementation NSIndexPath (JWSIndexPathAdditions)

+(id)indexPathWithString:(NSString *)stringRepresentation
{
    return [[self alloc] initWithStringRepresentation:stringRepresentation];
}

-(id)initWithStringRepresentation:(NSString *)stringRepresentation
{
    NSArray *pathParts = [stringRepresentation componentsSeparatedByString:@":"];
    NSIndexPath *indexPath = [[NSIndexPath alloc] init];
    
    for (NSString *p in pathParts) {
        indexPath = [indexPath indexPathByAddingIndex:[p integerValue]];
    }
    
    return indexPath;
}

-(NSString *)stringRepresentation
{
    return [[self pathIndexes] componentsJoinedByString:@":"];
}

-(NSArray *)pathIndexes
{
    NSMutableArray *pathIndexes = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < [self length]; i++) {
        NSInteger index = [self indexAtPosition:i];
        NSNumber *n = [NSNumber numberWithInteger:index];
        
        [pathIndexes addObject:n];
    }
    
    return [NSArray arrayWithArray:pathIndexes];
}

@end
