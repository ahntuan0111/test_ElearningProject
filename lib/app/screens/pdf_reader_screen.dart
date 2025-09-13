import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFReaderScreen extends StatefulWidget {
  final String assetPath;

  const PDFReaderScreen({super.key, required this.assetPath});

  @override
  State<PDFReaderScreen> createState() => _PDFReaderScreenState();
}

class _PDFReaderScreenState extends State<PDFReaderScreen> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    final bytes = await rootBundle.load(widget.assetPath);
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/${widget.assetPath.split('/').last}");
    await file.writeAsBytes(
      bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
    );
    setState(() {
      localPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = Colors.green;

    return Scaffold(
      appBar: AppBar(title: Text(widget.assetPath.split('/').last)),
      backgroundColor: primaryGreen,
      body: localPath == null
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: localPath!,
            ),
    );
  }
}
