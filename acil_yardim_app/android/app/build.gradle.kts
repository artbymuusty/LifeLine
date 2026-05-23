// android/app/build.gradle.kts

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.acil_yardim_app"

    // ↑↑↑ BURAYI GÜNCELLEDİK: compileSdkVersion en az 35 olmalı ↑↑↑
    compileSdk = 35
    ndkVersion = "27.0.12077973"
    

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.acil_yardim_app"
        // minSdk olduğu gibi bırakılabilir
        minSdk = flutter.minSdkVersion
        // ↑↑↑ BURAYI GÜNCELLEDİK: targetSdkVersion en az 35 olmalı ↑↑↑
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // AndroidX AppCompat
    implementation("androidx.appcompat:appcompat:1.6.1")
    // Material Components
    implementation("com.google.android.material:material:1.9.0")
    // Android 12+ SplashScreen API
    implementation("androidx.core:core-splashscreen:1.0.0")
}
