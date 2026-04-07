import 'package:flutter/material.dart';
import 'package:platform_adaptive_plus/utils/utils.dart';

/// iOS 26 workaround for stale `viewPadding.top` after orientation changes
/// (flutter/flutter#180206). Placed above every [Scaffold] so all screens are
/// corrected at once.
///
/// • Portrait → cache valid top inset; restore it when the OS reports 0 (stale).
/// • Landscape on iOS 26.0 → zero the top inset the OS incorrectly carries
///   forward from portrait.
/// • [didChangeMetrics] + [addPostFrameCallback] ensures the rebuild fires after
///   platform metrics have fully propagated.
class IosStaleInsetCorrector extends StatefulWidget {
  const IosStaleInsetCorrector({super.key, required this.version, required this.child});

  final String? version;
  final Widget child;

  @override
  State<IosStaleInsetCorrector> createState() => _IosStaleInsetCorrectorState();
}

class _IosStaleInsetCorrectorState extends State<IosStaleInsetCorrector> with WidgetsBindingObserver {
  double _cachedPortraitTopInset = 0.0;

  bool get _isIos26 => VersionUtils.isIos26(version: widget.version);

  int? get _minorVersion => VersionUtils.getMinorVersion(version: widget.version);

  @override
  void initState() {
    super.initState();
    if (_isIos26) WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    if (_isIos26) WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (!_isIos26) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isIos26) return widget.child;

    final mq = MediaQuery.of(context);

    final isPortrait = mq.orientation == Orientation.portrait;

    // Cache valid portrait top inset whenever the OS reports it correctly.
    if (isPortrait && mq.viewPadding.top >= 1.0) {
      _cachedPortraitTopInset = mq.viewPadding.top;
    }

    // Portrait stale (all iOS 26.x): after landscape → portrait the OS zeroes the top inset.
    final isPortraitStale = isPortrait && mq.viewPadding.top < 1.0 && _cachedPortraitTopInset >= 1.0;

    // Landscape stale (iOS 26.0 only): on the first portrait → landscape rotation
    // the OS carries the portrait inset forward instead of resetting to 0.
    final isLandscapeStale = !isPortrait && _minorVersion == 0 && mq.viewPadding.top > 0;

    final correctedTop = isPortraitStale
        ? _cachedPortraitTopInset
        : isLandscapeStale
        ? 0.0
        : mq.viewPadding.top;

    return MediaQuery(
      data: mq.copyWith(
        padding: mq.padding.copyWith(top: correctedTop),
        viewPadding: mq.viewPadding.copyWith(top: correctedTop),
      ),
      child: widget.child,
    );
  }
}
