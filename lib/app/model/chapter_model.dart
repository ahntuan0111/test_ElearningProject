// chapter_model.dart
import 'lesson_model.dart';

class Chapter {
  final int id;
  final String title;
  final int orderNo;
  List<Lesson> lessons; // gán sau khi fetch riêng

  Chapter({
    required this.id,
    required this.title,
    required this.orderNo,
    List<Lesson>? lessons,
  }) : lessons = lessons ?? [];

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      orderNo: json['orderNo'] ?? 1,
    );
  }
}
