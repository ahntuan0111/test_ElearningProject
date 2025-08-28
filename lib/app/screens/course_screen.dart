import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'subject_detail_screen.dart';

class CourseScreen extends StatelessWidget {
  CourseScreen({super.key});

  final List<int> grades = [6, 7, 8, 9];
  final List<String> subjects = ['Toán', 'Lý', 'Văn', 'Anh'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: grades.length * subjects.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (context, index) {
          int grade = grades[index ~/ subjects.length];
          String subject = subjects[index % subjects.length];
          return _buildCourseCard(subject, grade);
        },
      ),
    );
  }

  Widget _buildCourseCard(String subject, int grade) {
    return InkWell(
      onTap: () {
        Get.to(() => SubjectDetailScreen(grade: grade, subject: subject));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        alignment: Alignment.center,
        child: Text(
          "Khối $grade\n$subject",
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
        ),
      ),
    );
  }
}
