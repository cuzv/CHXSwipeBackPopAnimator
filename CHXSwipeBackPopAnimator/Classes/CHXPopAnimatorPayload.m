//
//  CHXPopAnimatorPayload.m
//  CHXSwipeBackPopAnimator
//
//  Created by Moch Xiao on 4/18/15.
//  Copyright (c) 2015 Moch Xiao. All rights reserved.
//

#import "CHXPopAnimatorPayload.h"
#import "CHXPopAnimator.h"

@interface CHXPopAnimatorPayload ()
@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) CHXPopAnimator *popAnimator;
@property (nonatomic, assign) BOOL animating;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactiveTransition;
@end

@implementation CHXPopAnimatorPayload

- (void)dealloc {
    [_panGestureRecognizer removeTarget:self action:@selector(handlePan:)];
    [_navigationController.view removeGestureRecognizer:_panGestureRecognizer];
}

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    if (self = [super init]) {
        NSParameterAssert(navigationController);
        
        _navigationController = navigationController;
        [self commitInit];
    }
    
    return self;
}

- (void)commitInit {
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    _panGestureRecognizer.maximumNumberOfTouches = 1;
    [_navigationController.view addGestureRecognizer:_panGestureRecognizer];
    
    _popAnimator = [CHXPopAnimator new];
}

- (void)handlePan:(UIPanGestureRecognizer *)sender {
    UIView *navigationView = self.navigationController.view;
    
    UIGestureRecognizerState state = sender.state;
    if (state == UIGestureRecognizerStateBegan) {
        CGFloat velocityX = [sender velocityInView:navigationView].x;
        if ([self.navigationController.viewControllers count] > 1 && !self.animating && velocityX > 0) {
            self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];
            [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop) {
        return self.popAnimator;
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactiveTransition;
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    self.animating = animated;
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    self.animating = NO;
    
    if (navigationController.viewControllers.count <= 1) {
        self.panGestureRecognizer.enabled = NO;
    } else {
        self.panGestureRecognizer.enabled = YES;
    }
}

@end
