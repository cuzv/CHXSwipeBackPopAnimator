# CHXSwipeBackPopAnimator
Swipe back pop animation, not just trigger screen edge!

# How does it look like?

![(1)](https://github.com/showmecode/CHXSwipeBackPopAnimator/blob/master/images/1.gif)

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
	
- [nonamelive](https://github.com/nonamelive/SloppySwiper)
