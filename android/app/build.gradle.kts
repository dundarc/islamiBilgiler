plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "tr.com.dundarc.islamiBilgiler.islamibilgiler"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "29.0.13599879"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // --- TÜRKÇE KARAKTER SORUNU İÇİN KESİN ÇÖZÜM ---
    // Bu blok, Gradle'ın tüm derleme işlemlerinde UTF-8 kullanmasını sağlar.
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        kotlinOptions {
            freeCompilerArgs += "-Xjvm-default=all"
        }
    }

    tasks.withType<JavaCompile> {
        options.encoding = "UTF-8"
    }
    // --- ÇÖZÜM SONU ---

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "tr.com.dundarc.islamiBilgiler.islamibilgiler"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = 36
        versionCode = 2
        versionName = "2.0"
    }

    buildTypes {
        release {
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
    // 2. ADIM: Bu satırı ekliyoruz
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}