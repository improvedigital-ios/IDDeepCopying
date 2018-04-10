//
//  IDRuntimeUtility.m
//  objc.shoploan
//
//  Created by Андрей on 17.03.2018.
//  Copyright © 2018 sovcombank. All rights reserved.
//

#import "IDRuntimeUtility.h"
#import <objc/runtime.h>
#import "IDDeepCopying.h"

//TODO: Handle NSSet
//TODO: Mutable deep copying

@implementation IDRuntimeUtility

+ (id)deepCopyForObject: (id)obj {
    return [self deepCopyForObject:obj options:IDRuntimeUtilityOptionEmbedded];
}

+ (id)deepCopyForObject:(id)obj options:(IDRuntimeUtilityOptions)options {

    Class objType = [obj class];
    NSAssert(objType.accessInstanceVariablesDirectly, @"Potentially can not use this method, if has readonly properties");
    
    id myCopy = [[objType alloc] init];
    
    unsigned int count;
    
    objc_property_t* props = class_copyPropertyList(objType, &count);
    for (int i = 0; i < count; i++) {
        
        objc_property_t property = props[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        
        NSString * const hashPropertyName = @"hash";
        NSString * const superclassPropertyName = @"superclass";
        NSString * const descriptionPropertyName = @"description";
        NSString * const debugDescriptionPropertyName = @"debugDescription";
        
        if ([propertyName isEqualToString:hashPropertyName] ||
            [propertyName isEqualToString:superclassPropertyName] ||
            [propertyName isEqualToString:descriptionPropertyName] ||
            [propertyName isEqualToString:debugDescriptionPropertyName]) {
            continue;
        }
        
        id copyValue = nil;
        if (options == IDRuntimeUtilityOptionSurface) {
            copyValue = [self safeDeepCopy:[obj valueForKey:propertyName]];
        }
        else if (options == IDRuntimeUtilityOptionEmbedded) {
            copyValue = [self copyValueWithPropertyName:propertyName inObj:obj];
        }
        else {
            NSAssert(NO, @"Not handled another option states");
        }
        
        if (copyValue != nil) {
            [myCopy setValue:copyValue forKey:propertyName];
        }
    }
    free(props);
    
    return myCopy;
}

+ (id)safeDeepCopy: (id)obj {
    
    BOOL foundInSet = NO;
    for (Class type in [self supportedClasses]) {
        if ([obj isKindOfClass:type]) {
            foundInSet = YES;
            break;
        };
    }
    
    if (foundInSet) {
        return [obj copy];
    }
    else if ([obj conformsToProtocol:@protocol(DeepCopying)]) {
        id exampleObj = (id <DeepCopying>) obj;
        return [exampleObj deepCopy];
    }
    else {
        NSAssert(NO, @"Object with type %@ not conforms to protocol DeepCopying. Add it and implement for truly deep copying", NSStringFromClass([obj class]));
        return obj;
    }
}

+ (id)copyValueWithPropertyName: (NSString *)propertyName inObj: (id)obj {

    id value = [obj valueForKey:propertyName];
    
    id copyValue = nil;
    if ([obj conformsToProtocol:@protocol(DeepCopying)]) {
        
        if ([value isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *mutableArray = [NSMutableArray new];
            for (id val in value) {
                id arrayObj = [self safeDeepCopy: val];
                [mutableArray addObject:arrayObj];
            }
            
            copyValue = mutableArray.copy;
        }
        else if ([value isKindOfClass:[NSDictionary class]]) {
            
            NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];
            NSDictionary *dict = (NSDictionary *)value;
            for (id key in dict.allKeys) {
                mutableDictionary[key] = [self safeDeepCopy: dict[key]];
            }
            copyValue = mutableDictionary.copy;
        }
        else {
            copyValue = [self safeDeepCopy: value];
        }
    }
    return copyValue;
}

+ (NSSet *)supportedClasses {
    
    NSSet * const set = [NSSet setWithObjects:
                         [NSString class],
                         [NSArray class],
                         [NSDictionary class],
                         [NSSet class],
                         [NSDate class],
                         [NSDecimalNumber class],
                         [NSUserDefaults class],
                         [NSPredicate class],
                         [NSDateFormatter class],
                         [NSTimer class],
                         [NSError class],
                         [NSEnumerator class],
                         [NSURL class],
                         [NSURLRequest class],
                         [NSURLSession class],
                         [NSValue class], // + NSNumber
                         [NSIndexSet class],
                         [NSThread class],
                         [NSNull class],
                         [NSBundle class],
                         [NSLock class],
                         [NSCache class],
                         [NSCalendar class],
                         [NSLocale class],
                         [NSException class],
                         nil];
    
    return set;
}


@end
