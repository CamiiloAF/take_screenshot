library take_screenshot;

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Screenshot manager to capture the screen in different ways
class TakeScreenshotController {
  /// [RepaintBoundary] key
  GlobalKey _containerKey;

  TakeScreenshotController() : _containerKey = GlobalKey();

  /// Captures [File] and saves to given [path].
  /// Default path is $applicationDocumentsDirectory/$file.png
  Future<File> captureAsFile({
    String path = '',
    double pixelRatio = 1,
  }) async {
    try {
      final boundary = _getRenderRepaintBoundary();

      final pngBytes = await _getPngBytes(boundary, pixelRatio);

      if (path.isEmpty) path = await _getDefaultPath();

      final imgFile = File(path);
      await imgFile.writeAsBytes(pngBytes).then((onValue) {});
      return imgFile;
    } on Exception {
      throw (Exception);
    }
  }

  /// Captures a [Uint8List].
  /// [delay] is to avoid a bug, you do not need to send it
  Future<Uint8List> captureAsPngBytes({
    double pixelRatio = 1,
    Duration delay = const Duration(milliseconds: 20),
  }) async {
    return Future.delayed(delay, () async {
      try {
        final boundary = _getRenderRepaintBoundary();

        return await _getPngBytes(boundary, pixelRatio);
      } on Exception {
        throw (Exception);
      }
    });
  }

  ///Captures a [ui.Image]. [delay] is to avoid a bug, you do not need to send it
  Future<ui.Image> captureAsUiImage(
      {double pixelRatio = 1,
      Duration delay = const Duration(milliseconds: 20)}) async {
    return Future.delayed(delay, () async {
      try {
        final boundary = _getRenderRepaintBoundary();
        return await boundary.toImage(pixelRatio: pixelRatio);
      } on Exception {
        throw (Exception);
      }
    });
  }

  ///Captures png image and shared it with others apps.
  Future<void> captureAndShare({
    String path = '',
    double pixelRatio = 1,
    List<String>? mimeTypes,
    Rect? sharePositionOrigin,
    String? subject,
    String? text,
  }) async {
    try {
      final file = await captureAsFile(path: path, pixelRatio: pixelRatio);
      await Share.shareFiles([file.path],
          mimeTypes: mimeTypes,
          sharePositionOrigin: sharePositionOrigin,
          subject: subject,
          text: text);
    } on Exception {
      throw (Exception);
    }
  }

  /// Convert [RenderObject] to [RenderRepaintBoundary]
  RenderRepaintBoundary _getRenderRepaintBoundary() {
    return _containerKey.currentContext!.findRenderObject()!
        as RenderRepaintBoundary;
  }

  /// Take a [RenderRepaintBoundary] and convert it to [Uint8List]
  Future<Uint8List> _getPngBytes(
      RenderRepaintBoundary boundary, double pixelRatio) async {
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData?.buffer.asUint8List();

    if (pngBytes == null) throw Exception('bytes should not be null');
    return pngBytes;
  }

  /// [_getDefaultPath()] is used by [captureAsFile] to get default path to save
  /// [File]. Default path is $applicationDocumentsDirectory/$file.png
  Future<String> _getDefaultPath() async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    final fileName = DateTime.now().toIso8601String();
    return '$directory/$fileName.png';
  }
}

/// [child] is the widget to which the screenshot will be made
class TakeScreenshot extends StatefulWidget {
  final Widget child;
  final TakeScreenshotController controller;
  final GlobalKey? containerKey;

  const TakeScreenshot(
      {Key? key,
      required this.child,
      required this.controller,
      this.containerKey})
      : super(key: key);

  @override
  State<TakeScreenshot> createState() => TakeScreenshotState();
}

class TakeScreenshotState extends State<TakeScreenshot>
    with TickerProviderStateMixin {
  late TakeScreenshotController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  void didUpdateWidget(TakeScreenshot oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      widget.controller._containerKey = oldWidget.controller._containerKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _controller._containerKey,
      child: widget.child,
    );
  }
}
