//
//  OverlayView.h
//  DynamicPGVC
//
//  Created by Don Mag on 11/17/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MyCustomBlock)(void);

@interface OverlayView : UIView

@property (nonatomic, copy) MyCustomBlock closeButtonBlock;
@property (nonatomic, copy) MyCustomBlock bottomButtonBlock;

- (void)setTitle:(NSString *)str;

- (void)addLabel:(NSString *)str;
- (void)addImageNamed:(NSString *)str;
- (void)addPageViewController:(UIPageViewController *)pgVC withPages:(NSMutableArray *)pages;
- (void)setButtonTitle:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
