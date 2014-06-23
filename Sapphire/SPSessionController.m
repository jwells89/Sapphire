//
//  SPSessionController.m
//  Sapphire
//
//  Created by John Wells on 5/22/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "SPSessionController.h"
#import "NSFileManager+DirectoryLocations.h"
#import "NSObject+JWSObjectAdditions.h"
#import "SPAppDelegate.h"
#import "SPDocument.h"

@implementation SPSessionController

+(void)saveSession
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *appSupportPath = [fileManager applicationSupportDirectory];
    NSString *sessionFilePath = [NSString stringWithFormat:@"%@/autosession.plist", appSupportPath];
    
    NSLog(@"Saving %@", sessionFilePath);
    
    NSArray *windowArray = [[NSDocumentController sharedDocumentController] documents];
    
 //   NSLog(@"%@", windowArray);
    
    
   [NSKeyedArchiver archiveRootObject:windowArray toFile:sessionFilePath];
}

+(void)restoreSession
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *appSupportPath = [fileManager applicationSupportDirectory];
    NSString *sessionFilePath = [NSString stringWithFormat:@"%@/autosession.plist", appSupportPath];
    
    NSMutableArray *windowArray = [NSKeyedUnarchiver unarchiveObjectWithFile:sessionFilePath];
    
    NSLog(@"Restore beginning...");
    
    NSLog(@"Restoring %lu", (unsigned long)[windowArray count]);
    
    if ([windowArray count] > 0) {
        [[NSDocumentController sharedDocumentController] restoreWindowsWithArchiveArray:windowArray];
    }
}

+(BOOL)defaultArchivedSessionExists
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *appSupportPath = [fileManager applicationSupportDirectory];
    NSString *sessionFilePath = [NSString stringWithFormat:@"%@/autosession.plist", appSupportPath];
    
    NSLog(@"Checking %@", sessionFilePath);
    
    return [fileManager fileExistsAtPath:sessionFilePath] ? YES : NO;
}

@end
