import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theory_controller.dart';
import '../routes/app_routes.dart';

class TheoryScreen extends StatelessWidget {
  final String subject;
  final int grade;
  final Color primaryGreen = const Color(0xFF4CAF50);

  const TheoryScreen({super.key, required this.subject, required this.grade});

  @override
  Widget build(BuildContext context) {
    final TheoryController controller = Get.find<TheoryController>();
    controller.loadTheory(subject, grade); // load 1 lần thôi


    return Scaffold(
      appBar: AppBar(
        title: Text("Lý thuyết $subject - Khối $grade"),
        backgroundColor: primaryGreen,
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
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: primaryGreen,
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                title: Text(
                  chapter.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                children: List.generate(chapter.lessons.length, (lessonIndex) {
                  final lesson = chapter.lessons[lessonIndex];
                  return Obx(() {
                    final isDone = controller.isCompleted(lesson.title);
                    return ListTile(
                      leading: Hero(
                        tag: lesson.title,
                        child: Icon(Icons.menu_book,
                            color: isDone ? primaryGreen : Colors.blue),
                      ),
                      title: Text(
                        lesson.title,
                        style: TextStyle(
                          color: isDone ? primaryGreen : Colors.black87,
                          fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                      trailing: Icon(
                        isDone ? Icons.check_circle : Icons.arrow_forward_ios,
                        color: isDone ? Colors.green : Colors.grey,
                      ),
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.lessonDetail,
                          arguments: {
                            'lessonTitle': lesson.title,
                            'content': lesson.content,
                            'videoUrl': lesson.videoUrl,
                          },
                        );
                      },
                    );
                  });
                }),
              ),
            );
          },
        );
      }),
    );
  }
}
