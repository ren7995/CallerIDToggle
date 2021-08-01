//
//  CallerIDModule
//
//  Created by ren7995 on 2021-07-29 19:47:27
//

#import "CIDControlCenterModuleViewController.h"
#import <dlfcn.h>
#import <objc/runtime.h>

static CIDControlCenterModuleViewController *instance;

@implementation CIDControlCenterModuleViewController {
    TPSCallingLineIdRestrictionListController *_tps;
}

- (instancetype)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle {
    self = [super initWithNibName:name bundle:bundle];

    if(self) {
        instance = self;
        // Open the caller ID restriction settings bundle
        dlopen("/System/Library/PreferenceBundles/CallingLineIdRestrictionTelephonySettings.bundle/CallingLineIdRestrictionTelephonySettings", RTLD_NOW);
        // Create a list controller. This will allow for us to make requests to change Caller ID display state
        // We create a list controller instead of the RestrictionController directly so that the delegate requirement is filled
        _tps = [[objc_getClass("TPSCallingLineIdRestrictionListController") alloc] initForContentSize:CGSizeZero];

        [[NSDistributedNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(_recieveStateChangeNotification:)
                   name:@"me.lau.calleridtoggle.statechanged"
                 object:nil];

        _imageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"questionmark"]];
        _imageView.contentMode = UIViewContentModeCenter;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.tintColor = [UIColor whiteColor];
        [self.view addSubview:_imageView];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [_imageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
        [_imageView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
        [_imageView.widthAnchor constraintEqualToConstant:40].active = true;
        [_imageView.heightAnchor constraintEqualToConstant:40].active = true;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleState)];
        [self.view addGestureRecognizer:tap];
    }

    return self;
}

- (void)_recieveStateChangeNotification:(NSNotification *)noti {
    NSInteger newState = [noti.userInfo[@"state"] integerValue];
    self.state = newState == 1;
    [self updateImage];
}

- (void)_recieveContext:(CTXPCServiceSubscriptionContext *)ctx {
    // Update the context used to make requests
    [_tps setSubscriptionContext:ctx];
    self.state = [[_tps mainSwitchOn:nil] boolValue];
    [self updateImage];
}

- (void)toggleState {
    BOOL newState = !self.state;
    [self setState:newState];
    [_tps setMainSwitchOn:@(newState) specifier:nil];

    // Wait for delegate method to be called before updating image
}

- (void)updateImage {
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:20 weight:UIImageSymbolWeightLight];
    if(self.state == YES) {
        _imageView.image = [UIImage systemImageNamed:@"phone.circle.fill" withConfiguration:config];
    } else if(self.state == NO) {
        _imageView.image = [UIImage systemImageNamed:@"phone.circle" withConfiguration:config];
    }
}

- (BOOL)_canShowWhileLocked {
    return YES;
}

- (BOOL)shouldBeginTransitionToExpandedContentModule {
    return NO;
}

+ (CIDControlCenterModuleViewController *)instanceIfExists {
    return instance;
}

@end