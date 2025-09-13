import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/exam_model.dart';

class ExamRepository {
  final Map<String, String> subjectMap = {
    "Toán": "math",
    "Lý": "physics",
    "Hóa": "chemistry",
    "Sinh": "biology",
    "Anh": "english",
    "Văn": "literature"
    // thêm môn khác nếu cần
  };

  Future<List<Exam>> loadExams(String subject, int grade) async {
    // đổi subject tiếng Việt sang key tiếng Anh, nếu không có thì giữ nguyên
    final subjectKey = subjectMap[subject] ?? subject;

    final path = 'assets/exams/exam_${subjectKey}_$grade.json';
    print("Loading exam file: $path"); // debug log

    final data = await rootBundle.loadString(path);
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => Exam.fromJson(json)).toList();
  }
}
