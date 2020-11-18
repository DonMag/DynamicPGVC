//
//  MyPageViewController.h
//  DynamicPGVC
//
//  Created by Don Mag on 11/17/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyPageViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *orderedPages;

@end

NS_ASSUME_NONNULL_END
