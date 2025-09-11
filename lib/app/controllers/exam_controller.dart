import 'package:get/get.dart';
import '../model/exam_model.dart';

class ExamController extends GetxController {
  var exams = <Exam>[].obs;
  var isLoading = true.obs;

  Future<void> loadExams(String subject, int grade) async {
    try {
      isLoading.value = true;

      // Giả lập fetch từ API hoặc local data
      await Future.delayed(const Duration(seconds: 1));

      final basePath = 'assets/exams/${subject.toLowerCase()}-';
      exams.value = [
        Exam(
          title: 'Đề thi $subject 1',
          description: 'Đề thi thử cho Khối $grade',
          pdfPath: '$basePath-1.pdf',
        ),
        Exam(
          title: 'Đề thi $subject 2',
          description: 'Đề thi thử cho Khối $grade',
          pdfPath: '$basePath-2.pdf',
        ),
      ];

      // Log để kiểm tra đường dẫn
      for (var exam in exams) {
        print('PDF Path: ${exam.pdfPath}');
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể tải danh sách đề thi: $e");
    } finally {
      isLoading.value = false;
    }
  }
}