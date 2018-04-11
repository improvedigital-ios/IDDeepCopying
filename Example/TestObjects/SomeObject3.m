//
//  SomeObject3.m
//  RealDeepCopy
//
//  Created by Андрей on 10.04.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "SomeObject3.h"

@implementation SomeObject3

- (id)deepCopy {
    return [IDRuntimeUtility deepCopyForObject:self];
}

@end
