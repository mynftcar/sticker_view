import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sticker_view/stickers/sticker_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final keyImage = GlobalKey();
  Size size = Size.zero;
  Size originalSize = Size.zero;
  Offset position = Offset.zero;

  @override
  void initState() {
    super.initState();

    calculateSizeAndPosition();
  }

  void calculateSizeAndPosition() => WidgetsBinding.instance?.addPostFrameCallback((_) async {
        var newState  = keyImage.currentState as StickerImageState;

        setState(() {
          size = newState.widgetSize;
          originalSize = newState.imageSize;
          position = newState.widgetPosition;
        });
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save_alt),
        onPressed: () async {
          calculateSizeAndPosition();
        },
      ),
      //backgroundColor: Colors.black,
      appBar: buildResult(),
      body: Column(
          children: [
        StickerImage(
          image: const AssetImage("veyron_s.png"),
          key: keyImage,
          onUpdate: calculateSizeAndPosition
        ),
      ]),
    );
  }

  PreferredSizeWidget buildResult() {
    return AppBar(
      actions: <Widget>[
        Text(
          'Original Size: ${originalSize.width.toInt()} x ${originalSize.height.toInt()} ',
        ),
        Text(
          'Current Size: ${size.width.toInt()} x ${size.height.toInt()}  ',
        ),
        Text(
          'Position: X: ${position.dx.toInt()} x ${position.dy.toInt()}  ',
        ),
      ],
    );
  }
}
