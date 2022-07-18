import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../constants.dart';
import '../resize_point.dart';

class StickerImage extends StatefulWidget {
  final ImageProvider<Object> image;

  const StickerImage({Key? key, required this.image, this.onUpdate})
      : super(
    key: key,
  );

  final Function? onUpdate;

  @override
  State<StatefulWidget> createState() {
    return StickerImageState();
  }
}

class StickerImageState extends State<StickerImage> {
  final Key _keyImage = GlobalKey();

  // internal vars
  Size _imageSize = Size.zero;
  Size _size = Size.zero;

  Offset _position = Offset.zero;

  bool selected = false;
  bool firstBuild = false;

  double aspectRatio = 0.0;

  // exposed properties
  Size get imageSize => _imageSize;
  Size get widgetSize => _size;
  Offset get widgetPosition => _position;

  @override
  void initState() {
    super.initState();
    getImageOriginalSize();
    fitToScreenWidth();
    _size = _imageSize;
    aspectRatio = _imageSize.width / _imageSize.height;
  }

  void onTap() {
    setState(() {
      selected = !selected;
    });
  }

  void onUpdate(DragUpdateDetails d) {
    selected = true;
    setState(() {
      _position = Offset(_position.dx + d.delta.dx, _position.dy + d.delta.dy);
    });

    triggerOnUpdate();
  }

  void onDragBottomRight(Offset details) {

    // adds/removes the movement to size;
    double wRatio = (widgetSize.width + details.dx) / widgetSize.width;
    double hRatio = (widgetSize.height + details.dy) / widgetSize.height;

    // keep aspect ratio, by finding the biggest change and applying it
    double resizeRatio = 0.0;
    if (details.dx.abs() > details.dy.abs()) {
      resizeRatio = wRatio;
    } else {
      resizeRatio = hRatio;
    }

    final updatedSize = Size(widgetSize.width * resizeRatio, widgetSize.height * resizeRatio);

    // minimum size of the sticker should be Size(50,50)
    if (updatedSize > const Size(50, 50)) {
      setState(() {
        _size = updatedSize;
      });
    }
    triggerOnUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Stack(
            children: [
              buildImage(),
              Positioned(
                top: widgetPosition.dy + widgetSize.height,
                left: widgetPosition.dx + widgetSize.width,
                child: Visibility(
                  visible: selected,
                  child: ResizePoint(
                    key: const Key('draggableResizable_bottomRightResizePoint'),
                    type: ResizePointType.bottomRight,
                    onDrag: onDragBottomRight,
                    iconData: Icons.zoom_out_map,
                  ),
                ),
              )
            ]
        )
    );
  }

  Widget buildImage() {
    if (!firstBuild) {
      fitToScreenWidth();
      firstBuild = true;
    }

    return Positioned(
        left: _position.dx,
        top: _position.dy,
        width: _size.width,
        height: _size.height,

        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: selected ? Colors.blue : Colors.transparent,
            ),
          ),
          child: GestureDetector(
              onPanUpdate: onUpdate,
              onTap: onTap,
              child: Image(key: _keyImage, image: widget.image)
          ),
        )
    );
  }

  /// Triggers the event for external listeners
  void triggerOnUpdate() {
    if (widget.onUpdate != null) {
      widget.onUpdate!();
    }
  }

  // finds the width of the screen and set the sticker width to stretch horizontally
  void fitToScreenWidth() {
    _size = const Size(200.0, 100.0);
    triggerOnUpdate();
  }

  Future<void> getImageOriginalSize() async {
    // TODO: Make this generic to any Image (asset, network, etc)
    AssetImage aimg = widget.image as AssetImage;
    final ByteData assetImageByteData = await rootBundle.load(aimg.assetName);
    var decodedImage = await decodeImageFromList(assetImageByteData.buffer.asUint8List());
    _imageSize = Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());
  }

}
