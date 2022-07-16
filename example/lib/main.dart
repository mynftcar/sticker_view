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
  Offset position = Offset.zero;

  @override
  void initState() {
    super.initState();

    calculateSizeAndPosition();
  }

  void calculateSizeAndPosition() => WidgetsBinding.instance?.addPostFrameCallback((_) async {
        final RenderBox box = keyImage.currentContext!.findRenderObject() as RenderBox;

        setState(() {
          position = box.localToGlobal(Offset.zero);
          size = box.size;
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
        ),

      ]),
    );
  }

  PreferredSizeWidget buildResult() {
    return AppBar(
      actions: <Widget>[
        Text(
          'Width: ${size.width.toInt()}  ',
        ),
        Text(
          'Height: ${size.height.toInt()}  ',

        ),
        Text(
          'X: ${position.dx.toInt()}  ',

        ),
        Text(
          'Y: ${position.dy.toInt()}  ',
        ),
      ],
    );
  }
}
