#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, POControlViewDirection) {
    POControlViewDirectionUp,
    POControlViewDirectionDown,
    POControlViewDirectionLeft,
    POControlViewDirectionRight,
};

typedef void(^POControlViewCallback)(POControlViewDirection direction);

@interface POControlView : UIView

@property (nonatomic, copy) POControlViewCallback controlCallback;

@end
