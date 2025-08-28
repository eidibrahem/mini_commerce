import java.util.Properties
plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.libas_collectiv.mini_commerce"
    compileSdk = flutter.compileSdkVersion

    ndkVersion = "29.0.13113456"

    // Java 17 + core library desugaring
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }
    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.libas_collectiv.mini_commerce"
        // Ensure minSdk >= 21
        minSdk = maxOf(flutter.minSdkVersion, 21)
        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: use a real signing config for release
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // 🔼 bumped to 2.1.5 to satisfy flutter_local_notifications
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    // other dependencies (if any) stay here
}


val lp = Properties().apply {
    load(rootProject.file("local.properties").inputStream())
}
android {
    defaultConfig {
        manifestPlaceholders["AIzaSyC-WYusA4tHyCV0HsD8dfVG-spfQMgC05U"] = lp.getProperty("AIzaSyC-WYusA4tHyCV0HsD8dfVG-spfQMgC05U") ?: ""
    }
}
