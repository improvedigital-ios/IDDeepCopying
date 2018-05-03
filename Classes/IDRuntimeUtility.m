//
//  IDRuntimeUtility.m
//  Improve Digital
//
//  Created by Андрей on 17.03.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "IDRuntimeUtility.h"
#import "DeepCopyingProtocol.h"
#import <objc/runtime.h>

//TODO: Mutable deep copying

@implementation IDRuntimeUtility

+ (id)deepCopyForObject: (id)obj {
    
    return [self deepCopyForObject:obj
                           options:IDRuntimeUtilityOptionEmbedded
             assignedValuesForKeys:nil];
}

+ (id)deepCopyForObject: (id)obj assignedValuesForKeys:(NSSet <NSString *> *)keys {
    
    return [self deepCopyForObject:obj
                           options:IDRuntimeUtilityOptionEmbedded
             assignedValuesForKeys:keys];
}

#pragma mark - Private
+ (id)deepCopyForObject: (id)obj
                options: (IDRuntimeUtilityOptions)options
  assignedValuesForKeys: (NSSet <NSString *> *)keys {
    
    Class objType = [obj class];
    NSAssert(objType.accessInstanceVariablesDirectly, @"Potentially can not use this method, if has readonly properties");
    
    NSMutableSet *remainingKeys = keys.mutableCopy;
    
    id myCopy = [[objType alloc] init];
    
    unsigned int count;
    
    objc_property_t* props = class_copyPropertyList(objType, &count);
    for (int i = 0; i < count; i++) {
        
        objc_property_t property = props[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        
        const char *attributes = property_getAttributes(property);
        char buffer[1 + strlen(attributes)];
        strcpy(buffer, attributes);
        char *state = buffer, *attribute;
        
        // Detect iVar
        BOOL detectIvar = NO;
        while ((attribute = strsep(&state, ",")) != NULL) {
            if (attribute[0] == 'V') {
                detectIvar = YES;
            }
        }
        
        if (!detectIvar) {
            // NSLog(@"Readonly property %@ in class %@ won't be copied", propertyName, NSStringFromClass([obj class]));
            continue;
        }
        
        id referenceValue = [obj valueForKey:propertyName];
        
        // Reference value
        if ([remainingKeys containsObject:propertyName]) {
            [remainingKeys removeObject:propertyName];
            [myCopy setValue:referenceValue forKey:propertyName];
        }
        
        // Copy value
        else {
            id copyValue = nil;
            if (options == IDRuntimeUtilityOptionSurface) {
                copyValue = [self safeDeepCopy:referenceValue];
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
    }
    
    if (remainingKeys.count) {
        NSLog(@"Keys not found with deep copy process: %@", remainingKeys);
    }
    
    free(props);
    
    return myCopy;
}

+ (id)safeDeepCopy: (id)obj {
    
    if (obj == nil) {
        return nil;
    }
    
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
        copyValue = [self safeDeepCopy:value];
    }
    return copyValue;
}

+ (NSSet *)supportedClasses {
    
    NSSet * const set = [NSSet setWithObjects:
                         [NSString class],
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
