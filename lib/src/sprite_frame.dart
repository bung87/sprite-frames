import 'dart:ui' as ui;
import 'package:flame/components/component.dart';
import 'package:pvr_ccz/pvr_ccz.dart';
import 'package:image/image.dart' as libimage;
import './utils.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:io';

class SpriteFrame implements Component {
  static ui.Paint paint = ui.Paint()..color = Colors.white;
  bool _loaded = false;
  dynamic _texture; // image.Image or ui.Image
  String _textureFilename;

  /// CCSprite properties
  // Rect _rect;
  Rect _rectInPixels;
  // whether or not the rect of the frame is rotated ( x = x+width, y = y+height, width = height, height = width )
  bool _rotated;
  // Point _offset;
  Point _offsetInPixels;
  // Size _originalSize;
  Size _originalSizeInPixels;

  SpriteFrame.fromTextureFilename(String filename,
      {Rect rectInPixels, bool rotated, Point offset, Size originalSize}) {
    this
      .._textureFilename = filename
      .._rectInPixels = rectInPixels
      // .._offset = offset CC_POINT_PIXELS_TO_POINTS( offsetInPixels_ );
      // ..rect = CC_RECT_PIXELS_TO_POINTS rectInPixels div device ratio
      .._offsetInPixels = offset
      // ..offset =  CC_POINT_PIXELS_TO_POINTS offset
      .._originalSizeInPixels = originalSize
      .._rotated = rotated;
    // .._originalSize = CC_SIZE_PIXELS_TO_POINTS _originalSizeInPixels

    ui.decodeImageFromList(toPngBytesSync(filename), (image) {
      _texture = image;
      _loaded = true;
    });
  }

  SpriteFrame.fromTexture(dynamic texture,
      {Rect rectInPixels, bool rotated, Point offset, Size originalSize})
      : assert(rectInPixels != null &&
            rotated != null &&
            offset != null &&
            originalSize != null) {
    this
      // .._textureFilename = filename
      .._rectInPixels = rectInPixels
      // .._offset = offset CC_POINT_PIXELS_TO_POINTS( offsetInPixels_ );
      // ..rect = CC_RECT_PIXELS_TO_POINTS rectInPixels div device ratio
      .._offsetInPixels = offset
      // ..offset =  CC_POINT_PIXELS_TO_POINTS offset
      .._originalSizeInPixels = originalSize
      .._texture = texture
      .._rotated = rotated;
    // .._originalSize = CC_SIZE_PIXELS_TO_POINTS _originalSizeInPixels
    if (_texture is libimage.Image) {
      ui.decodeImageFromList(imageAsPngUintList(_texture), (image) {
        _texture = image;
        _loaded = true;
      });
    }
  }

  @override
  bool loaded() => _loaded;

  @override
  void render(ui.Canvas c) {
    if (!loaded()) {
      return;
    }
    var dst = Rect(
        _rectInPixels.left + _offsetInPixels.x,
        _rectInPixels.top + _offsetInPixels.y,
        _rectInPixels.width,
        _rectInPixels.height);

    c.drawImageRect(_texture, _rectInPixels, dst, paint);
  }

  @override
  void update(double t) {}
  @override
  void resize(ui.Size size) {
    
  }
  @override
  bool destroy() => false;

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
