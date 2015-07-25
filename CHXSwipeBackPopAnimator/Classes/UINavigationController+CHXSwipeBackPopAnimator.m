//
//  UINavigationController+CHXSwipeBackPopAnimator.m
//  CHXSwipeBackPopAnimator
//
//  Created by Moch Xiao on 7/25/15.
//  Copyright (c) 2015 Moch Xiao. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "UINavigationController+CHXSwipeBackPopAnimator.h"
#import "UINavigationController+Private.h"
#import <objc/runtime.h>

static const void * CHXInteractivePopGestureRecognizerEnableKey = @"interactivePopGestureRecognizerEnable_";
static const void * CHXPreventScreenEdgeKey = @"preventScreenEdge_";

@implementation UINavigationController (CHXAddition)

- (BOOL)interactivePopGestureRecognizerEnable_ {
    return [objc_getAssociatedObject(self, CHXInteractivePopGestureRecognizerEnableKey) boolValue];
}

- (void)setInteractivePopGestureRecognizerEnable_:(BOOL)interactivePopGestureRecognizerEnable_ {
    [self willChangeValueForKey:(__bridge NSString *)(CHXInteractivePopGestureRecognizerEnableKey)];
    objc_setAssociatedObject(self,
                             CHXInteractivePopGestureRecognizerEnableKey,
                             @(interactivePopGestureRecognizerEnable_),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:(__bridge NSString *)(CHXInteractivePopGestureRecognizerEnableKey)];
}

- (BOOL)preventScreenEdge_ {
    return [objc_getAssociatedObject(self, CHXPreventScreenEdgeKey) boolValue];
}

- (void)setPreventScreenEdge_:(BOOL)preventScreenEdge_ {
    [self willChangeValueForKey:(__bridge NSString *)(CHXPreventScreenEdgeKey)];
    objc_setAssociatedObject(self,
                             CHXPreventScreenEdgeKey,
                             @(preventScreenEdge_),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:(__bridge NSString *)(CHXPreventScreenEdgeKey)];
}

#pragma mark -

- (void)chx_disableInteractivePopGestureRecognizerButPreventScreenEdge:(BOOL)preventScreenEdge {
    self.interactivePopGestureRecognizerEnable_ = NO;
    self.preventScreenEdge_ = preventScreenEdge;
}

- (void)chx_enableInteractivePopGestureRecognizer {
    self.interactivePopGestureRecognizerEnable_ = YES;
}

@end
