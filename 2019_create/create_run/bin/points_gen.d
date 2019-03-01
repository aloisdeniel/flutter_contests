import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:path_parsing/path_parsing.dart';

Future main() async {
  final inFile = File('bin/runs.json');
  final outFile = File('data/runs.json');

  final json = jsonDecode(await inFile.readAsString());

  for (var item in json) {
    final SvgPathStringSource parser = SvgPathStringSource(item["path"]);
    final GenProxy path = GenProxy();
    final SvgPathNormalizer normalizer = SvgPathNormalizer();
    for (PathSegmentData seg in parser.parseSegments()) {
      normalizer.emitSegment(seg, path);
    }

    path.update(item);
  }

  await outFile.writeAsString(jsonEncode(json));
}

 String printDuration(Duration d) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }
    String twoDigitHours = twoDigits(d.inHours);
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(Duration.minutesPerHour));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(Duration.secondsPerMinute));

    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }


class GenProxy extends PathProxy {
  GenProxy();

  Point last, first;
  final List<Point> _points = [];

  void update(dynamic item) {

    var totalDst = 0.0;
    for (var i = 0; i < _points.length - 1; i++) {
      final from = _points[i];
      final to = _points[i + 1];
      final dst = from.distanceTo(to);
      totalDst += dst;
    }

    final points = <List<double>>[];
    final r = Random();

    var startTime = 0.0;
    for (var i = 0; i < _points.length - 1; i++) {
      final from = _points[i];
      final to = _points[i + 1];
      final dst = from.distanceTo(to);
      final duration = dst / totalDst;

      points.add([
        startTime,
        duration,
        from.x,
        from.y,
        to.x,
        to.y
      ]);

      startTime += duration;
    }
    final speed = item["speed"];
    final kms = totalDst / 50.0;
    final durationMin = speed * 50 * (kms / 10);
    final avg = durationMin / kms;
    final duration = Duration(minutes: durationMin.toInt(), seconds: r.nextInt(60));
    item["duration"] = printDuration(duration);
    item["dst"] = "${kms.toStringAsFixed(1)}km";
    item["points"] = points;
    item["stats"] = [
      [ "Location",  item["place"]],
      [ "Distance",  item["dst"]],
      [ "Duration",  item["duration"]],
      [ "Average speed",  "${avg.toStringAsFixed(2)}min/km"],
      [ "Weather",  item["weather"]],
    ];
  }

  void _updateLast(Point p) {
    last = p;
    first ??= last;
  }

  void _addPoint(Point p) => _points.add(p);

  @override
  void close() {
    first = null;
    last = first;
  }

  @override
  void cubicTo(
      double x1, double y1, double x2, double y2, double x3, double y3) {
    final p = Point(x3, y3);
    _addPoint(p);
    _updateLast(p);
  }

  @override
  void lineTo(double x, double y) {
    final p = Point(x, y);
    _addPoint(p);
    _updateLast(p);
  }

  @override
  void moveTo(double x, double y) {
    final p = Point(x, y);
    _addPoint(p);
    _updateLast(p);
  }
}
