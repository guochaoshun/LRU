//
//  ULLRULinkedList.h
//  UXLive
//
//  Created by 郭朝顺 on 2022/3/17.
//  Copyright © 2022 UXIN CO. All rights reserved.
//

#import "ULLRUNode.h"

@interface ULLRULinkedList < Key : id<NSCopying>, Value : id<NSObject> > : NSObject

@property (nonatomic, strong, readonly) ULLRUNode<Key, Value> *head;
@property (nonatomic, strong, readonly) ULLRUNode<Key, Value> *trail;


// 将节点添加到头结点
- (void)addToHead:(ULLRUNode<Key, Value> *)node;
// 将节点添加到尾结点
- (void)addToTrail:(ULLRUNode<Key, Value> *)node;
// 移除节点
- (void)removeNode:(ULLRUNode<Key, Value> *)node;
// 移除尾结点
- (ULLRUNode<Key, Value> *)removeTrailNode;
// 移除头结点
- (ULLRUNode<Key, Value> *)removeHeadNode;
// 移动到头结点
- (void)moveToHead:(ULLRUNode<Key, Value> *)node;
// 移除所有元素
- (void)removeAllObjects;
// 时间复杂度：O(n)，由表头遍历实现, 优化项:内部记录一个数值,直接返回
- (NSUInteger)count;

- (NSArray *)asArray;

@end
