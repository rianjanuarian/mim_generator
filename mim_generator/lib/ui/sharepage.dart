import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class SharePage extends StatefulWidget {
  Uint8List? bytes;
  int width;
  int height;
  SharePage(
      {super.key,
      required this.width,
      required this.height,
      required this.bytes});

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  final controller = ScreenshotController();
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
      body: Center(
        child: Container(
          height: mHeight * 0.8,
          width: mWidth * 0.9,
          decoration: BoxDecoration(border: Border.all()),
          child: Column(
            children: [
              // (bytes != null) ? Image.memory(bytes!) : Container(),
              Container(
                height: mHeight * 0.65,
                width: mWidth * 0.9,
                decoration: BoxDecoration(border: Border.all()),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: SizedBox(
                        height: (widget.height.toDouble() > 800.0)
                            ? mHeight * 0.6
                            : widget.height.toDouble(),
                        width: (widget.width.toDouble() > 700.0)
                            ? mWidth * 0.8
                            : widget.width.toDouble(),
                        child: buildImage()),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Divider(
                    color: Colors.black,
                    height: 25,
                    thickness: 2,
                    indent: 5,
                    endIndent: 5,
                  ),
                  SizedBox(
                    width: mWidth * 0.85,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            width: 3.0,
                          ),
                        ),
                        onPressed: () {
                          saveAndShare(widget.bytes!);
                        },
                        child: const Text(
                          "Share to FB",
                          style: TextStyle(color: Colors.black),
                        )),
                  ),
                  SizedBox(
                      width: mWidth * 0.85,
                      child: ElevatedButton(
                          onPressed: () {
                            saveAndShare(widget.bytes!);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(
                              width: 3.0,
                            ),
                          ),
                          child: const Text(
                            "Share to Twitter",
                            style: TextStyle(color: Colors.black),
                          )))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future saveAndShare(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/share.png');
    image.writeAsBytes(bytes);
    await Share.shareFiles([image.path]);
  }

  Widget buildImage() {
    return Screenshot(
      controller: controller,
      child: Center(
        child: (widget.bytes != null)
            ? Image.memory(
                widget.bytes!,
                fit: BoxFit.fill,
              )
            : Container(),
      ),
    );
  }
}
