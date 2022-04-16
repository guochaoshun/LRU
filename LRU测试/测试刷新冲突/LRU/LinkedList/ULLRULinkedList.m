//
//  ULLRULinkedList.m
//  UXLive
//
//  Created by 郭朝顺 on 2022/3/17.
//  Copyright © 2022 UXIN CO. All rights reserved.
//

#import "ULLRULinkedList.h"

@interface ULLRULinkedList < Key : id<NSCopying>, Value : id<NSObject> > ()

@property (nonatomic, strong) ULLRUNode *head;
@property (nonatomic, strong) ULLRUNode *trail;
@property (nonatomic, assign) NSInteger count;

@end

@implementation ULLRULinkedList

- (void)addToHead:(ULLRUNode *)node {
    NSParameterAssert(node);
    if (!node) {
        return;
    }
    if (self.head == node) {
        return;
    }
    node.next = self.head;
    self.head.prev = node;
    self.head = node;
    self.count ++;
    if (!self.trail) {
        self.trail = node;
    }
}

- (void)addToTrail:(ULLRUNode *)node {
    NSParameterAssert(node);
    if (!node) {
        return;
    }
    if (self.trail == node) {
        return;
    }
    node.prev = self.trail;
    self.trail.next = node;
    self.trail = node;
    self.count ++;
    if (!self.head) {
        self.head = node;
    }
}

- (void)removeNode:(ULLRUNode *)node {
    NSParameterAssert(node);
    if (!node) {
        return;
    }
    if (self.head == node && self.trail == node) {
        [self removeAllObjects];
    } else if (self.head == node) {
        node.prev = nil;
        node.next.prev = nil;
        self.head = node.next;
        self.count --;
    } else if (self.trail == node) {
        node.next = nil;
        node.prev.next = nil;
        self.trail = node.prev;
        self.count --;
    } else {
        node.prev.next = node.next;
        node.next.prev = node.prev;
        self.count --;
    }
}

- (ULLRUNode *)removeTrailNode {
    ULLRUNode *node = self.trail;
    [self removeNode:node];
    return node;
}

- (ULLRUNode *)removeHeadNode {
    ULLRUNode *node = self.head;
    [self removeNode:node];
    return node;
}

- (void)moveToHead:(ULLRUNode *)node {
    [self removeNode:node];
    [self addToHead:node];
}

- (void)removeAllObjects {
    // 只需要移除头尾即可,node的prev是弱应用,next是强引用,移除head后会触发所有的数据的dealloc
    self.head = nil;
    self.trail = nil;
    self.count = 0;
}

- (NSInteger)count {
    return _count;
}

- (NSArray *)asArray {
    NSMutableArray *retVal = [[NSMutableArray alloc] initWithCapacity:self.count];
    ULLRUNode *node = self.head;
    while (node) {
        [retVal addObject:node.value];
        node = node.next;
    }
    return [retVal copy];
}


@end

