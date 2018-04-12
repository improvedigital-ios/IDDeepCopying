//
//  IDDeepCopyingCategories.m
//  Example
//
//  Created by Андрей on 12.04.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "IDDeepCopyingCategories.h"

@implementation NSArray (DeepCopy)

- (id)deepCopy {
    
    NSMutableArray *mutableArray = [NSMutableArray new];
    for (id object in self) {
        id copyValue = [IDRuntimeUtility deepCopyForObject:object];
        [mutableArray addObject:copyValue];
    }
    return mutableArray.copy;
}

@end

@implementation NSDictionary (DeepCopy)

- (id)deepCopy {
    
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];
    for (id key in self.allKeys) {
        mutableDictionary[key] = [IDRuntimeUtility deepCopyForObject:self[key]];
    }
    return mutableDictionary.copy;
}

@end

@implementation NSSet (DeepCopy)

- (id)deepCopy {
    
    NSMutableSet *mutableSet = [NSMutableSet new];
    for (id object in self.allObjects) {
        id copyValue = [IDRuntimeUtility deepCopyForObject:object];
        [mutableSet addObject:copyValue];
    }
    return mutableSet.copy;
}

@end


