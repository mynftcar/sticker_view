import 'package:flutter/material.dart';
import 'package:sticker_view/sticker_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save_alt),
          onPressed: () {

          },
        ),
        body: Center(
          // Sticker Editor View
          child: StickerView(
            // List of Stickers
            stickerList: [
              Sticker(
                child: const Image(
                  image: NetworkImage("https://images.unsplash.com/photo-1640113292801-785c4c678e1e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=736&q=80"),
                  key: Key("image_111"),
                ),
                // must have unique id for every Sticker
                id: "uniqueId_111",
              ),
              Sticker(
                child: const Text("Hello"),
                id: "uniqueId_222",
                isText: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
