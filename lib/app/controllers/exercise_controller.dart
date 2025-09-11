import 'package:get/get.dart';
import '../model/exercise_model.dart';
import '../repository/exercise_repository.dart';

class ExerciseController extends GetxController {
  final ExerciseRepository repository = Get.put(ExerciseRepository());

  var exercises = <Exercise>[].obs;
  var isLoading = false.obs;

  Future<void> loadExercises(String subject, int grade) async {
    try {
      isLoading.value = true;
      final data = await repository.fetchExercises(subject, grade);
      exercises.assignAll(data);
    } catch (e) {
      print("Error loading exercises: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
