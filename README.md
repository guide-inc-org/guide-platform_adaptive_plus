# guide_platform_adaptive

A Flutter library providing adaptive platform utilities for iOS and Android.

## Features

- **IosStaleInsetCorrector** — Fixes stale `viewPadding.top` after orientation changes on iOS 26 ([flutter/flutter#180206](https://github.com/flutter/flutter/issues/180206))

## Installation

In your app's `pubspec.yaml`:

```yaml
dependencies:
  platform_adaptive:
  git:
    url: https://github.com/guide-inc-org/guide-platform_adaptive.git
    ref: v1.0
```

Then run:

```sh
flutter pub get
```

## Usage

Wrap your `Scaffold` (or any widget tree) with `IosStaleInsetCorrector`. Place it as high as possible so all screens are corrected at once.

```dart
import 'package:guide_platform_adaptive/ios_stale_inset_corrector.dart';

IosStaleInsetCorrector(
  version: iosVersion, // e.g. '26.0.1' — nullable, pass null on non-iOS
  child: Scaffold(
    ...
  ),
)
```

### How it works

| Scenario | Behavior |
|---|---|
| Non-iOS or version < 26 | Passes through child unchanged |
| Portrait → landscape (iOS 26.0) | Zeroes top inset the OS incorrectly carries forward |
| Landscape → portrait (all iOS 26.x) | Restores cached portrait top inset when OS reports 0 (stale) |

### Getting the iOS version

```dart
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

final info = await DeviceInfoPlugin().iosInfo;
final iosVersion = Platform.isIOS ? info.systemVersion : null;
```

## Requirements

- Flutter `>=3.10.0`
- Dart `>=3.10.7`
