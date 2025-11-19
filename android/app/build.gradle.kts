import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { localProperties.load(it) }
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode")?.toIntOrNull() ?: 1
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

android {
    namespace = "com.aressa.sunny" // Sesuaikan dengan package name lu
    compileSdk = 35 // Update ke 35

    compileOptions {
        // ENABLE DESUGARING - INI PENTING!
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    sourceSets {
        getByName("main") {
            java.srcDir("src/main/kotlin")
        }
    }

    defaultConfig {
        applicationId = "com.aressa.sunny" // Sesuaikan dengan package name lu
        minSdk = 21 // Minimal SDK 21
        targetSdk = 35 // Target SDK 35
        versionCode = flutterVersionCode
        versionName = flutterVersionName
        
        // Tambah multiDex jika diperlukan
        multiDexEnabled = true
    }

    buildTypes {
        getByName("release") {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // CORE LIBRARY DESUGARING - INI YANG PENTING!
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
