import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/exercise_model.dart';

class ExerciseRepository {
  Future<List<Exercise>> fetchExercises(String subject, int grade) async {
    // ví dụ: assets/exercises/exercise_toan_6.json
    final fileName = "assets/exercises/exercise_${subject}_$grade.json";

    try {
      final String response = await rootBundle.loadString(fileName);
      final Map<String, dynamic> jsonMap = json.decode(response);

      // JSON phải có key "exercises"
      final List<dynamic> data = jsonMap['exercises'];

      return data.map((e) => Exercise.fromJson(e)).toList();
    } catch (e) {
      print("Error reading $fileName: $e");
      return [];
    }
  }
}
