import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

import '../model/chapter_model.dart';
import '../repository/theory_repository.dart';

class TheoryController extends GetxController {
  final TheoryRepository repository = TheoryRepository();
  final RxBool isLoading = false.obs;
  final RxList<Chapter> chapters = <Chapter>[].obs;
  final RxSet<String> completedLessons = <String>{}.obs;
  final Connectivity connectivity = Connectivity();

  late String subject; // tên hiển thị (VD: Toán, Ngữ Văn, Tiếng Anh)
  late int grade;      // khối lớp

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};
    subject = args['subject'] ?? 'Toán';
    grade = args['grade'] ?? 6;

    _loadCompletedLessons();
    loadTheory(subject, grade);
  }

  @override
  void onClose() {
    repository.dispose();
    super.onClose();
  }

  /// Map tên môn học sang subject code trong DB
  String _mapSubjectToCode(String subject) {
    switch (subject.trim().toLowerCase()) {
      case 'toán':
        return 'toan';
      case 'ngữ văn':
      case 'văn':
        return 'nguvan';
      case 'tiếng anh':
      case 'anh':
        return 'tienganh';
      default:
        throw Exception("Môn học không hợp lệ: $subject");
    }
  }

  /// Kiểm tra kết nối mạng và khả năng kết nối đến server
  Future<bool> checkNetworkConnection() async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    try {
      final result = await InternetAddress.lookup('192.168.0.144');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }

    return false;
  }

  /// Load chapters + lessons từ API
  Future<void> loadTheory(String subject, int grade) async {
    try {
      isLoading.value = true;

      final hasNetwork = await checkNetworkConnection();
      if (!hasNetwork) {
        Get.snackbar(
          'Lỗi kết nối',
          'Không có kết nối mạng hoặc không thể kết nối đến server.',
          duration: const Duration(seconds: 3),
        );
        isLoading.value = false;
        return;
      }

      final subjectCode = _mapSubjectToCode(subject);
      final theoryData = await repository.fetchTheory(subjectCode, grade);

      chapters.value = theoryData;
    } catch (e) {
      print("Error loading theory: $e");
      Get.snackbar(
        'Lỗi tải dữ liệu',
        'Không thể tải dữ liệu cho môn $subject.\n'
            'Vui lòng kiểm tra:\n'
            '1. Thiết bị đã kết nối cùng mạng WiFi\n'
            '2. Địa chỉ IP server chính xác\n'
            '3. Server đang chạy',
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Load các bài học đã hoàn thành từ SharedPreferences
  Future<void> _loadCompletedLessons() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList('completedLessons') ?? [];
      completedLessons.value = saved.toSet();
    } catch (e) {
      print("Error loading completed lessons: $e");
    }
  }

  /// Lưu lại danh sách bài học hoàn thành
  Future<void> _saveCompletedLessons() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('completedLessons', completedLessons.toList());
    } catch (e) {
      print("Error saving completed lessons: $e");
    }
  }

  /// Toggle trạng thái hoàn thành cho bài học
  void toggleComplete(String lessonTitle) {
    if (completedLessons.contains(lessonTitle)) {
      completedLessons.remove(lessonTitle);
    } else {
      completedLessons.add(lessonTitle);
    }
    _saveCompletedLessons();
  }

  /// Kiểm tra xem bài học đã hoàn thành hay chưa
  bool isCompleted(String lessonTitle) => completedLessons.contains(lessonTitle);

  /// Tính tiến độ hoàn thành (%)
  double getProgress() {
    int totalLessons = chapters.fold(0, (sum, chapter) => sum + chapter.lessons.length);
    if (totalLessons == 0) return 0.0;

    int doneLessons = chapters.fold(
      0,
          (sum, chapter) =>
      sum + chapter.lessons.where((lesson) => completedLessons.contains(lesson.title)).length,
    );

    return doneLessons / totalLessons;
  }
}
