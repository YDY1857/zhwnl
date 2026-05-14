#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// UIView子类返回空View，避免nil导致崩溃
static id returnEmptyView(id self, SEL _cmd, ...) {
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    v.hidden = YES;
    v.userInteractionEnabled = NO;
    return v;
}

// 纯数据对象返回nil（不是View，nil安全）
static id returnNil(id self, SEL _cmd, ...) {
    return nil;
}

// 返回0
static NSInteger returnZero(id self, SEL _cmd, ...) {
    return 0;
}

// 空实现
static void doNothing(id self, SEL _cmd, ...) {
    return;
}

// apiVersion返回"0"
static NSString* fakeApiVersion(id self, SEL _cmd) {
    return @"0";
}

static void hookClass(const char *className, SEL sel, IMP newIMP, const char *types) {
    Class cls = objc_getClass(className);
    if (!cls) return;
    Method m = class_getInstanceMethod(cls, sel);
    if (m) {
        method_setImplementation(m, newIMP);
    } else {
        class_addMethod(cls, sel, newIMP, types);
    }
}

static void doHook(void) {

    // ── 穿山甲 CSJ（数据对象，返回nil安全）──────────
    hookClass("CSJNativeAd",
        @selector(init), (IMP)returnNil, "@@:");
    hookClass("CSJNativeAd",
        @selector(setAdSlot:), (IMP)doNothing, "v@:@");
    hookClass("CSJNativeAd",
        @selector(setAdType:), (IMP)doNothing, "v@:@");

    hookClass("CSJNativeAdsManager",
        @selector(init), (IMP)returnNil, "@@:");
    hookClass("CSJNativeAdsManager",
        @selector(setAdSlot:), (IMP)doNothing, "v@:@");

    hookClass("CSJNativeExpressAdManager",
        @selector(init), (IMP)returnNil, "@@:");
    hookClass("CSJNativeExpressAdManager",
        @selector(setAdSlot:), (IMP)doNothing, "v@:@");

    hookClass("CSJNativeExpressRewardedVideoAd",
        @selector(init), (IMP)returnNil, "@@:");

    // ── 广点通 GDT（数据对象，返回nil安全）──────────
    hookClass("GDTAdDLView",
        @selector(initWithFrame:), (IMP)returnEmptyView, "@@:{CGRect=}");
    hookClass("GDTAdDLView",
        @selector(setAdConfig:), (IMP)doNothing, "v@:@");
    hookClass("GDTAdDLView",
        NSSelectorFromString(@"setAdslot:"), (IMP)doNothing, "v@:@");

    hookClass("GDTAdParams",
        @selector(init), (IMP)returnNil, "@@:");

    hookClass("GDTAdServiceParams",
        @selector(init), (IMP)returnNil, "@@:");

    // ── 万年历广告View（全部返回空View）─────────────
    hookClass("ET3rdADSplash",
        @selector(initWithFrame:), (IMP)returnEmptyView, "@@:{CGRect=}");
    hookClass("ET3rdADSplash",
        NSSelectorFromString(@"initWithFrame:withType:"), (IMP)returnEmptyView, "@@:{CGRect=}l");

    hookClass("ETHomeCardGuideView",
        @selector(initWithFrame:), (IMP)returnEmptyView, "@@:{CGRect=}");

    hookClass("ETMineDragADView",
        @selector(initWithFrame:), (IMP)returnEmptyView, "@@:{CGRect=}");
    hookClass("ETMineDragADView",
        NSSelectorFromString(@"refreshADView"), (IMP)doNothing, "v@:");

    hookClass("ETWeatherDSPADViewCell",
        @selector(initWithFrame:), (IMP)returnEmptyView, "@@:{CGRect=}");
    hookClass("ETWeatherDSPADViewCell",
        NSSelectorFromString(@"setWeatherADBean:"), (IMP)doNothing, "v@:@");

    hookClass("ETRootCalendarFlowView",
        NSSelectorFromString(@"handleViewPanGesture:"), (IMP)doNothing, "v@:@");

    // numberOfSections返回0可能引起崩溃，改为返回原始结果的安全处理
    // 这里不hook，只hook广告相关的setAdXxx
    hookClass("ETCalendarView",
        @selector(initWithFrame:), (IMP)returnEmptyView, "@@:{CGRect=}");

    hookClass("ETOneDayCardView",
        @selector(initWithFrame:), (IMP)returnEmptyView, "@@:{CGRect=}");

    hookClass("ETVersionUpdateAlertView",
        @selector(initWithFrame:), (IMP)returnEmptyView, "@@:{CGRect=}");
    hookClass("ETVersionUpdateAlertView",
        NSSelectorFromString(@"setUpdate:"), (IMP)doNothing, "v@:@");

    hookClass("FLPatch",
        NSSelectorFromString(@"apiVersion"), (IMP)fakeApiVersion, "@@:");

    hookClass("FLAnimatedImageView",
        @selector(initWithFrame:), (IMP)returnEmptyView, "@@:{CGRect=}");
}

__attribute__((constructor))
static void zhwnl_init(void) {
    // 延迟1秒，等App类全部加载完再hook
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        doHook();
    });
}
