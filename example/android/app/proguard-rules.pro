# 保留规则简介
# https://developer.android.google.cn/topic/performance/app-optimization/keep-rules-overview?hl=zh-cn

#-keep class io.flutter.app.** { *; }
#-keep class io.flutter.plugin.** { *; }
#-keep class io.flutter.util.** { *; }
#-keep class io.flutter.view.** { *; }
#-keep class io.flutter.** { *; }
#-keep class io.flutter.plugins.** { *; }

-dontwarn com.android.org.conscrypt.**