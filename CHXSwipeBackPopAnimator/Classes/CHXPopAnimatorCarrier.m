//
//  CHXPopAnimatorPayload.m
//  CHXSwipeBackPopAnimator
//
//  Created by Moch Xiao on 4/18/15.
//  Copyright (c) 2014 Moch Xiao (https://github.com/atcuan).
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

#import "CHXPopAnimatorCarrier.h"
#import "CHXPopAnimator.h"
#import "UINavigationController+Private.h"

@interface CHXPopAnimatorCarrier () <UIGestureRecognizerDelegate>
@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) CHXPopAnimator *popAnimator;
@property (nonatomic, assign) BOOL animating;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactiveTransition;
@end

@implementation CHXPopAnimatorCarrier

- (void)dealloc {
    [_panGestureRecognizer removeTarget:self action:@selector(handlePan:)];
    [_navigationController.view removeGestureRecognizer:_panGestureRecognizer];
}

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    if (self = [super init]) {
        NSParameterAssert(navigationController);
        
        _navigationController = navigationController;
        _navigationController.interactivePopGestureRecognizerEnable_ = YES;
        [self commitInit];
    }
    
    return self;
}

- (void)commitInit {
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    _panGestureRecognizer.maximumNumberOfTouches = 1;
    _panGestureRecognizer.delegate = self;
    [_navigationController.view addGestureRecognizer:_panGestureRecognizer];

    _popAnimator = [CHXPopAnimator new];
}

- (void)handlePan:(UIPanGestureRecognizer *)sender {
    BOOL systemPopBehavior = NO;
    if (!_navigationController.interactivePopGestureRecognizerEnable_) {
        if (!_navigationController.preventScreenEdge_) {
            return;
        }
        
        systemPopBehavior = YES;
    }

    UIView *navigationView = self.navigationController.view;
    UIGestureRecognizerState state = sender.state;
    if (state == UIGestureRecognizerStateBegan) {
        CGFloat velocityX = [sender velocityInView:navigationView].x;
        if ([self.navigationController.viewControllers count] > 1 && !self.animating && velocityX > 0) {
            void(^runPopAnimation)(void) = ^{
                self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];
                [self.navigationController popViewControllerAnimated:YES];
            };
            
            CGPoint location = [sender locationInView:navigationView];
            if (systemPopBehavior) {
                /// system behavior
                if (location.x <= 44) {
                    runPopAnimation();
                }
                return;
            }
            
            /// normal custom pop animation behavior
            CGFloat velocityY = [sender velocityInView:navigationView].y;
            if (0 == velocityY || location.x <= 44) {
                runPopAnimation();
            }
        }
    } else if (state == UIGestureRecognizerStateChanged) {
        CGFloat translationX = [sender translationInView:navigationView].x;
        if (translationX > 0) {
            CGFloat percentComplete = fabs([sender translationInView:navigationView].x / CGRectGetWidth(navigationView.bounds));
            [self.interactiveTransition updateInteractiveTransition:percentComplete];
        }
    } else if (state == UIGestureRecognizerStateEnded) {
        CGFloat velocityX = [sender velocityInView:navigationView].x;
        if (velocityX > 0) {
            [self.interactiveTransition finishInteractiveTransition];
        } else {
            [self.interactiveTransition cancelInteractiveTransition];
            self.animating = NO;
        }
        
        self.interactiveTransition = nil;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPop) {
        return self.popAnimator;
    }
    
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return self.interactiveTransition;
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    self.animating = animated;
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    self.animating = NO;
    
    if (navigationController.viewControllers.count <= 1) {
        self.panGestureRecognizer.enabled = NO;
    } else {
        self.panGestureRecognizer.enabled = YES;
    }
}

@end
