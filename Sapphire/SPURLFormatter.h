//
//  SPURLFormatter.h
//  Sapphire
//
//  Created by John Wells on 1/26/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OmniFoundation/OmniFoundation.h>

@interface SPURLFormatter : NSObject

+(NSArray *)allowedSchemes;
+(NSURL *)URLFromString:(NSString *)urlString;

@end
