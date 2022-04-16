//
//  ULLRUCache.m
//  UXLive
//
//  Created by 郭朝顺 on 2022/3/16.
//  Copyright © 2022 UXIN CO. All rights reserved.
//

#import "ULLRUCache.h"
#import "ULLRULinkedList.h"
#import <UIKit/UIKit.h>

@interface ULLRUCache ()

@end

@implementation ULLRUCache

- (instancetype)init {
    self = [super init];
    if (self) {
        _nodeDic = [NSMutableDictionary dictionary];
        _linkedList = [[ULLRULinkedList alloc] init];
        _count = 0;
        _countLimit = NSIntegerMax;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMemoryWarning)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    if (self.ingoredMemoryWarning) {
        return;
    }
    [self removeAllObjects];
    if ([self.delegate respondsToSelector:@selector(cacheDidReceiveMemoryWarning:)]) {
        [self.delegate cacheDidReceiveMemoryWarning:self];
    }
}

- (void)setObject:(id<NSObject>)object forKey:(id<NSCopying>)key {
    if (!key) {
        return;
    }
    ULLRUNode *node = [self.nodeDic objectForKey:key];
    // node存在,更新node
    if (node) {
        // object不存在,触发移除操作
        if (!object) {
            [self.nodeDic removeObjectForKey:key];
            [self.linkedList removeNode:node];
            self.count --;
        } else {
            // object存在,触发更新操作
            if (![node.value isEqual:object]) {
                node.value = object;
                if ([self.delegate respondsToSelector:@selector(cache:didUpdateObject:forKey:)]) {
                    [self.delegate cache:self didUpdateObject:object forKey:key];
                }
            }
            // 移动到头节点
            [self.linkedList moveToHead:node];
        }
    } else {
        // node不存在,新增一个node到字典和数组中
        ULLRUNode *newNode = [[ULLRUNode alloc] initWithKey:key value:object];
        [self.nodeDic setObject:newNode forKey:key];
        [self.linkedList addToHead:newNode];
        self.count ++;

        // 检查数量有没有超出
        [self p_checkoutLimitCount];

    }
}

- (id<NSObject>)objectforKey:(id<NSCopying>)key {
    if (!key) {
        return nil;
    }
    ULLRUNode *node = [self.nodeDic objectForKey:key];
    if (node) {
        [self.linkedList moveToHead:node];
    }
    return node.value;
}

- (void)removeObjectForKey:(id<NSCopying>)key {
    if (!key) {
        return;
    }
    ULLRUNode *node = [self.nodeDic objectForKey:key];
    if (!node) {
        return;
    }
    [self.nodeDic removeObjectForKey:key];
    [self.linkedList removeNode:node];
    self.count --;
}

- (NSUInteger)count {
    return _count;
}

- (void)removeAllObjects {
    [self.nodeDic removeAllObjects];
    [self.linkedList removeAllObjects];
    self.count = 0;
}

- (void)updateCountLimit:(NSUInteger)countLimit {
    self.countLimit = countLimit;
    [self p_checkoutLimitCount];
}

// 检查有没有超出限制,如果超出后触发丢弃策略
- (void)p_checkoutLimitCount {
    // 若动态修改容量大小，得有这种超限策略加持
    if (self.count > self.countLimit) {
        NSUInteger diff = self.count - self.countLimit;
        for (NSUInteger i = 0; i < diff; i++) {
            ULLRUNode *trailNode = [self.linkedList removeTrailNode];
            [self.nodeDic removeObjectForKey:trailNode.key];
            self.count --;
            if ([self.delegate respondsToSelector:@selector(cache:didDropObject:forKey:)]) {
                [self.delegate cache:self didDropObject:trailNode.value forKey:trailNode.key];
            }
        }
    }
}

- (id<NSObject,NSCopying>)objectForKeyedSubscript:(id<NSCopying>)key {
    return [self objectforKey:key];
}

- (void)setObject:(id<NSObject,NSCopying>)obj forKeyedSubscript:(id<NSCopying>)key {
    [self setObject:obj forKey:key];
}


- (void)dealloc {
    [self removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
