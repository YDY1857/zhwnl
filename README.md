# zhwnl - 中华万年历去广告插件

纯 ObjC Runtime 实现，无需 Substrate/Theos 依赖，支持 arm64 + arm64e。

## 拦截内容

| 类别 | 拦截目标 |
|------|---------|
| 穿山甲SDK | CSJNativeAd / CSJNativeAdsManager / CSJNativeExpressAdManager / CSJNativeExpressRewardedVideoAd |
| 广点通SDK | GDTAdDLView / GDTAdParams / GDTAdServiceParams |
| 开屏广告 | ET3rdADSplash |
| 首页广告 | ETHomeCardGuideView |
| 拖拽广告 | ETMineDragADView |
| 天气广告 | ETWeatherDSPADViewCell |
| 日历广告 | ETCalendarView / ETOneDayCardView / ETRootCalendarFlowView |
| 黄历广告 | ETHuangliContentViewController |
| 更新弹窗 | ETVersionUpdateAlertView |
| 动图广告 | FLPatch / FLAnimatedImageView |

## 编译

Push 到 main 分支后 GitHub Actions 自动编译，在 Actions → Artifacts 下载 `zhwnl.dylib`。

## 安装

使用全能签或 TrollStore 将 `zhwnl.dylib` 注入中华万年历 IPA 后安装。
