import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class WidgetToImage {
  static Future<Uint8List> capture(GlobalKey key) async {
    final boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;

    final ui.Image image = await boundary.toImage(pixelRatio: 3);

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }
}
