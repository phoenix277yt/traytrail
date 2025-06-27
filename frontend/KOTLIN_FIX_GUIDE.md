# Alternative Kotlin 2.0+ Fix Instructions

If the automatic fixes don't work, try this manual approach:

## Option 1: Downgrade Kotlin Plugin (Temporary Fix)
1. Create or edit `android/build.gradle.kts` to force a specific Kotlin version:

```kotlin
buildscript {
    ext.kotlin_version = '1.9.24'  // Use stable 1.x version
    dependencies {
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}
```

## Option 2: Environment Variable Approach
Set the Kotlin persistent directory as an environment variable:

```bash
export KOTLIN_PROJECT_PERSISTENT_DIR="$HOME/.gradle/kotlin"
```

Add this to your `.bashrc` or `.zshrc` for permanent setting.

## Option 3: Flutter Doctor Check
Sometimes the issue is with Flutter SDK configuration:

```bash
flutter doctor -v
flutter upgrade
```

## Option 4: Clean Everything
Complete clean and rebuild:

```bash
# Clean Flutter
flutter clean
rm -rf ~/.gradle/caches
rm -rf ~/.gradle/kotlin

# Recreate and rebuild
mkdir -p ~/.gradle/kotlin
flutter pub get
flutter run
```

## Option 5: Gradle Version Rollback
If all else fails, you can temporarily use an older Gradle version by editing `android/gradle/wrapper/gradle-wrapper.properties`:

```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.5-bin.zip
```

Then run:
```bash
cd android && ./gradlew wrapper --gradle-version 8.5
```
