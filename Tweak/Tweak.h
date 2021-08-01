#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CallerIDModule/CIDControlCenterModuleViewController.h"

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end

@interface CTXPCServiceSubscriptionContext : NSObject
@property (nonatomic, strong) NSString *phoneNumber;
@end
