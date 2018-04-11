//
//  SomeObject2.h
//  RealDeepCopy
//
//  Created by Андрей on 10.04.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SomeObject3.h"
#import "IDDeepCopying.h"

@interface SomeObject2 : NSObject <DeepCopying>

@property (strong, nonatomic) NSArray <SomeObject3 *>* someArray;
@property (strong, nonatomic, readonly) NSURL *someURL;

@end
