import 'dart:ui' as ui;
import 'package:flame/components/component.dart';
import 'package:pvr_ccz/pvr_ccz.dart';
import 'package:image/image.dart' as libimage;
import './utils.dart' as utils;
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart' show WidgetsBinding;

final devicePixelRatio = WidgetsBinding.instance.window.devicePixelRatio;

class SpriteFrame extends Component {
 
  static ui.Paint paint = ui.Paint()..color = Colors.white;
  bool _loaded = false;
  dynamic _texture; // image.Image or ui.Image
  String _textureFilename;

  /// CCSprite properties
  utils.Rect _rect;
  utils.Rect _rectInPixels;
  // whether or not the rect of the frame is rotated ( x = x+width, y = y+height, width = height, height = width )
  bool _rotated;
  utils.Point _offset;
  utils.Point _offsetInPixels;
  utils.Size _originalSize;
  utils.Size _originalSizeInPixels;
  ui.Rect toRect(){
     return ui.Rect.fromLTWH(
        _rect.left + _offset.x ,
        _rect.top + _offset.y,
        _rect.width ,
        _rect.height );
  }
  SpriteFrame.fromTextureFilename(String filename,
      {utils.Rect rectInPixels, bool rotated, utils.Point offset, utils.Size originalSize}) {

    this
      .._textureFilename = filename
      .._rectInPixels = rectInPixels
      .._rect = rectInPixels / devicePixelRatio  //rectInPixels div device ratio
      .._offsetInPixels = offset
      .._offset =   offset / devicePixelRatio 
      .._originalSizeInPixels = originalSize
      .._rotated = rotated
      .._originalSize = originalSize /  devicePixelRatio;
    
    ui.decodeImageFromList(toPngBytesSync(filename), (image) {
      _texture = image;
      _loaded = true;
    });
  }

  SpriteFrame.fromTexture(dynamic texture,
      {utils.Rect rectInPixels, bool rotated, utils.Point offset, utils.Size originalSize}) {

    this
      .._rectInPixels = rectInPixels
      .._rect = rectInPixels / devicePixelRatio  //rectInPixels div device ratio
      .._offsetInPixels = offset
      .._offset =   offset / devicePixelRatio 
      .._originalSizeInPixels = originalSize
      .._rotated = rotated
      .._originalSize = originalSize / devicePixelRatio;

    if (texture is libimage.Image) {
      ui.decodeImageFromList(imageAsPngUintList(texture), (image) {
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
    var dst = ui.Rect.fromLTWH(
        _rect.left + _offset.x ,
        _rect.top + _offset.y,
        _rect.width ,
        _rect.height );
   
    var src = ui.Rect.fromLTWH(
        _rectInPixels.left ,
        _rectInPixels.top ,
        _rectInPixels.width ,
        _rectInPixels.height );
    c.drawImageRect(_texture, src, dst, paint);
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
