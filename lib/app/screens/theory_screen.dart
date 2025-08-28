import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/theory_controller.dart';

class TheoryScreen extends StatelessWidget {
  final String subject;
  final int grade;

  TheoryScreen({Key? key, required this.subject, required this.grade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TheoryController controller = Get.put(TheoryController());

    // Load dữ liệu khi mở màn hình
    controller.loadTheory(subject, grade);

    return Scaffold(
      appBar: AppBar(
        title: Text("Lý thuyết $subject - Khối $grade"),
        backgroundColor: Colors.red,
        elevation: 2,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.chapters.length,
          itemBuilder: (context, index) {
            final chapter = controller.chapters[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                title: Text(
                  chapter.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                children: List.generate(chapter.lessons.length, (lessonIndex) {
                  return ListTile(
                    leading: const Icon(Icons.menu_book, color: Colors.blue),
                    title: Text(chapter.lessons[lessonIndex].title),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Get.snackbar(
                        "Bài học",
                        "Mở ${chapter.lessons[lessonIndex].title}",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  );
                }),
              ),
            );
          },
        );
      }),
    );
  }
}
