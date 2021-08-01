#import "Tweak.h"
#import <dlfcn.h>
#import <objc/runtime.h>
#import <substrate.h>

static void (*orig_callingLineIdControllerDidChangeState)(TPSCallingLineIdRestrictionListController *, SEL, id, NSInteger, id);
static void hooked_callingLineIdControllerDidChangeState(TPSCallingLineIdRestrictionListController *self, SEL _cmd, id controller, NSInteger state, id error) {
    orig_callingLineIdControllerDidChangeState(self, _cmd, controller, state, error);
    // Notify of state change
    [[NSDistributedNotificationCenter defaultCenter]
        postNotificationName:@"me.lau.calleridtoggle.statechanged"
                      object:nil
                    userInfo:@{
                        @"state" : @(state)
                    }];
}

static CTXPCServiceSubscriptionContext *(*orig_initWithCoder)(CTXPCServiceSubscriptionContext *, SEL, id);
static CTXPCServiceSubscriptionContext *hooked_initWithCoder(CTXPCServiceSubscriptionContext *self, SEL _cmd, id coder) {
    id orig = orig_initWithCoder(self, _cmd, coder);
    // Update the context used for authorization
    if(self.phoneNumber && [self.phoneNumber isKindOfClass:[NSString class]]) {
        // We are off the main thread since this is an xpc callback thread
        // Need to jump back for UI updates
        dispatch_async(dispatch_get_main_queue(), ^{
            [[objc_getClass("CIDControlCenterModuleViewController") instanceIfExists] _recieveContext:self];
        });
    }
    return orig;
}

__attribute__((constructor)) static void loadTweak(__unused int argc, __unused char **argv, __unused char **envp) {
    // Load libraries in case they aren't already loaded
    dlopen("/System/Library/PreferenceBundles/CallingLineIdRestrictionTelephonySettings.bundle/CallingLineIdRestrictionTelephonySettings", RTLD_NOW);
    dlopen("/System/Library/Frameworks/CoreTelephony.framework/CoreTelephony", RTLD_NOW);
    if([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"]) {
        // SpringBoard
        MSHookMessageEx(
            objc_getClass("CTXPCServiceSubscriptionContext"),
            @selector(initWithCoder:),
            (IMP)&hooked_initWithCoder,
            (IMP *)&orig_initWithCoder);
    }
    // Settings app and SpringBoard
    MSHookMessageEx(
        objc_getClass("TPSCallingLineIdRestrictionListController"),
        @selector(callingLineIdController:didChangeState:error:),
        (IMP)&hooked_callingLineIdControllerDidChangeState,
        (IMP *)&orig_callingLineIdControllerDidChangeState);
}
