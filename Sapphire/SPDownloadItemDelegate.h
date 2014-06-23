//
//  SPDownloadItemDelegate.h
//  Sapphire
//
//  Created by John Wells on 3/31/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SPDownloadItemDelegate <NSObject>

@required
-(void)downloadItemDidChange;

@end
