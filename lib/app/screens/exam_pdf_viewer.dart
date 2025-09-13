import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path_lib;

class ExamPdfViewer extends StatelessWidget {
  final String subject; // ví dụ: "math"
  final int grade;      // ví dụ: 6
  const ExamPdfViewer({super.key, required this.subject, required this.grade});

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = Colors.green;

    return FutureBuilder<List<dynamic>>(
      future: _loadJson(subject, grade),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text("❌ Lỗi: ${snapshot.error}")));
        }
        final exams = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text("Đề thi ${subject.toUpperCase()} lớp $grade"),
            backgroundColor: primaryGreen, // ✅ AppBar xanh lá
          ),
          backgroundColor: primaryGreen, // nền nhạt cho đẹp
          body: ListView.builder(
            itemCount: exams.length,
            itemBuilder: (context, index) {
              final exam = exams[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text(exam['title']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exam['description']),
                      Text("Độ khó: ${exam['difficulty']}"),
                      Text("Ngày: ${exam['date']}"),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PDFReaderScreen(assetPath: exam['pdfPath']),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<List<dynamic>> _loadJson(String subject, int grade) async {
    final jsonString = await rootBundle
        .loadString("assets/exams/json/exam_${subject}_$grade.json");
    return json.decode(jsonString) as List<dynamic>;
  }
}

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
    _loadPdfFromAssets();
  }

  Future<void> _loadPdfFromAssets() async {
    try {
      final bytes = await rootBundle.load(widget.assetPath);
      final dir = await getTemporaryDirectory();
      final file = File("${dir.path}/${path_lib.basename(widget.assetPath)}");
      await file.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
        flush: true,
      );
      setState(() => localPath = file.path);
    } catch (e) {
      debugPrint("❌ Lỗi load asset PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(path_lib.basename(widget.assetPath)),
        backgroundColor: Colors.green, // ✅ AppBar xanh lá
      ),
      body: localPath == null
          ? const Center(child: CircularProgressIndicator())
          : PDFView(filePath: localPath!),
    );
  }
}
