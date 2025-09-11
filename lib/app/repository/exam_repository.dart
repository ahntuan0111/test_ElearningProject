import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/exam_model.dart';

class ExamRepository {
  Future<List<Exam>> loadExams(String subject, int grade) async {
    final path = 'assets/exams/exam_${subject}_$grade.json';
    final data = await rootBundle.loadString(path);
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => Exam.fromJson(json)).toList();
  }
}
