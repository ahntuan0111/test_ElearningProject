import 'package:get/get.dart';
import '../screens/course_screen.dart';
import '../screens/login_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/register_screen.dart';
import '../screens/main_screen.dart';
import '../screens/subject_detail_screen.dart';
import '../screens/theory_screen.dart';
import '../screens/lesson_detail_screen.dart';
import '../screens/quiz_detail_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.main,
      page: () => MainScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterScreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.subjectDetail,
      page: () {
        final args = Get.arguments ?? {};
        return SubjectDetailScreen(
          grade: args['grade'] ?? 6,
          subject: args['subject'] ?? 'Toán',
        );
      },
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.course,
      page: () => CourseScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.theory,
      page: () {
        final args = Get.arguments ?? {};
        return TheoryScreen(
          subject: args['subject'] ?? 'Toán',
          grade: args['grade'] ?? 6,
        );
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.lessonDetail,
      page: () {
        final args = Get.arguments ?? {};
        return LessonDetailScreen(
          lessonTitle: args['lessonTitle'] ?? '',
          content: args['content'] ?? '',
          videoUrl: args['videoUrl'] ?? '',
        );
      },
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.quizDetail,
      page: () {
        final args = Get.arguments ?? {};
        return QuizDetailScreen(
          subject: args['subject'] ?? 'Toán',
          grade: args['grade'] ?? 6,
        );
      },
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.quiz,
      page: () => QuizScreen(),
      transition: Transition.cupertino,
    ),
  ];
}