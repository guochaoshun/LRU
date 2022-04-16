//
//  ULLRUCache+Dictionary.m
//  UXLive
//
//  Created by 郭朝顺 on 2022/3/17.
//  Copyright © 2022 UXIN CO. All rights reserved.
//

#import "ULLRUCache+Convenience.h"

@implementation ULLRUCache (Convenience)

- (instancetype)initWithDictionary:(NSDictionary *)dictionary countLimit:(NSUInteger)countLimit {
    self = [self init];
    if (self) {
        self.countLimit = countLimit;
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (self.count < countLimit) {
                [self setObject:obj forKey:key];
            } else {
                *stop = YES;
            }
        }];
    }
    return self;
}

- (NSDictionary *)asDictionary {
    NSMutableDictionary *retVal = [NSMutableDictionary dictionaryWithCapacity:self.count];
    ULLRUNode *node = self.linkedList.headNode;
    while (node) {
        [retVal setObject:node.value forKey:node.key];
        node = (ULLRUNode *)node.next;
    }
    return retVal;
}

@end
