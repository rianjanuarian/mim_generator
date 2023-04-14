import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mim_generator/ui/sharepage.dart';
import 'package:permission_handler/permission_handler.dart';

class PreviewPage extends StatelessWidget {
  Uint8List? bytes;
  int width;
  int height;
  PreviewPage(
      {super.key,
      required this.bytes,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    final mHeight = MediaQuery.of(context).size.height;
    final mWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 0.0,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'MimGenerator',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // (bytes != null) ? Image.memory(bytes!) : Container(),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: SizedBox(
                  height: (height.toDouble() > 800.0)
                      ? mHeight * 0.7
                      : height.toDouble(),
                  width: (width.toDouble() > 700.0)
                      ? mWidth * 0.9
                      : width.toDouble(),
                  child: Center(
                    child: (bytes != null)
                        ? Image.memory(
                            bytes!,
                            fit: BoxFit.fill,
                          )
                        : Container(),
                  )),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: mWidth * 0.45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        width: 3.0,
                      ),
                    ),
                    onPressed: () async {
                      requesStoragePermission(context);
                      Uint8List ga = bytes!;
                      ImageGallerySaver.saveImage(ga);
                    },
                    child: const Text(
                      "Simpan",
                      style: TextStyle(color: Colors.black),
                    )),
              ),
              SizedBox(
                  width: mWidth * 0.45,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SharePage(
                                  width: width, height: height, bytes: bytes)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          width: 3.0,
                        ),
                      ),
                      child: const Text(
                        "Share",
                        style: TextStyle(color: Colors.black),
                      )))
            ],
          )
        ],
      ),
    );
  }

  void requesStoragePermission(BuildContext context) async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      print('izin dapat');
      final snackBar = const SnackBar(
        content: Text('Saved to Gallery'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (status.isDenied) {}
    if (await Permission.storage.request().isGranted) {
      print('izin dapat');
    }
  }
}
