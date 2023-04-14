import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mim_generator/ui/previewpage.dart';
import 'package:screenshot/screenshot.dart';

class DetailPage extends StatefulWidget {
  String url;
  int width;
  int height;

  DetailPage(
      {super.key,
      required this.url,
      required this.height,
      required this.width});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final addTextController = TextEditingController();
  File? _image;

  final _picker = ImagePicker();

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  bool isPicked = false;
  String text = '';
  @override
  Widget build(BuildContext context) {
    final mHeight = MediaQuery.of(context).size.height;
    final mWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final snackBar = const SnackBar(
            content: Text('Saving'),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          final controller = ScreenshotController();
          final bytes =
              await controller.captureFromWidget(Material(child: buildImage()));
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PreviewPage(
                      bytes: bytes,
                      width: widget.width,
                      height: widget.height,
                    )),
          );
        },
        child: const Text("Simpan"),
      ),
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
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Container(
                  height: (widget.height.toDouble() > 800.0)
                      ? mHeight * 0.7
                      : widget.height.toDouble(),
                  width: (widget.width.toDouble() > 700.0)
                      ? mWidth * 0.9
                      : widget.width.toDouble(),
                  decoration: BoxDecoration(border: Border.all()),
                  child: Center(child: buildImage())),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: _openImagePicker,
                child: Column(
                  children: const [
                    Text(
                      "Add Logo",
                    ),
                    Icon(Icons.image)
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  _addText(context);
                },
                child: Column(
                  children: const [
                    Text("Add Text"),
                    Text(
                      "T",
                      style: TextStyle(fontSize: 25),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildImage() {
    return Stack(
      children: [
        Image.network(
          widget.url,
          fit: BoxFit.fill,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (_image != null)
                ? Image.file(
                    _image!,
                    width: 150,
                    height: 150,
                  )
                : const SizedBox(
                    height: 150,
                    width: 150,
                  ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(fontSize: 25),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _addText(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Text'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: addTextController,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                setState(() {
                  text = addTextController.text;
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }
}
