//
//  CHXPopAnimator.m
//  CHXSwipeBackPopAnimator
//
//  Created by Moch Xiao on 4/18/15.
//  Copyright (c) 2015 Moch Xiao. All rights reserved.
//

#import "CHXPopAnimator.h"

#pragma mark -

@implementation UIView (CHXLeftEdgeShadow)

- (void)addLeftEdgeShadow
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = path.CGPath;
    self.layer.shadowOffset = CGSizeMake(-2.0f, 0.0f);
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowRadius = 2.0f;
    self.layer.shadowOpacity = 0.2f;
}

@end

#pragma mark -

@implementation CHXPopAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning> )transitionContext
{
    return 0.25f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning> )transitionContext
{
    // Get viewcontrollers and tabBar
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UITabBarController *tabBarController = toViewController.tabBarController;
    UITabBar *tabBar = tabBarController.tabBar;

    // If fromViewController's tabbar did not appear,then needAdjustTabbarPosition = YES
    // which means the tabBar will show up follow the toViewController
    BOOL needAdjustTabBarPosition = !tabBar.isHidden && tabBar.frame.origin.x != 0;
    if (needAdjustTabBarPosition) {
        [tabBar.layer removeAllAnimations];
        
        CGPoint tabBarCenter = tabBar.center;
        tabBarCenter.x = toViewController.view.center.x;
        tabBar.center = tabBarCenter;
        
        [toViewController.view addSubview:tabBar];
    }
    
    // Add left edge shdow
    [fromViewController.view addLeftEdgeShadow];
    
    // Add target view to the container, and move it to back.
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    // Add maskView to toViewController's view
    UIView *maskView = [[UIView alloc] initWithFrame:toViewController.view.bounds];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [toViewController.view addSubview:maskView];
    
    // Set toViewController animation init positon
    CGFloat transformX = -CGRectGetWidth(toViewController.view.bounds) * 0.3f;
    toViewController.view.transform = CGAffineTransformMakeTranslation(transformX, 0);
    
    // Run the animation
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
        toViewController.view.transform = CGAffineTransformIdentity;
        fromViewController.view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(toViewController.view.bounds), 0);
        maskView.alpha = 0;
    } completion:^(BOOL finished) {
        if (needAdjustTabBarPosition) {
            [tabBar removeFromSuperview];
            
            CGPoint tabBarCenter = tabBar.center;
            tabBarCenter.x = toViewController.view.center.x;
            tabBar.center = tabBarCenter;
            
            [tabBarController.view addSubview:tabBar];
        }
        
        // If cancel animation, recover the toViewController's position
        toViewController.view.transform = CGAffineTransformIdentity;
        fromViewController.view.transform = CGAffineTransformIdentity;
        [maskView removeFromSuperview];
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
