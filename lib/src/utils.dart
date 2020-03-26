import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:convert';

List convertPlistArray(String s) {
  var b = s.replaceAll('{', '[').replaceAll('}', ']');
  var l = jsonDecode(b) as List;
  return l;
}

class Point extends math.Point {
  const Point(x, y) : super(x, y);
  static Point fromString(String s) {
    var l = convertPlistArray(s);
    return Point(l[0], l[1]);
  }
}

class Size extends ui.Size {
  const Size(double width, double height) : super(width, height);
  static Size fromString(String s) {
    var l = convertPlistArray(s);
    return Size(l[0], l[1]);
  }
}

class Rect extends math.Rectangle {
  const Rect(left, top, width, height) : super(left, top, width, height);
  static Rect fromString(String s) {
    var l = convertPlistArray(s);
    return Rect(l[0], l[1], l[2], l[3]);
  }
}
