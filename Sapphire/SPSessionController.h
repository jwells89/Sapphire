//
//  SPSessionController.h
//  Sapphire
//
//  Created by John Wells on 5/22/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPSessionController : NSObject

+(void)restoreSession;
+(void)saveSession;
+(BOOL)defaultArchivedSessionExists;

@end
