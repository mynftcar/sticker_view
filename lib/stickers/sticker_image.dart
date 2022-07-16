import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

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

  Size _imageSize = Size.zero;
  Size _size = Size.zero;
  Offset _position = Offset.zero;

  Size get imageSize => _imageSize;

  Size get widgetSize => _size;

  Offset get widgetPosition => _position;

  @override
  void initState() {
    super.initState();
    getImageOriginalSize();
    fitToScreenWidth();
    _size = _imageSize;
  }

  void onUpdate(DragUpdateDetails d) {
    setState(() {
      _position = Offset(_position.dx + d.delta.dx, _position.dy + d.delta.dy);
    });

    triggerOnUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Stack(children: [buildImage()])
    );
  }

  Widget buildImage() {
    fitToScreenWidth();
    return Positioned(
        left: _position.dx,
        top: _position.dy,
        width: _size.width,
        height: _size.height,
        child: GestureDetector(
            onPanUpdate: onUpdate,
            child: Image(key: _keyImage, image: widget.image)
        )
    );
  }

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
