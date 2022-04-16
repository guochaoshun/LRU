//
//  ______Tests.m
//  测试刷新冲突Tests
//
//  Created by 郭朝顺 on 2021/9/24.
//

#import <XCTest/XCTest.h>
#import "ULLRUCache.h"
#import "ULLRULinkedList.h"
#import "ULLRUNode.h"
#import "Person.h"

@interface ______Tests : XCTestCase

@end

@implementation ______Tests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

/// 验证ULLRULinkedList内部维护的count是否准确
- (void)testExample {
    ULLRULinkedList *linkList = [[ULLRULinkedList alloc] init];
    for (int i = 0; i<100; i++) {
        ULLRUNode *node = [[ULLRUNode alloc] initWithKey:@(i) value:[Person new]];
        [linkList addToHead:node];
        NSAssert(linkList.asArray.count == linkList.count, @"数量不匹配");

        node = [[ULLRUNode alloc] initWithKey:@(1000+i) value:[Person new]];
        [linkList addToTrail:node];
        NSAssert(linkList.asArray.count == linkList.count, @"数量不匹配");
    }
    for (int i = 1; i<10; i++) {
        [linkList removeHeadNode];
        NSAssert(linkList.asArray.count == linkList.count, @"数量不匹配");
        [linkList removeTrailNode];
        NSAssert(linkList.asArray.count == linkList.count, @"数量不匹配");
    }

    for (int i = 1; i<10; i++) {
        [linkList moveToHead:linkList.trailNode];
        NSAssert(linkList.asArray.count == linkList.count, @"数量不匹配");
    }

}
- (void)testExample1 {

}
- (void)testExample2 {

}
- (void)testExample3 {

}
- (void)testExample4 {

}
- (void)testExample5 {

}
- (void)testExample6 {

}
- (void)testExample7 {

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
