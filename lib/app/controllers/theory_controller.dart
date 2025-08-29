import 'package:get/get.dart';
import '../model/theory_model.dart';
import '../repository/theory_repository.dart';

class TheoryController extends GetxController {
  final TheoryRepository repository = TheoryRepository();

  var isLoading = false.obs;
  var chapters = <Chapter>[].obs;

  // Danh sách bài học hoàn thành
  var completedLessons = <String>{}.obs; // lessonId duy nhất

  Future<void> loadTheory(String subject, int grade) async {
    try {
      isLoading.value = true;
      chapters.value = await repository.fetchTheory(subject, grade);
    } finally {
      isLoading.value = false;
    }
  }

  void toggleComplete(String lessonTitle) {
    if (completedLessons.contains(lessonTitle)) {
      completedLessons.remove(lessonTitle);
    } else {
      completedLessons.add(lessonTitle);
    }
  }

  bool isCompleted(String lessonTitle) {
    return completedLessons.contains(lessonTitle);
  }
}
