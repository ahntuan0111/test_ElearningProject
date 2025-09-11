import 'package:flutter/material.dart';
import 'exam_pdf_viewer.dart';

class ExamListPage extends StatelessWidget {
  final pdfFiles = [
    {
      "name": "Đề Toán 6 - 1",
      "path": "assets/exams/pdf/math_6-1.pdf",
    },
    {
      "name": "Đề Toán 6 - 2",
      "path": "assets/exams/pdf/math_6-2.pdf",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Danh sách đề thi")),
      body: ListView.builder(
        itemCount: pdfFiles.length,
        itemBuilder: (context, index) {
          final pdf = pdfFiles[index];
          return ListTile(
            title: Text(pdf["name"]!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExamPdfViewer(pdfPath: pdf["path"]!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
