group = "com.noob_coder.priv_kit"
version = "1.0"

buildscript {
    val kotlinVersion = "2.4.0"
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:9.3.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

plugins {
    id("com.android.library")
}

android {
    namespace = "com.noob_coder.priv_kit"

    // priv-core 0.12.0 requires compileSdk 37 or later.
    compileSdk = 37

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    // priv-core requires Android API 26 (Android 8.0) or later.
    defaultConfig {
        minSdk = 26
    }

    testOptions {
        unitTests {
            isIncludeAndroidResources = true
            all {
                it.useJUnitPlatform()

                it.outputs.upToDateWhen { false }

                it.testLogging {
                    events("passed", "skipped", "failed", "standardOut", "standardError")
                    showStandardStreams = true
                }
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    // priv-core exposes the runtime API bridged to Dart.
    //
    // Do not add priv-ui here: it requires compileSdk 37 and only provides the
    // Compose PrivilegeScaffold, which this plugin does not use. Apps that want
    // it must raise their own compileSdk and declare it themselves.
    implementation("io.github.priv-kit:priv-core:0.15.0")

    // priv-core calls are suspend functions; declare the runtime explicitly.
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.11.0")

    testImplementation("org.jetbrains.kotlin:kotlin-test")
    testImplementation("org.mockito:mockito-core:5.0.0")
}
