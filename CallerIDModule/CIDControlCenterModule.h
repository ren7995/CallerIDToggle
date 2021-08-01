//
//  CallerIDModule
//
//  Created by ren7995 on 2021-07-29 19:47:27
//

#import <UIKit/UIKit.h>
#import "Headers/CCUIContentModule-Protocol.h"
#import "Headers/CCUIContentModuleContentViewController-Protocol.h"

@interface CIDControlCenterModule : NSObject <CCUIContentModule>
@property (nonatomic, readonly) UIViewController<CCUIContentModuleContentViewController> *contentViewController;
@property (nonatomic, readonly) UIViewController *backgroundViewController;
@end
