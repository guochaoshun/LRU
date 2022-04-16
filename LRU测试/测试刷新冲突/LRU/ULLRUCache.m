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

@interface ULLRUCache < Key : id<NSCopying>, Value : id<NSObject> > ()

@end

@implementation ULLRUCache

- (void)dealloc {
    [self removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _map = [NSMutableDictionary dictionary];
        _linkedList = [[ULLRULinkedList alloc] init];
        _count = 0;
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
    ULLRUNode *node = [self.map objectForKey:key];
    if (node) {
        // 移除
        if (!object) {
            [self.map removeObjectForKey:key];
            [self.linkedList removeNode:node];
            self.count --;
        } else {
            // 更新
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
        //判断数量
        if (self.countLimit > 0 && self.count >= self.countLimit) {
            ULLRUNode *trailNode = [self.linkedList removeTrailNode];
            [self.map removeObjectForKey:trailNode.key];
            self.count --;
            if ([self.delegate respondsToSelector:@selector(cache:didDropObject:forKey:)]) {
                [self.delegate cache:self didDropObject:trailNode.value forKey:trailNode.key];
            }
        }

        ULLRUNode *newNode = [[ULLRUNode alloc] initWithKey:key value:object];

        [self.map setObject:newNode forKey:key];
        [self.linkedList addToHead:newNode];
        self.count ++;
    }
}

- (id<NSObject>)objectforKey:(id<NSCopying>)key {
    if (!key) {
        return nil;
    }
    ULLRUNode *node = [self.map objectForKey:key];
    if (node) {
        [self.linkedList moveToHead:node];
    }
    return node.value;
}

- (void)removeObjectForKey:(id<NSCopying>)key {
    if (!key) {
        return;
    }
    ULLRUNode *node = [self.map objectForKey:key];
    if (!node) {
        return;
    }
    [self.map removeObjectForKey:key];
    [self.linkedList removeNode:node];
    self.count --;
}

- (NSUInteger)count {
    return _count;
}

- (void)removeAllObjects {
    [self.map removeAllObjects];
    [self.linkedList removeAllObjects];
    self.count = 0;
}

- (void)updateCountLimit:(NSUInteger)countLimit {
    self.countLimit = countLimit;
    // 若动态修改容量大小，得有这种超限策略加持
    if (self.countLimit > 0 && self.count > self.countLimit) {
        NSUInteger diff = self.count - self.countLimit;
        for (NSUInteger i = 0; i < diff; i++) {
            ULLRUNode *trailNode = [self.linkedList removeTrailNode];
            [self.map removeObjectForKey:trailNode.key];
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

@end
