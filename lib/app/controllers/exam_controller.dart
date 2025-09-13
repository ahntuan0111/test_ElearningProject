import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../model/exam_model.dart';

class ExamController extends GetxController {
  var exams = <Exam>[].obs; // Danh sách đề thi
  var isLoading = false.obs; // Trạng thái loading
  var hasMore = true.obs; // Có thêm dữ liệu để tải
  var _currentPage = 0; // Trang hiện tại
  final int _pageSize = 10; // Số lượng item mỗi trang

  // Danh sách độ khó
  final List<String> difficultyLevels = ['Dễ', 'Trung bình', 'Khó'];
  
  // Danh sách tất cả exams (để lọc)
  var _allExams = <Exam>[];

  // Map môn tiếng Việt -> key file
  final Map<String, String> subjectMap = {
    "Toán": "math",
    "Lý": "physics",
    "Hóa": "chemistry",
    "Sinh": "biology",
    "Anh": "english",
    "Văn": "literature"
    // thêm môn khác nếu cần
  };

  /// Load danh sách đề thi từ file JSON trong assets
  Future<void> loadExams(String subject, int grade) async {
    try {
      isLoading.value = true;

      final subjectKey = subjectMap[subject] ?? subject;
      final path = 'assets/exams/exam_${subjectKey}_$grade.json';
      print("🔍 Load file: $path"); // debug log

      final data = await rootBundle.loadString(path);
      final List<dynamic> jsonList = json.decode(data);
      
      _allExams = jsonList.map((json) {
        final pdfPath = json['pdfPath'] ?? '';
        final difficulty = json['difficulty'] ?? difficultyLevels[Random().nextInt(3)];
        final date = json['date'] ?? _generateRandomDate().toString();
        
        return Exam(
          title: json['title'] ?? '',
          description: json['description'] ?? '',
          pdfPath: pdfPath,
          difficulty: difficulty,
          date: DateTime.parse(date),
        );
      }).toList();
      
      _currentPage = 1;
      exams.value = _getPaginatedExams();
      hasMore.value = _allExams.length > _currentPage * _pageSize;
    } catch (e) {
      exams.clear();
      Get.snackbar(
        "Lỗi",
        "Không thể tải danh sách đề thi: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Tải thêm đề thi (phân trang)
  Future<void> loadMoreExams(String subject, int grade) async {
    if (!hasMore.value || isLoading.value) return;
    
    try {
      isLoading.value = true;
      _currentPage++;
      final newExams = _getPaginatedExams();
      exams.addAll(newExams);
      hasMore.value = _allExams.length > _currentPage * _pageSize;
    } catch (e) {
      _currentPage--;
      Get.snackbar(
        "Lỗi",
        "Không thể tải thêm đề thi: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Làm mới danh sách đề thi
  Future<void> refreshExams(String subject, int grade) async {
    await loadExams(subject, grade);
  }

  /// Sắp xếp đề thi theo ngày (mới nhất)
  void sortExamsByDate() {
    exams.sort((a, b) => b.date.compareTo(a.date));
  }

  /// Lọc đề thi theo độ khó
  void filterExamsByDifficulty(String difficulty) {
    exams.value = _allExams
        .where((exam) => exam.difficulty == difficulty)
        .toList();
  }

  /// Lấy danh sách exam theo trang
  List<Exam> _getPaginatedExams() {
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = min(startIndex + _pageSize, _allExams.length);
    
    if (startIndex >= _allExams.length) {
      return [];
    }
    
    return _allExams.sublist(startIndex, endIndex);
  }

  /// Tạo ngày ngẫu nhiên (dùng khi dữ liệu mẫu không có date)
  DateTime _generateRandomDate() {
    final random = Random();
    final currentDate = DateTime.now();
    return currentDate.subtract(Duration(days: random.nextInt(365)));
  }
}
