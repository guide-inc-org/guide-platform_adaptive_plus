import 'dart:io';

class VersionUtils {
  static int? getMajorVersion({required String? version}) {
    if (version == null) return null;
    final parts = version.split('.');
    return int.tryParse(parts.elementAtOrNull(0) ?? '') ?? 0;
  }

  static int? getMinorVersion({required String? version}) {
    if (version == null) return null;
    final parts = version.split('.');
    return int.tryParse(parts.elementAtOrNull(1) ?? '') ?? 0;
  }

  static int? getPatchVersion({required String? version}) {
    if (version == null) return null;
    final parts = version.split('.');
    return int.tryParse(parts.elementAtOrNull(2) ?? '') ?? 0;
  }

  static bool isIos26({required String? version}) => Platform.isIOS && getMajorVersion(version: version) == 26;
}
