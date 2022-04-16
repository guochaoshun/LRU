//
//  Person.m
//  测试刷新冲突
//
//  Created by 郭朝顺 on 2022/4/15.
//

#import "Person.h"

@implementation Person

- (void)dealloc {
    NSLog(@"%s", __func__);
}


@end
