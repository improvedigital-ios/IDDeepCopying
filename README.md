IDDeepCopying
============



## Getting started

1. #import <IDDeepCopying/IDDeepCopying.h>
2. Add protocol <DeepCopying>
3. implement deepCopy as below

```objective-c
- (id)deepCopy {
    return [IDRuntimeUtility deepCopyForObject:self];
}
```
