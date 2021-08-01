//
//  CallerIDModule
//
//  Created by ren7995 on 2021-07-29 19:47:27
//

#import "CIDControlCenterModule.h"
#import "CIDControlCenterModuleViewController.h"

@implementation CIDControlCenterModule

- (instancetype)init {
    self = [super init];
    if(self) {
        _contentViewController = [[CIDControlCenterModuleViewController alloc] init];
    }
    return self;
}

@end
