//
//  NSIndexPath+JWSIndexPathAdditions.h
//  JWSTreeControllerDemo
//
//  Created by John Wells on 4/11/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (JWSIndexPathAdditions)

@property (readonly) NSArray *pathIndexes;
@property (readonly) NSString *stringRepresentation;

+(id)indexPathWithString:(NSString *)stringRepresentation;
-(id)initWithStringRepresentation:(NSString *)stringRepresentation;

@end
