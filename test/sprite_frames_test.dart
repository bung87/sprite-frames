import '../lib/src/convert_plist_array.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {

    setUp(() {
    });

    test('Test convertPlistArray', () {
      expect(
          convertPlistArray('{{2,2},{240,240}}'),
          equals([
            [2, 2],
            [240, 240]
          ]));
    });
  });
}
