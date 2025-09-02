import 'dart:convert';
import 'package:flutter/services.dart';

import '../model/quiz_model.dart';

class QuizRepository {
  /// Lấy danh sách chương, bộ câu hỏi và câu hỏi theo môn học + lớp
  Future<List<QuizChapter>> fetchQuiz(String subject, int grade) async {
    try {
      // Lấy tên file theo môn học + lớp
      String fileName = _getFileName(subject, grade);

      // Đọc file JSON từ thư mục assets
      final String response = await rootBundle.loadString('assets/$fileName');
      final data = json.decode(response);

      // Parse JSON -> List<QuizChapter>
      return List<QuizChapter>.from(
        data['quiz'].map((x) => QuizChapter.fromJson(x)),
      );
    } catch (e) {
      throw Exception("Không tìm thấy dữ liệu quiz cho $subject lớp $grade");
    }
  }

  /// Tạo tên file quiz theo môn học và lớp
  String _getFileName(String subject, int grade) {
    switch (subject.toLowerCase()) {
      case 'toán':
        return 'quiz_toan_$grade.json';
      case 'lý':
        return 'quiz_vatly_$grade.json';
      case 'văn':
        return 'quiz_van_$grade.json';
      case 'anh':
        return 'quiz_tienganh_$grade.json';
      default:
        throw Exception("Môn học không hợp lệ: $subject");
    }
  }
}
