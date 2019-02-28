import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Creates a [ScrollController] automatically disposed.
/// 
/// See also:
///   * [ScrollController]
final useScrollController = UseScrollController();

/// Using various [ScrollController]s.
///
/// See also:
///   * [call]
///   * [tracking]
class UseScrollController {
  /// Creates an [ScrollController] automatically disposed.
  ///
  /// [initialScrollOffset], [keepScrollOffset] and [debugLabel] are ignored after the first call.
  ///
  /// See also:
  ///   * [ScrollController]
  ScrollController call({
    String debugLabel,
    double initialScrollOffset = 0.0,
    bool keepScrollOffset = true,
    List keys,
  }) {
    return Hook.use(_ScrollControllerHook(
      debugLabel: debugLabel,
      initialScrollOffset: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      keys: keys,
    ));
  }

  /// Creates an [TrackingScrollController] automatically disposed.
  ///
  /// [initialScrollOffset], [keepScrollOffset] and [debugLabel] are ignored after the first call.
  ///
  /// See also:
  ///   * [TrackingScrollController]
  TrackingScrollController tracking({
    String debugLabel,
    double initialScrollOffset = 0.0,
    bool keepScrollOffset = true,
    List keys,
  }) {
     return Hook.use(_TrackingScrollControllerHook(
      debugLabel: debugLabel,
      initialScrollOffset: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      keys: keys,
    ));
  }
}

class _ScrollControllerHook extends Hook<ScrollController> {
  final String debugLabel;
  final double initialScrollOffset;
  final bool keepScrollOffset;

  const _ScrollControllerHook({
    this.debugLabel,
    this.initialScrollOffset,
    this.keepScrollOffset,
    List keys,
  }) : super(keys: keys);

  @override
  _ScrollControllerHookState createState() => _ScrollControllerHookState();
}

class _ScrollControllerHookState
    extends HookState<ScrollController, _ScrollControllerHook> {
  ScrollController _scrollController;

  @override
  void initHook() {
    _scrollController = ScrollController(
      initialScrollOffset: hook.initialScrollOffset,
      keepScrollOffset: hook.keepScrollOffset,
      debugLabel: hook.debugLabel,
    );
  }

  @override
  ScrollController build(BuildContext context) => _scrollController;

  @override
  void dispose() => _scrollController.dispose();
}

class _TrackingScrollControllerHook extends Hook<TrackingScrollController> {
  final String debugLabel;
  final double initialScrollOffset;
  final bool keepScrollOffset;

  const _TrackingScrollControllerHook({
    this.debugLabel,
    this.initialScrollOffset,
    this.keepScrollOffset,
    List keys,
  }) : super(keys: keys);

  @override
  _TrackingScrollControllerHookState createState() =>
      _TrackingScrollControllerHookState();
}

class _TrackingScrollControllerHookState
    extends HookState<TrackingScrollController, _TrackingScrollControllerHook> {
  TrackingScrollController _trackingScrollController;

  @override
  void initHook() {
    _trackingScrollController = TrackingScrollController(
      initialScrollOffset: hook.initialScrollOffset,
      keepScrollOffset: hook.keepScrollOffset,
      debugLabel: hook.debugLabel,
    );
  }

  @override
  TrackingScrollController build(BuildContext context) =>
      _trackingScrollController;

  @override
  void dispose() => _trackingScrollController.dispose();
}

/// Creates an [TextEditingController] automatically disposed.
///
/// Changing the [text] parameter automatically updates [TextEditingController.text].
///
/// See also:
///   * [TextEditingController]
TextEditingController useTextEditingController({
  String text,
  List keys,
}) {
  return Hook.use(_TextEditingControllerHook(
    text: text,
    keys: keys,
  ));
}

class _TextEditingControllerHook extends Hook<TextEditingController> {
  final String text;

  const _TextEditingControllerHook({
    this.text,
    List keys,
  }) : super(keys: keys);

  @override
  _TextEditingControllerHookState createState() =>
      _TextEditingControllerHookState();
}

class _TextEditingControllerHookState
    extends HookState<TextEditingController, _TextEditingControllerHook> {
  TextEditingController _textEditingController;

  @override
  void didUpdateHook(_TextEditingControllerHook oldHook) {
    if (hook.text != oldHook.text) {
      _textEditingController.text = hook.text;
    }
  }

  @override
  void initHook() => _textEditingController = TextEditingController(
        text: hook.text,
      );

  @override
  TextEditingController build(BuildContext context) => _textEditingController;

  @override
  void dispose() => _textEditingController.dispose();
}

/// Creates an [PageController] automatically disposed.
///
/// [initialPage], [viewportFraction] and [keepPage] are ignored after the first call.
///
/// See also:
///   * [PageController]
PageController usePageController({
  int initialPage = 0,
  double viewportFraction = 1.0,
  bool keepPage = true,
  List keys,
}) {
  return Hook.use(_PageControllerHook(
    initialPage: initialPage,
    viewportFraction: viewportFraction,
    keepPage: keepPage,
    keys: keys,
  ));
}

class _PageControllerHook extends Hook<PageController> {
  final int initialPage;
  final double viewportFraction;
  final bool keepPage;

  const _PageControllerHook({
    this.initialPage,
    this.viewportFraction,
    this.keepPage,
    List keys,
  }) : super(keys: keys);

  @override
  _PageControllerHookState createState() => _PageControllerHookState();
}

class _PageControllerHookState
    extends HookState<PageController, _PageControllerHook> {
  PageController _pageController;

  @override
  void initHook() => _pageController = PageController(
      initialPage: hook.initialPage,
      keepPage:  hook.keepPage,
      viewportFraction: hook.viewportFraction,
    );

  @override
  PageController build(BuildContext context) => _pageController;

  @override
  void dispose() => _pageController.dispose();
}