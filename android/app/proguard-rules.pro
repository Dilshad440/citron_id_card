

#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn org.xmlpull.v1.XmlPullParser
-dontwarn org.xmlpull.v1.XmlSerializer
-keep class org.xmlpull.v1.* {*;}
-keep class androidx.appcompat.** { *; }


# --- Play Core (REQUIRED for Flutter release builds) ---
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# --- Flutter embedding safety ---
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**
