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

@end

NS_ASSUME_NONNULL_END
