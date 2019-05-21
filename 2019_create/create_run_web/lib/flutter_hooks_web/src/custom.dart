
part of 'hooks.dart';

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
        keepPage: hook.keepPage,
        viewportFraction: hook.viewportFraction,
      );

  @override
  PageController build(BuildContext context) => _pageController;

  @override
  void dispose() => _pageController.dispose();
}

/// Defines how a value is interpolated between a [from] value and a [to] value
/// at the given [time].
typedef T TweenLerp<T extends dynamic>(T from, T to, double time);

/// Creates a [Tween] for interpolating a value.
///
/// See also:
///   * [Tween]
final useTween = UseTween();

/// Using various [Tween]s.
///
/// See also:
///   * [call]
///   * [color]
class UseTween {
  /// Creates a new [Tween] for interpolating a [value] with the previous one according
  /// to a [lerp] function.
  ///
  /// Each time the [value] changed, a new [Tween] is returned with its [Tween.begin] affected to
  /// the previous [value] and its [Tween.end] affected to the current [value].
  ///
  /// If no [lerp] function is given, a default [Tween] is used.
  ///
  /// At first call, [Tween.begin] and [Tween.end] have the initial [value].
  ///
  /// See also:
  ///   * [Tween]
  ///   * [TweenLerp]
  Tween<T> call<T extends dynamic>(T value, {TweenLerp<T> lerp}) {
    return Hook.use(_TweenHook<T>(
      value: value,
      builder: lerp == null ? null : (begin,end) => _CustomTween(begin: begin, end: end, lerp: lerp),
    ));
  }

  /// Creates a new [Tween] for interpolating a [Color].
  ///
  /// See also:
  ///   * [call]
  ///   * [Color]
  Tween<Color> color(Color value) {
    return Hook.use(_TweenHook<Color>(
      value: value,
      builder: (begin, end) => ColorTween(begin: begin, end: end),
    ));
  }

  /// Creates a new [Tween] for interpolating an [EdgeInsets].
  ///
  /// See also:
  ///   * [call]
  ///   * [EdgeInsets]
  Tween<EdgeInsets> edgeInsets(EdgeInsets value) {
    return Hook.use(_TweenHook<EdgeInsets>(
      value: value,
      builder: (begin, end) => EdgeInsetsTween(begin: begin, end: end),
    ));
  }

  /// Creates a new [Tween] for interpolating a [TextStyle].
  ///
  /// See also:
  ///   * [call]
  ///   * [TextStyle]
  Tween<TextStyle> textStyle(TextStyle value) {
    return Hook.use(_TweenHook<TextStyle>(
      value: value,
      builder: (begin, end) => TextStyleTween(begin: begin, end: end),
    ));
  }

  /// Creates a new [Tween] for interpolating a [Border].
  ///
  /// See also:
  ///   * [call]
  ///   * [Border]
  Tween<Border> border(Border value) {
    return Hook.use(_TweenHook<Border>(
      value: value,
      builder: (begin, end) => BorderTween(begin: begin, end: end),
    ));
  }

  /// Creates a new [Tween] for interpolating an [Alignment].
  ///
  /// See also:
  ///   * [call]
  ///   * [Alignment]
  Tween<Alignment> alignment(Alignment value) {
    return Hook.use(_TweenHook<Alignment>(
      value: value,
      builder: (begin, end) => AlignmentTween(begin: begin, end: end),
    ));
  }

  /// Creates a new [Tween] for interpolating an [Alignment].
  ///
  /// See also:
  ///   * [call]
  ///   * [BorderRadius]
  Tween<BorderRadius> borderRadius(BorderRadius value) {
    return Hook.use(_TweenHook<BorderRadius>(
      value: value,
      builder: (begin, end) => BorderRadiusTween(begin: begin, end: end),
    ));
  }

  /// Creates a new [Tween] for interpolating an [BoxConstraints].
  ///
  /// See also:
  ///   * [call]
  ///   * [BoxConstraints]
  Tween<BoxConstraints> boxConstraints(BoxConstraints value) {
    return Hook.use(_TweenHook<BoxConstraints>(
      value: value,
      builder: (begin, end) => BoxConstraintsTween(begin: begin, end: end),
    ));
  }

  /// Creates a new [Tween] for interpolating an [Size].
  ///
  /// See also:
  ///   * [call]
  ///   * [Size]
  Tween<Size> size(Size value) {
    return Hook.use(_TweenHook<Size>(
      value: value,
      builder: (begin, end) => SizeTween(begin: begin, end: end),
    ));
  }

  /// Creates a new [Tween] for interpolating an [Rect].
  ///
  /// See also:
  ///   * [call]
  ///   * [Rect]
  Tween<Rect> rect(Rect value) {
    return Hook.use(_TweenHook<Rect>(
      value: value,
      builder: (begin, end) => RectTween(begin: begin, end: end),
    ));
  }

  /// Creates a new [Tween] for interpolating an [RelativeRect].
  ///
  /// See also:
  ///   * [call]
  ///   * [RelativeRect]
  Tween<RelativeRect> relativeRect(RelativeRect value) {
    return Hook.use(_TweenHook<RelativeRect>(
      value: value,
      builder: (begin, end) => RelativeRectTween(begin: begin, end: end),
    ));
  }
}

typedef Tween<T> _TweenBuilder<T extends dynamic>(T begin, T end);

class _TweenHook<T> extends Hook<Tween<T>> {
  final T value;
  final _TweenBuilder<T> builder;

  const _TweenHook({
    this.value,
    this.builder,
    List keys,
  }) : super(keys: keys);

  @override
  _TweenHookState<T> createState() => _TweenHookState<T>();
}

class _CustomTween<T extends dynamic> extends Tween<T> {
  final TweenLerp<T> _lerp;
  _CustomTween({T begin, T end, TweenLerp<T> lerp})
      : _lerp = lerp,
        super(begin: begin, end: end);

  @override
  T lerp(double t) => this._lerp(begin, end, t);
}

class _TweenHookState<T> extends HookState<Tween<T>, _TweenHook<T>> {
  Tween<T> _tween;

  Tween<T> _createTween(T begin) {
    if (hook.builder != null) {
      return hook.builder(begin, hook.value);
    }

    return Tween<T>(begin: begin, end: hook.value);
  }

  @override
  void initHook() => _tween = _createTween(hook.value);

  @override
  void didUpdateHook(_TweenHook<T> oldHook) {
    if (hook.value != oldHook.value ||
        hook.builder != oldHook.builder) {
      _tween = _createTween(oldHook.value);
    }
  }

  @override
  Tween<T> build(BuildContext context) => _tween;
}

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

