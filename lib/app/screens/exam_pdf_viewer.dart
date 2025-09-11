import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';

class ExamPdfViewer extends StatefulWidget {
  final String pdfPath;

  const ExamPdfViewer({required this.pdfPath, super.key});

  @override
  State<ExamPdfViewer> createState() => _ExamPdfViewerState();
}

class _ExamPdfViewerState extends State<ExamPdfViewer> {
  String? _error;
  bool _isLoading = true;
  String? localPath;

  @override
  void initState() {
    super.initState();
    _preparePdf();
  }

  Future<void> _preparePdf() async {
    try {
      if (widget.pdfPath.startsWith('assets/')) {
        // load file từ assets
        final bytes = await rootBundle.load(widget.pdfPath);
        final dir = await getTemporaryDirectory();

        // tạo tên file riêng dựa theo tên gốc
        final filename = widget.pdfPath.split('/').last;
        final file = File('${dir.path}/$filename');

        await file.writeAsBytes(bytes.buffer.asUint8List());
        localPath = file.path;
      } else {
        // load file từ đường dẫn ngoài
        if (await File(widget.pdfPath).exists()) {
          localPath = widget.pdfPath;
        } else {
          throw Exception('Không tìm thấy file: ${widget.pdfPath}');
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Lỗi khi load file: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Xem đề thi")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Xem đề thi")),
        body: Center(child: Text(_error!)),
      );
    }

    if (localPath == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Xem đề thi")),
        body: const Center(child: Text("Không tìm thấy file PDF")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Xem đề thi")),
      body: PDFView(
        filePath: localPath!,
        onRender: (pages) {
          debugPrint('📄 Số trang PDF: $pages');
        },
        onError: (error) {
          setState(() {
            _error = 'Lỗi khi render PDF: $error';
          });
          debugPrint('❌ PDF Error: $error');
        },
        onPageChanged: (page, total) {
          debugPrint('📖 Trang hiện tại: $page / Tổng số trang: $total');
        },
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
      ),
    );
  }
}
