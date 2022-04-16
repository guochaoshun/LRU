//
//  ULLRULinkedList+Array.m
//  UXLive
//
//  Created by 郭朝顺 on 2022/3/17.
//  Copyright © 2022 UXIN CO. All rights reserved.
//

#import "ULLRULinkedList+Array.h"


@implementation ULLRULinkedList (Array)

- (NSArray *)asArray {
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    ULLRUNode *node = self.head;
    while (node) {
        [retVal addObject:node.value];
        node = node.next;
    }
    return retVal;
}

@end
