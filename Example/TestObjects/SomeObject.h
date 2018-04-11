//
//  SomeObject.h
//  RealDeepCopy
//
//  Created by Андрей on 09.04.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDDeepCopying.h"
#import "SomeObject2.h"

@interface SomeObject : NSObject <DeepCopying>

@property (assign, nonatomic) NSInteger integer;
@property (strong, nonatomic) SomeObject2 *someObject2;

@end
