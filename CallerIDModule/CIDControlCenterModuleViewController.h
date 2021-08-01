//
//  CallerIDModule
//
//  Created by ren7995 on 2021-07-29 19:47:27
//

#import <UIKit/UIKit.h>
#import "../Tweak/Tweak.h"
#import "Headers/CCUIContentModuleContentViewController-Protocol.h"

@class CTXPCServiceSubscriptionContext;
@interface CIDControlCenterModuleViewController : UIViewController <CCUIContentModuleContentViewController>
@property (nonatomic, readonly) CGFloat preferredExpandedContentHeight;
@property (nonatomic, readonly) CGFloat preferredExpandedContentWidth;
@property (nonatomic, readonly) BOOL providesOwnPlatter;
@property (nonatomic, strong) UIView *moduleMaterialView;
@property (nonatomic, assign) BOOL state;
@property (nonatomic, strong) UIImageView *imageView;
- (void)_recieveStateChangeNotification:(NSNotification *)noti;
- (void)_recieveContext:(CTXPCServiceSubscriptionContext *)ctx;
+ (CIDControlCenterModuleViewController *)instanceIfExists;
@end

@interface TPSCallingLineIdRestrictionController : NSObject
- (NSUInteger)state;
- (void)requestStateChange:(NSUInteger)arg1;
- (id)initWithSubscriptionContext:(id)arg1;
@end

@interface TPSCallingLineIdRestrictionListController : UIViewController
- (id)initForContentSize:(CGSize)arg1;
- (void)setMainSwitchOn:(NSNumber *)arg1 specifier:(id)arg2;
- (void)setSubscriptionContext:(id)arg1;
- (TPSCallingLineIdRestrictionController *)callingLineIdRestrictionController;
- (NSNumber *)mainSwitchOn:(id)arg1;
@end

@interface UIApplication (SpringBoard)
+ (id)sharedApplication;
- (BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
@end
