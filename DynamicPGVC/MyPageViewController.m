//
//  MyPageViewController.m
//  DynamicPGVC
//
//  Created by Don Mag on 11/17/20.
//

#import "MyPageViewController.h"

@interface MyPageViewController ()

@end

@implementation MyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	[self setViewControllers:@[_orderedPages[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
	
	self.dataSource = self;
	
}

- (UIViewController *)pageViewController: (UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
	NSUInteger index = [_orderedPages indexOfObject:viewController];
	if ((index == 0) || (index == NSNotFound)) {
		return nil;
	}
	
	index--;
	return [_orderedPages objectAtIndex:index];
}

- (UIViewController *)pageViewController: (UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
	NSUInteger index = [_orderedPages indexOfObject:viewController];
	if (index == NSNotFound) {
		return nil;
	}
	
	index++;
	if (index == [_orderedPages count]) {
		return nil;
	}
	return [_orderedPages objectAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
	return [_orderedPages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
	return 0;
}

@end
