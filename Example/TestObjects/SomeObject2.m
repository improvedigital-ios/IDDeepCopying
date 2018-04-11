//
//  SomeObject2.m
//  RealDeepCopy
//
//  Created by Андрей on 10.04.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "SomeObject2.h"

@implementation SomeObject2

- (id)deepCopy {
    return [IDRuntimeUtility deepCopyForObject:self];
}

- (NSURL *)someURL {
    return [NSURL URLWithString:@"someString"];
}

@end
