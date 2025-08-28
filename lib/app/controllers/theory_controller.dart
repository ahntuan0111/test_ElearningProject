import 'package:get/get.dart';

import '../model/theory_model.dart';
import '../repository/theory_repository.dart';


class TheoryController extends GetxController {
  final TheoryRepository _repository = TheoryRepository();

  var chapters = <Chapter>[].obs;
  var isLoading = true.obs;

  Future<void> loadTheory(String subject, int grade) async {
    try {
      isLoading(true);
      chapters.value = await _repository.fetchTheory(subject, grade);
    } finally {
      isLoading(false);
    }
  }
}
