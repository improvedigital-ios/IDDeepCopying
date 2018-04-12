//
//  IDDeepCopyingCategories.h
//  Example
//
//  Created by Андрей on 12.04.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDDeepCopying.h"

@interface NSArray (DeepCopy) <DeepCopying>

@end

@interface NSDictionary (DeepCopy) <DeepCopying>

@end

@interface NSSet (DeepCopy) <DeepCopying>

@end
