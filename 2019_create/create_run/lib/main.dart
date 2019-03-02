import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:convert';
import 'hooks.dart';

h(f) => HookBuilder(builder: f);
c(v) => Color(v);
du(m) => Duration(milliseconds: m);
ic(i, c) => Icon(i, color: c);
ei(v) => EdgeInsets.all(v ?? 0);
of([x = 0.0, y = 0.0]) => Offset(x, y);
lb(t, s, c, w) => Text(t,
    textAlign: TextAlign.center,
    style: TextStyle(color: c, fontSize: s, fontWeight: FontWeight.values[w]));
sp() => SizedBox(height: m1, width: m2 / 2);
flex(w, [d = 0, m = 2, c = 2, l = 1]) => Flex(
    direction: Axis.values[d],
    mainAxisAlignment: MainAxisAlignment.values[m],
    crossAxisAlignment: CrossAxisAlignment.values[c],
    textDirection: TextDirection.values[l],
    children: w);
cr(c, [i, m, h, w, b, r]) => Container(
    margin: ei(m),
    padding: ei(i),
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(r ?? 0), color: b),
    height: h,
    width: w,
    child: c);
tr(o, x, w) =>
    Opacity(opacity: o, child: Transform.translate(offset: of(x), child: w));
clerp(t) => Color.lerp(blue, green, t);
sca(b, i, t, w) => Scaffold(
    backgroundColor: b,
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    floatingActionButton:
        FloatingActionButton(child: ic(i, dark), onPressed: t),
    body: w);
var io = Curves.easeInOut;
var m1 = 24.0;
var m2 = 12.0;
var light = Colors.white;
var dark = c(0xFF323149);
var sDark = c(0xFF383B50);
var green = c(0xFF48FF9C);
var blue = c(0xFF48DEFF);
var halo = (c, r, x, y, s) => RadialGradient(
        colors: [c, c.withAlpha(0)],
        radius: r / s.height,
        center: Alignment((x - 0.5) * 2, (y - 0.5) * 2))
    .createShader(of() & s);
main() => runApp(MaterialApp(theme: ThemeData.dark(), home: home()));
run(c) => h((c) {
      final sm = useMemoized(() => Stream.periodic(du(1000), (i) => i));
      final i = useStream(sm).data ?? 0;
      return sca(
          dark.withAlpha(240),
          Icons.close,
          () => Navigator.pop(c),
          flex(<Widget>[
            lb('$i', 52.0, light, 8),
            lb('${(i * 0.003).toStringAsFixed(3)}km', 44.0, green, 8),
          ], 1, 2, 3)) as Widget;
    });
home() => h((c) => sca(
      light,
      Icons.directions_run,
      () => Navigator.push(
          c,
          PageRouteBuilder(
              opaque: false,
              transitionsBuilder: (c, a, _, w) => tr(a.value, 0.0, w),
              transitionDuration: du(500),
              pageBuilder: (c, a, aa) => run(c))),
      FutureBuilder(
          future: useMemoized(() async =>
              jsonDecode(await rootBundle.loadString('data/runs.json'))),
          builder: (c, runs) => tabs(runs.data ?? [])),
    ) as Widget);
tabs(d) => h((c) {
      var sc = useScrollController.tracking();
      var p = usePageController(initialPage: 1);
      useListenable(p);
      var pi = p.hasClients ? p.page ?? 0 : 1;
      var pii = 1 - pi;
      return LayoutBuilder(
          builder: (c, s) => PageView.builder(
              reverse: true,
              controller: p,
              itemCount: 2,
              itemBuilder: (c, i) => (i == 0)
                  ? list(d, sc, "Stats", false, (x) => detail(x, pii), p, s,
                      -1.25 * pi, pii)
                  : list(d, sc, "Runs", true, (x) => overview(x, pi), p, s,
                      -1.05 * pii, 1.0)));
    });
list(it, c, h, l, b, p, s, x, o) => tr(
    o,
    s.maxWidth * x,
    ListView.builder(
      controller: c,
      itemCount: it.length + 1,
      itemBuilder: (c, i) => i == 0 ? header(h, l, p) : b(it[i - 1]),
    ));
header(t, l, p) => cr(
    flex(<Widget>[
      lb(t, 2 * m1, dark, 8),
      Spacer(),
      IconButton(
          onPressed: () =>
              p.animateToPage(l ? 0 : 1, curve: io, duration: du(300)),
          icon: ic(l ? Icons.arrow_forward : Icons.arrow_back, dark))
    ], 0, 2, 2, l ? 1 : 0),
    m1,
    0.0,
    100.0);
overview(i, aa) => h((c) {
      var ac = useAnimationController(duration: du(3000));
      useEffect(() {
        ac.repeat();
      });
      var a = useAnimation(ac);
      var color = clerp(((a - 0.5) * 2.0).abs());
      return cr(
          flex(<Widget>[
            lb(i["date"], m2, light, 3),
            sp(),
            line(i, a),
            sp(),
            flex(<Widget>[
              ic(Icons.place, color),
              lb(i["place"], m2, light, 4),
            ]),
            lb(i["dst"], 36.0, light, 8),
            lb(i["duration"], m1, color, 7),
          ], 1),
          0.0,
          m1,
          340.0,
          null,
          dark,
          m1) as Widget;
    });
detail(item, a) => cr(
    flex(
        (item["stats"] as List)
            .expand<Widget>(
                (s) => [lb(s[0], m2, blue, 3), lb(s[1], m2, light, 8), sp()])
            .toList()
              ..add(graph(item, a)),
        1),
    0.0,
    m1,
    340.0,
    null,
    sDark,
    m1);
graph(item, a) => flex(
    (item["wayp"] as List)
        .expand<Widget>((x) => [
              sp(),
              cr(sp(), 0.0, 0.0, 4.0 + x * io.transform(a) * 34.0, 4.0,
                  clerp(x * a), 2.0)
            ])
        .skip(1)
        .toList(),
    0,
    2,
    1);
line(item, a) =>
    cr(CustomPaint(painter: LP(item, io.transform(a))), 3.0, 0.0, 150.0, 150.0);

class LP extends CustomPainter {
  var i;
  var a;
  LP(this.i, this.a);
  void paint(c, s) {
    var p = parseSvgPathData(i["path"]);
    np() => Paint()
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    c
      ..translate((s.width / 2) - (p.getBounds().width / 2), 4)
      ..drawPath(p, np()..color = Colors.black26)
      ..translate(0, -4)
      ..drawPath(p, np()..color = blue);
    var ps = i["points"] as List;
    var h = ps.lastWhere((x) => a > x[0] && a <= (x[0] + x[1]),
        orElse: () => ps.last);
    var hp = Offset.lerp(of(h[2], h[3]), of(h[4], h[5]), (a - h[0]) / h[1]);
    ha(x, r) => c.drawPath(
        p, np()..shader = halo(x, r, hp.dx / s.width, hp.dy / s.width, s));
    ha(green, 130.0);
    ha(light, 32.0);
  }

  shouldRepaint(LP o) => this.a != o.a;
  shouldRebuildSemantics(o) => false;
}
