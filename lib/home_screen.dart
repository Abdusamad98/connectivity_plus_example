import 'dart:typed_data';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus_example/no_internet/no_internet_screen.dart';
import 'package:connectivity_plus_example/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'connectivity/connectivity_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey containerKey = GlobalKey();

  Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: containerKey,
      child: Scaffold(
        appBar: AppBar(),
        body: BlocListener<ConnectivityCubit, ConnectivityState>(
          listener: (context, state) {
            if (state.connectivityResult == ConnectivityResult.none) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NoInternetScreen(voidCallback: () {})));
            }
          },
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 300,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(16)),
                child: const Center(
                  child: Text(
                    "SCREEN SHOT",
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  saveToGallery();
                },
                child: const Text("Take Screen Shot"),
              ),
              if (imageBytes != null) Image.memory(imageBytes!),
            ],
          ),
        ),
      ),
    );
  }

  _takeScreenshot<Uint8List>() async {
    RenderRepaintBoundary boundary = containerKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    var im = await boundary.toImage();
    var byteData = await im.toByteData(format: ImageByteFormat.png);
    setState(() {
      imageBytes = byteData!.buffer.asUint8List();
    });
    return byteData!.buffer.asUint8List();
  }

  saveToGallery() async {
    await PermissionUtil.requestAll();
    var pngBytes = await _takeScreenshot();
  var t =  await ImageGallerySaver.saveImage(pngBytes);
  print(t["filePath"]);

  }
}
