import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties().apply {
    val localPropsFile = rootProject.file("local.properties")
    if (localPropsFile.exists()) {
        load(FileInputStream(localPropsFile))
    }
}

val keystoreProperties = Properties().apply {
    val keystorePropertiesFile = rootProject.file("key.properties")
    if (keystorePropertiesFile.exists()) {
        load(FileInputStream(keystorePropertiesFile))
    }
}

val flutterRoot = localProperties.getProperty("flutter.sdk")
require(!flutterRoot.isNullOrBlank()) {
    "Flutter SDK not found. Define location with flutter.sdk in the local.properties file."
}

android {
    namespace = "com.viewus.v_notes"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.viewus.v_notes"
        minSdk = 27
        targetSdk = 35

        multiDexEnabled = true
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        // Flutter/AGP current baseline is Java 17
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17

        // ✅ Required for flutter_local_notifications on minSdk < 26
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildFeatures {
        viewBinding = true
    }

    signingConfigs {
        // Use create(...) in Kotlin DSL
        create("release") {
            val alias = keystoreProperties.getProperty("keyAlias")
            val keyPass = keystoreProperties.getProperty("keyPassword")
            val storePath = keystoreProperties.getProperty("storeFile")
            val storePass = keystoreProperties.getProperty("storePassword")

            if (!storePath.isNullOrBlank()) {
                storeFile = file(storePath)
            }
            keyAlias = alias
            keyPassword = keyPass
            storePassword = storePass
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            isDebuggable = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
            // helpful when using multidex and large projects
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.multidex:multidex:2.0.1")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
