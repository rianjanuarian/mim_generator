import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:mim_generator/model/meme.dart';
import 'package:path_provider/path_provider.dart';

abstract class Services {
  static Future<List<MemesModel?>> getMemes() async {
    try {
      final response = await Dio().get('https://api.imgflip.com/get_memes');
      final List data = response.data['data']['memes'];
      if (response.statusCode == 200) {
        return data
            .map(
              (e) => MemesModel(
                  id: e['id'],
                  name: e['name'],
                  url: e['url'],
                  width: e['width'],
                  height: e['height']),
            )
            .toList();
      }
      throw Exception('failed to load');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future saveImage(Uint8List bytes) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/image.png');
    file.writeAsBytes(bytes);
  }
}
