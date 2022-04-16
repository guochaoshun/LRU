//
//  ULLRUNode.m
//  UnitTestObjc
//
//  Created by 郭朝顺 on 2022/3/17.
//

#import "ULLRUNode.h"

@implementation ULLRUNode

- (instancetype)initWithKey:(id<NSCopying>)key value:(id<NSObject>)value {
    self = [super init];
    if (self) {
        self.key = key;
        self.value = value;
    }
    return self;
}

@end
