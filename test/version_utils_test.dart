import 'package:flutter_test/flutter_test.dart';
import 'package:platform_adaptive/utils/version_utils.dart';

void main() {
  group('VersionUtils.getMajorVersion', () {
    test('parses major from full version', () {
      expect(VersionUtils.getMajorVersion(version: '26.1.0'), 26);
    });

    test('parses major-only version', () {
      expect(VersionUtils.getMajorVersion(version: '17'), 17);
    });

    test('returns 0 for empty string', () {
      expect(VersionUtils.getMajorVersion(version: ''), 0);
    });

    test('returns 0 for non-numeric', () {
      expect(VersionUtils.getMajorVersion(version: 'abc.1'), 0);
    });

    test('returns null for null version', () {
      expect(VersionUtils.getMajorVersion(version: null), null);
    });
  });

  group('VersionUtils.getMinorVersion', () {
    test('parses minor from full version', () {
      expect(VersionUtils.getMinorVersion(version: '26.0.1'), 0);
    });

    test('parses minor version', () {
      expect(VersionUtils.getMinorVersion(version: '26.3'), 3);
    });

    test('returns 0 when minor is absent', () {
      expect(VersionUtils.getMinorVersion(version: '17'), 0);
    });

    test('returns 0 for non-numeric minor', () {
      expect(VersionUtils.getMinorVersion(version: '26.x.0'), 0);
    });

    test('returns null for null version', () {
      expect(VersionUtils.getMinorVersion(version: null), null);
    });
  });

  group('VersionUtils.getPatchVersion', () {
    test('parses patch from full version', () {
      expect(VersionUtils.getPatchVersion(version: '26.1.3'), 3);
    });

    test('returns 0 when patch is absent', () {
      expect(VersionUtils.getPatchVersion(version: '26.1'), 0);
    });

    test('returns 0 for non-numeric patch', () {
      expect(VersionUtils.getPatchVersion(version: '26.1.x'), 0);
    });

    test('returns null for null version', () {
      expect(VersionUtils.getPatchVersion(version: null), null);
    });
  });
}
