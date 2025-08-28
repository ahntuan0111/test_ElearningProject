import 'dart:convert';
import 'package:flutter/services.dart';

import '../model/theory_model.dart';


class TheoryRepository {
  Future<List<Chapter>> fetchTheory(String subject, int grade) async {
    try {
      // Lấy tên file theo môn học + lớp
      String fileName = _getFileName(subject, grade);

      // Đọc file JSON từ thư mục assets
      final String response = await rootBundle.loadString('assets/$fileName');
      final data = json.decode(response);

      return List<Chapter>.from(
        data['chapters'].map((x) => Chapter.fromJson(x)),
      );
    } catch (e) {
      throw Exception("Không tìm thấy dữ liệu cho $subject lớp $grade");
    }
  }

  String _getFileName(String subject, int grade) {
    switch (subject.toLowerCase()) {
      case 'toán':
        return 'toan_$grade.json';
      case 'lý':
        return 'vatly_$grade.json';
      case 'văn':
        return 'van_$grade.json';
      case 'anh':
        return 'tienganh_$grade.json';
      default:
        throw Exception("Môn học không hợp lệ: $subject");
    }
  }
}
