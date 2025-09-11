import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/exam_controller.dart';
import 'exam_pdf_viewer.dart';

class ExamScreen extends StatefulWidget {
  final String subject;
  final int grade;

  const ExamScreen({super.key, required this.subject, required this.grade});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final ExamController controller = Get.put(ExamController());

  @override
  void initState() {
    super.initState();
    controller.loadExams(widget.subject, widget.grade);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bộ đề thi")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.exams.isEmpty) {
          return const Center(child: Text("Chưa có đề thi"));
        }
        return ListView.builder(
          itemCount: controller.exams.length,
          itemBuilder: (context, index) {
            final exam = controller.exams[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text(exam.title),
                subtitle: Text(exam.description),
                trailing: const Icon(Icons.picture_as_pdf),
                onTap: () async {
                  if (exam.pdfPath.isNotEmpty) {
                    try {
                      print('Navigating to PDF: ${exam.pdfPath}');
                      Get.to(() => ExamPdfViewer(pdfPath: exam.pdfPath));
                    } catch (e) {
                      Get.snackbar(
                        "Lỗi",
                        "Không thể mở file PDF: $e",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  } else {
                    Get.snackbar(
                      "Lỗi",
                      "Đường dẫn PDF không hợp lệ",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              ),
            );
          },
        );
      }),
    );
  }
}