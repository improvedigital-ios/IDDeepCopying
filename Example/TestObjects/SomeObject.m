//
//  SomeObject.m
//  RealDeepCopy
//
//  Created by Андрей on 09.04.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "SomeObject.h"

@implementation SomeObject

- (id)deepCopy {
    return [IDRuntimeUtility deepCopyForObject:self];
}

@end
