//
//  Created by Андрей on 10.04.2018.
//  Copyright © 2018 Improve Digital. All rights reserved.
//

#import "DeepCopyingCategories.h"

@implementation NSNumber (DeepCopying)
- (id)deepCopy { return self.copy; }
@end

@implementation NSString (DeepCopying)
- (id)deepCopy { return self.copy; }
@end

@implementation NSArray (DeepCopying)
- (id)deepCopy { return self.copy; }
@end

@implementation NSDictionary (DeepCopying)
- (id)deepCopy { return self.copy; }
@end

@implementation NSSet (DeepCopying)
- (id)deepCopy { return self.copy; }
@end
