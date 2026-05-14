#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 返回nil的通用替换实现
static id returnNil(id self, SEL _cmd, ...) {
    return nil;
}

// 返回0的通用替换实现
static NSInteger returnZero(id self, SEL _cmd, ...) {
    return 0;
}

// 空实现
static void doNothing(id self, SEL _cmd, ...) {
    return;
}

// 返回 apiVersion = "0"
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

__attribute__((constructor))
static void zhwnl_init(void) {

    // ── 穿山甲 CSJ ──────────────────────────────
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

    // ── 广点通 GDT ──────────────────────────────
    hookClass("GDTAdDLView",
        @selector(initWithFrame:), (IMP)returnNil, "@@:{CGRect=}");
    hookClass("GDTAdDLView",
        @selector(setAdConfig:), (IMP)doNothing, "v@:@");
    hookClass("GDTAdDLView",
        NSSelectorFromString(@"setAdslot:"), (IMP)doNothing, "v@:@");

    hookClass("GDTAdParams",
        @selector(init), (IMP)returnNil, "@@:");

    hookClass("GDTAdServiceParams",
        @selector(init), (IMP)returnNil, "@@:");

    // ── 万年历开屏广告 ───────────────────────────
    hookClass("ET3rdADSplash",
        @selector(initWithFrame:), (IMP)returnNil, "@@:{CGRect=}");
    hookClass("ET3rdADSplash",
        NSSelectorFromString(@"initWithFrame:withType:"), (IMP)returnNil, "@@:{CGRect=}l");

    // ── 首页引导广告 ─────────────────────────────
    hookClass("ETHomeCardGuideView",
        @selector(initWithFrame:), (IMP)returnNil, "@@:{CGRect=}");

    // ── 拖拽广告 ─────────────────────────────────
    hookClass("ETMineDragADView",
        @selector(initWithFrame:), (IMP)returnNil, "@@:{CGRect=}");
    hookClass("ETMineDragADView",
        NSSelectorFromString(@"refreshADView"), (IMP)doNothing, "v@:");

    // ── 天气广告 Cell ────────────────────────────
    hookClass("ETWeatherDSPADViewCell",
        @selector(initWithFrame:), (IMP)returnNil, "@@:{CGRect=}");
    hookClass("ETWeatherDSPADViewCell",
        NSSelectorFromString(@"setWeatherADBean:"), (IMP)doNothing, "v@:@");

    // ── 日历滑动广告手势 ──────────────────────────
    hookClass("ETRootCalendarFlowView",
        NSSelectorFromString(@"handleViewPanGesture:"), (IMP)doNothing, "v@:@");

    // ── 黄历内容广告 Section ──────────────────────
    hookClass("ETHuangliContentViewController",
        @selector(numberOfSectionsInTableView:), (IMP)returnZero, "l@:@");

    // ── 日历 View 广告 ────────────────────────────
    hookClass("ETCalendarView",
        @selector(initWithFrame:), (IMP)returnNil, "@@:{CGRect=}");

    // ── 单日卡片广告 ──────────────────────────────
    hookClass("ETOneDayCardView",
        @selector(initWithFrame:), (IMP)returnNil, "@@:{CGRect=}");

    // ── 版本更新弹窗 ──────────────────────────────
    hookClass("ETVersionUpdateAlertView",
        @selector(initWithFrame:), (IMP)returnNil, "@@:{CGRect=}");
    hookClass("ETVersionUpdateAlertView",
        NSSelectorFromString(@"setUpdate:"), (IMP)doNothing, "v@:@");

    // ── 广告动图组件 ──────────────────────────────
    hookClass("FLPatch",
        NSSelectorFromString(@"apiVersion"), (IMP)fakeApiVersion, "@@:");

    hookClass("FLAnimatedImageView",
        @selector(initWithFrame:), (IMP)returnNil, "@@:{CGRect=}");
}
