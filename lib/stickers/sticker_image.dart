import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class StickerImage extends StatefulWidget {
  final ImageProvider<Object> image;

  const StickerImage({
    Key? key,
    required this.image,
  }) : super(
          key: key,
        );

  @override
  State<StatefulWidget> createState() {
    return StickerImageState();
  }
}

class StickerImageState extends State<StickerImage> {
  double widgetWidth = 0.0;
  Key _keyImage = GlobalKey();

  Size _imageSize = Size.zero;
  Size _size = Size.zero;
  Offset _position = Offset.zero;

  Size get imageSize => _imageSize;

  Size get widgetSize => _size;

  @override
  void initState() {
    super.initState();
    getImageOriginalSize();
  }

  @override
  Widget build(BuildContext context) {
    initializeSize();

    void onUpdate(DragUpdateDetails d) {
      print("onUpdate");
      setState(() {
        _position = Offset(_position.dx + d.delta.dx, _position.dy + d.delta.dy);
      });
    }

    return Expanded(
        child: Stack(children: [
      Positioned(
          left: _position.dx,
          top: _position.dy,
          child: GestureDetector(
              onPanUpdate: onUpdate,
              child: Image(key: _keyImage, image: widget.image)))
    ]));
  }

  // finds the width of the screen and set the sticker width to stretch horizontally
  void initializeSize() {
    //widgetWidth = MediaQuery.of(context).size.width;
  }

  Future<void> getImageOriginalSize() async {
    // TODO: Make this generic to any Image (asset, network, etc)
    AssetImage aimg = widget.image as AssetImage;
    final ByteData assetImageByteData = await rootBundle.load(aimg.assetName);
    var decodedImage = await decodeImageFromList(assetImageByteData.buffer.asUint8List());
    _size = Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());
  }
}
