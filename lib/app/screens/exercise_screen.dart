import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/exercise_controller.dart';

class ExerciseScreen extends StatelessWidget {
  final String subject;
  final int grade;

  ExerciseScreen({required this.subject, required this.grade, super.key});

  final ExerciseController controller = Get.put(ExerciseController());


  @override
  
  Widget build(BuildContext context) {
    controller.loadExercises(subject, grade);

    return Scaffold(
      appBar: AppBar(
        title: Text("Giải bài tập - $subject lớp $grade"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.exercises.isEmpty) {
          return const Center(child: Text("Chưa có bài tập"));
        }

        return ListView.builder(
          itemCount: controller.exercises.length,
          itemBuilder: (context, index) {
            final ex = controller.exercises[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(ex.question),
                subtitle: Text("Lời giải: ${ex.solution}"),
              ),
            );
          },
        );
      }),
    );
  }
}
