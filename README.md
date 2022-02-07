# SmallStrings
## Reducing localized .strings file sizes by 80%

The exact same as the original repo, but in a _better_ language. This brings zero performance cost and is a perfectly safe substitute for the Objective-C version.

### How it works

The library consists of a build-time minification step, and an iOS library:
- The minification tool converts the .strings files (of the form App.app/\*.lproj/Localizable.strings only) into a minified form. First, this tool eliminates key duplication by following the strategy from https://eisel.me/localization. This reduces the size by roughly 50%. Then, it keeps all these small files in a compressed form on disk, using LZFSE, reducing the size further. It also replaces the original language.lproj/Localizable.strings with placeholders that have one key-value pair each. This shows Apple that the same languages are still supported, so that it can pick the correct one based on the user's settings.
- An iOS library that replaces `NSLocalizedString` with a new version, `SSTStringForKey` that fetches values for keys from this minified format.

### Usage

#### Swift Package Manager

Add a package by selecting `File` → `Add Packages…` in Xcode’s menu bar and using this repo's URL:
```
https://github.com/EmergeTools/SmallStrings
```

Then add a Run Script build phase after the "Copy bundle resources" phase:
```
cd ${BUILD_DIR%/Build/*}/SourcePackages/checkouts/SmallStrings && ./localize.sh ${CODESIGNING_FOLDER_PATH} ${DERIVED_FILES_DIR}/SmallStrings.cache
```

#### Cocoapods

Add this to your Podfile:
```
pod 'SmallStrings'
```

Then add a Run Script build phase after the "Copy bundle resources" phase:
```
cd ${PODS_ROOT}/SmallStrings && ./localize.sh ${CODESIGNING_FOLDER_PATH} ${DERIVED_FILES_DIR}/SmallStrings.cache
```

Lastly, replace all usages of `NSLocalizedString(key, comment)` with `SSTStringForKey(key)`.

#### Manual

Add `Sources/SSTSmallStrings.swift` to your project. Create a `compress` binary via `swift build --configuration release` and copy the executable from `.build/release` to the same directory as `localize.{rb,sh}`. Add a build step with `cd /path/to/SmallStrings && ./localize.sh ${CODESIGNING_FOLDER_PATH} ${DERIVED_FILES_DIR}/SmallStrings.cache`. Lastly, replace all usages of `NSLocalizedString(key, comment)` with `SSTStringForKey(key)`.
