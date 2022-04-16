//
//  ULLRULinkedList.m
//  UXLive
//
//  Created by 郭朝顺 on 2022/3/17.
//  Copyright © 2022 UXIN CO. All rights reserved.
//

#import "ULLRULinkedList.h"

@interface ULLRULinkedList < Key : id<NSCopying>, Value : id<NSObject> > ()

@property (nonatomic, strong) ULLRUNode *headNode;
@property (nonatomic, strong) ULLRUNode *trailNode;
@property (nonatomic, assign) NSInteger count;

@end

@implementation ULLRULinkedList

- (void)addToHead:(ULLRUNode *)node {
    NSParameterAssert(node);
    if (!node) {
        return;
    }
    if (self.headNode == node) {
        return;
    }
    node.next = self.headNode;
    self.headNode.prev = node;
    self.headNode = node;
    self.count ++;
    if (!self.trailNode) {
        self.trailNode = node;
    }
}

- (void)addToTrail:(ULLRUNode *)node {
    NSParameterAssert(node);
    if (!node) {
        return;
    }
    if (self.trailNode == node) {
        return;
    }
    node.prev = self.trailNode;
    self.trailNode.next = node;
    self.trailNode = node;
    self.count ++;
    if (!self.headNode) {
        self.headNode = node;
    }
}

- (void)removeNode:(ULLRUNode *)node {
    NSParameterAssert(node);
    if (!node) {
        return;
    }
    if (self.headNode == node && self.trailNode == node) {
        [self removeAllObjects];
    } else if (self.headNode == node) {
        node.prev = nil;
        node.next.prev = nil;
        self.headNode = node.next;
        self.count --;
    } else if (self.trailNode == node) {
        node.next = nil;
        node.prev.next = nil;
        self.trailNode = node.prev;
        self.count --;
    } else {
        node.prev.next = node.next;
        node.next.prev = node.prev;
        self.count --;
    }
}

- (ULLRUNode *)removeTrailNode {
    ULLRUNode *node = self.trailNode;
    [self removeNode:node];
    return node;
}

- (ULLRUNode *)removeHeadNode {
    ULLRUNode *node = self.headNode;
    [self removeNode:node];
    return node;
}

- (void)moveToHead:(ULLRUNode *)node {
    [self removeNode:node];
    [self addToHead:node];
}

- (void)removeAllObjects {
    // 只需要移除头尾即可,node的prev是弱应用,next是强引用,移除head后会触发所有的数据的dealloc
    self.headNode = nil;
    self.trailNode = nil;
    self.count = 0;
}

- (NSInteger)count {
    return _count;
}

- (NSArray *)asArray {
    NSMutableArray *retVal = [[NSMutableArray alloc] initWithCapacity:self.count];
    ULLRUNode *node = self.headNode;
    while (node) {
        [retVal addObject:node.value];
        node = node.next;
    }
    return [retVal copy];
}

@end

