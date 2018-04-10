//
//  IDRuntimeUtility.h
//  objc.shoploan
//
//  Created by Андрей on 17.03.2018.
//  Copyright © 2018 sovcombank. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, IDRuntimeUtilityOptions) {
    IDRuntimeUtilityOptionSurface = 0 << 1,
    IDRuntimeUtilityOptionEmbedded = 1 << 1
};

@interface IDRuntimeUtility : NSObject

+ (id)deepCopyForObject: (id)obj;
+ (id)deepCopyForObject: (id)obj options: (IDRuntimeUtilityOptions)options;

@end
