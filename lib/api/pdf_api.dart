import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class PDFApi {
  static Future<File> loadAsset(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();
    return _storeFile(path, bytes);
  }

  static Future<File> loadNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    return _storeFile(url, bytes);
  }

  // Tạm thời comment lại phần file_picker
  /*
  static Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return null;
    
    if (result.files.single.path != null) {
      return File(result.files.single.path!);
    } else {
      final bytes = result.files.single.bytes;
      if (bytes != null) {
        return _storeFile(result.files.single.name, bytes);
      }
    }
    return null;
  }
  */

  static Future<File?> loadFirebase(String url) async {
    try {
      final refPDF = FirebaseStorage.instance.ref().child(url);
      const maxSize = 10 * 1024 * 1024;
      final bytes = await refPDF.getData(maxSize);
      
      if (bytes != null) {
        return _storeFile(url, bytes);
      }
      return null;
    } catch (e) {
      print('Lỗi tải file từ Firebase: $e');
      return null;
    }
  }

  static Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}