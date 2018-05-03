//
//  IDRuntimeUtility.h
//  Improve Digital
//
//  Created by Андрей on 17.03.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, IDRuntimeUtilityOptions) {
    IDRuntimeUtilityOptionSurface = 0 << 1,
    IDRuntimeUtilityOptionEmbedded = 1 << 1
};

@interface IDRuntimeUtility : NSObject

+ (id)deepCopyForObject: (id)obj;
+ (id)deepCopyForObject: (id)obj assignedValuesForKeys:(NSSet <NSString *> *)keys;

@end
