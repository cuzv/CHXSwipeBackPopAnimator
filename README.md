# CHXSwipeBackPopAnimator
Swipe back pop animation, not just trigger screen edge!

# How does it look like?

[![Particular](images/1.gif)](images/1.gif)
[![Hide bottom bar](images/2.gif)](images/2.gif)
[![No hide bottom bar](images/3.gif)](images/3.gif)

## How to use

- add `pod CHXSwipeBackPopAnimator` your pod file
- run `pod update --no-repo-update --verbose`
- Edit you `UINavigationController` file
	
	```Objective-c
	#import "CHXPopAnimatorPayload.h"
	...
	@property (nonatomic, strong) CHXPopAnimatorPayload *payload;
	...
	self.payload = [[CHXPopAnimatorPayload alloc] initWithNavigationController:self];
    self.delegate = self.payload;
	```

## Requirements

- iOS 7
- ARC

# Refrence
	
- [nonamelive](https://github.com/nonamelive/SloppySwiper/blob/master/Classes/SSWAnimator.m#L67)
