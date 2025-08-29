import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/theory_model.dart';
import '../repository/theory_repository.dart';

class TheoryController extends GetxController {
  final TheoryRepository repository = TheoryRepository();

  var isLoading = false.obs;
  var chapters = <Chapter>[].obs;
  var completedLessons = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCompletedLessons();
  }

  Future<void> loadTheory(String subject, int grade) async {
    try {
      isLoading.value = true;
      chapters.value = await repository.fetchTheory(subject, grade);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadCompletedLessons() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('completedLessons') ?? [];
    completedLessons.value = saved.toSet();
  }

  Future<void> _saveCompletedLessons() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('completedLessons', completedLessons.toList());
  }

  void toggleComplete(String lessonTitle) {
    if (completedLessons.contains(lessonTitle)) {
      completedLessons.remove(lessonTitle);
    } else {
      completedLessons.add(lessonTitle);
    }
    _saveCompletedLessons();
  }

  bool isCompleted(String lessonTitle) {
    return completedLessons.contains(lessonTitle);
  }

  double getProgress(String subject, int grade) {
    // Lấy tất cả bài trong chapters của môn/khối hiện tại
    int totalLessons = chapters.fold(0, (sum, chapter) => sum + chapter.lessons.length);
    if (totalLessons == 0) return 0.0;

    // Đếm số bài đã hoàn thành trong completedLessons
    int doneLessons = chapters.fold(0, (sum, chapter) {
      return sum + chapter.lessons.where((lesson) => completedLessons.contains(lesson.title)).length;
    });

    return doneLessons / totalLessons;
  }
}
