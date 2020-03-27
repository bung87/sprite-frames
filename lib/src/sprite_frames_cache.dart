
import './plist.dart';
import 'package:flame/flame.dart';
import 'package:pvr_ccz/pvr_ccz.dart';
import 'package:path/path.dart' as p;
import './utils.dart' as utils;
import 'package:image/image.dart' hide Point;
import './sprite_frame.dart';

final SpriteFrames spriteFrameCache = SpriteFrames._private();

/// cache layer container
class SpriteFrames {
  final Map<String, SpriteFrame> _spriteFrames = {};
  utils.Rect src;

  /// plist files Set
  final Set<String> _loadedFilenames = {};
  SpriteFrames._private() {}

  /// always get the singleton instance.
  factory SpriteFrames() {
    return spriteFrameCache;
  }

  /// add SpriteFrames with plist file
  Future<void> addSpriteFramesWithFile(String filename) async {
    var plist = await Flame.bundle.loadString('assets/' + filename);
    var data = parse(plist);
    var texturePath;
    var metaData = (data as Map)['metadata'];
    if (metaData != null) {
      texturePath = (metaData as Map)['textureFileName'];
    }
    if (texturePath != null) {
      texturePath = p.join(p.dirname(filename), texturePath);
    } else {
      /// assuming image store same dir as plist
      texturePath = p.withoutExtension(filename) + '.png';
    }
    var byteData = await Flame.bundle.load(p.join('assets', texturePath));
    var img = decodePvrCczWithByteData(byteData);
    _addSpriteFrames(data, textureReference: img);
    _loadedFilenames.add(filename);
  }

  /// data param storing frame info in plist
  void _addSpriteFrames(data,
      {String textureFilename, Image textureReference}) {
    var metaData = (data as Map)['metadata'];
    var frames = data['frames'];
    int format;
    if (metaData != null) {
      format = metaData['format'];
    }

    // SpriteFrame info
    utils.Rect rectInPixels;
    bool isRotated;
    utils.Point frameOffset;
    utils.Size originalSize;

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
            var frameRect = frame['frame'];
            var rotated = false;
            if (format == 2) {
              rotated = frame['rotated'];
            }
            var offset = utils.Point.fromString(frame['offset']);
            var size = utils.Size.fromString(frame['sourceSize']);

            // set frame info
            rectInPixels = utils.Rect.fromString(frameRect);
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

  SpriteFrame spriteFrameByName(String name) {
    var frame;
    if (_spriteFrames.containsKey(name)) {
      frame = _spriteFrames[name];
    } else {
      // try alias dictionary working when frame format == 3 that has aliases field.
    }
    return frame;
  }

  void removeSpriteFrames() {
    _spriteFrames.clear();
    // _spriteFramesAliases
    _loadedFilenames.clear();
  }

  @override
  String toString() {
    return _spriteFrames.toString();
  }
}
