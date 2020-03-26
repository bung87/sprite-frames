import 'package:flame/sprite.dart';
import 'dart:ui';
import './plist.dart';
import 'dart:async';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:path/path.dart' as p;
import './utils.dart';
import 'package:image/image.dart' hide Point;
import './sprite_frame.dart';

/// cache layer container
class SpriteFrames {
  String filename;
  final Map<String, SpriteFrame> _spriteFrames = {};
  Paint paint = BasicPalette.white.paint;
  Rect src;
  Set<String> _loadedFilenames;
  SpriteFrames(this.filename) {
    _load();
  }

  _load() async {
    var plist = await Flame.bundle.loadString('assets/' + filename);
    var data = parse(plist);
    var texturePath;
    var metaData = data ?? ['metadata'];
    if (metaData) {
      texturePath = (metaData as Map)['textureFileName'];
    }
    if (texturePath) {
      texturePath = p.dirname(filename);
    } else {
      texturePath = p.withoutExtension(filename) + 'png';
    }
    _addSpriteFrames(data, textureFilename: texturePath);
  }

  void _addSpriteFrames(data,
      {String textureFilename, Image textureReference}) {
    var metaData = data ?? ['metadata'];
    var frames = data['frames'];
    int format;
    if (metaData != null) {
      format = metaData['format'];
    }

    // SpriteFrame info
    Rect rectInPixels;
    bool isRotated;
    Point frameOffset;
    Size originalSize;

    frames.forEach((k, frame) {
      var spriteFrame;
      switch (format) {
        case 0:
          {
            // Todo
            throw UnimplementedError();
          }
          break;
        case 1:
        case 2:
          {
            var frameData = frame['frame'];
            var rotated = false;
            if (format == 2) {
              rotated = frameData['rotated'];
            }
            var offset = Point.fromString(frameData['offset']);
            var size = Size.fromString(frameData['sourceSize']);

            // set frame info
            rectInPixels = frameData;
            isRotated = rotated;
            frameOffset = offset;
            originalSize = size;
          }
          break;
        case 3:
          {
            // Todo
            throw UnimplementedError();
          }
          break;
      }

      if (textureFilename != null) {
        spriteFrame = SpriteFrame.fromTextureFilename(textureFilename,
            rectInPixels: rectInPixels,
            rotated: isRotated,
            offset: frameOffset,
            originalSize: originalSize);
      } else if (textureReference != null) {
        spriteFrame = SpriteFrame.fromTexture(textureReference,
            rectInPixels: rectInPixels,
            rotated: isRotated,
            offset: frameOffset,
            originalSize: originalSize);
      }
      _spriteFrames[k] = spriteFrame;
    });
  }
}
