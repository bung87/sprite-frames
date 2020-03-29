import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:plist/plist.dart' as plist;

class Point extends math.Point {
  const Point(x, y) : super(x, y);
  static Point fromString(String s) {
    var l = plist.convertPlistArray(s);
    return Point(l[0], l[1]);
  }

  Point operator /(double ratio) {
    return Point(x / ratio, y / ratio);
  }
}

class Size {
  double width, height;
  // const Size(num width, num height) : super(width, height);
  Size(this.width, this.height);
  static Size fromString(String s) {
    var l = plist.convertPlistArray(s);
    return Size(l[0] + .0, l[1] + .0);
  }

  Size operator /(double ratio) {
    return Size(width / ratio, height / ratio);
  }
}

class Rect extends ui.Rect {
  const Rect(left, top, width, height)
      : super.fromLTWH(left, top, width, height);
  static Rect fromString(String s) {
    var l = plist.convertPlistArray(s);
    return Rect(l[0][0] + .0, l[0][1] + .0, l[1][0] + .0, l[1][1] + .0);
  }

  Rect operator /(double ratio) {
    return Rect(left / ratio, top / ratio, right / ratio, bottom / ratio);
  }
}

