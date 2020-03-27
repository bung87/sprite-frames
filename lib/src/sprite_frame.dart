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
      .._texture = decodePvrCcz(filename)
      .._rotated = rotated;
    // .._originalSize = CC_SIZE_PIXELS_TO_POINTS _originalSizeInPixels
    _loaded = true;
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
    //  _texture = new Image.memory((_texture as libimage.Image).getBytes());

    // ui.decodeImageFromList((_texture as libimage.Image).getBytes(), (image) {

    //     _texture = image;
    //     _loaded = true;
    //   });

    var img = (_texture as libimage.Image);
    var bb = BytesBuilder();
    bb.add(libimage.encodePng(img));

    ui.decodeImageFromList(bb.takeBytes(), (image) {
      _texture = image;
      _loaded = true;
    });
  }

  @override
  bool loaded() => _loaded;

  @override
  void render(ui.Canvas c) {
    var dst = Rect(
        _rectInPixels.left + _offsetInPixels.x,
        _rectInPixels.top + _offsetInPixels.y,
        _rectInPixels.width,
        _rectInPixels.height);
    if (_texture is ui.Image) {
      c.drawImageRect(_texture, _rectInPixels, dst, paint);
    } 
    // else if (_texture is libimage.Image) {
    //   var img = (_texture as libimage.Image);
    //   var bb = BytesBuilder(copy: true);
    //   bb.add(libimage.encodePng(img));
    //   // ui.instantiateImageCodec(bb.takeBytes(),targetWidth:img.width,targetHeight:img.height).then((codec)  {
    //   //   codec.getNextFrame().then((frame) {
    //   //     c.drawImageRect(frame.image, _rectInPixels, dst, paint);

    //   //   });
    //   // });
    //   ui.decodeImageFromList(bb.takeBytes(), (image) {
    //     c.drawImageRect(image, _rectInPixels, dst, paint);
    //   });
    //   // libimage.encodePng(libimage.decodeImage(img.getBytes()))
    //   // var format = (_texture as libimage.Image).channels == libimage.Channels.rgba ? libimage.Format.rgba : ui.Format.rgb;
    //   // ui.decodeImageFromList(img.getBytes(), (image) {
    //   //   c.drawImageRect(image, _rectInPixels, dst, paint);
    //   // });
    // }
  }

  @override
  void update(double t) {}
  @override
  void resize(ui.Size size) {}
  @override
   bool destroy() => false;

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
