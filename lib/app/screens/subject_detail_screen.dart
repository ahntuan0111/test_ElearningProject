import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theory_controller.dart';
import '../controllers/quiz_controller.dart';
import '../routes/app_routes.dart';

class SubjectDetailScreen extends StatefulWidget {
  const SubjectDetailScreen({
    super.key,
    required this.grade,
    required this.subject,
  });

  final int grade;
  final String subject;

  @override
  State<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen> {
  final Color primaryGreen = const Color(0xFF4CAF50);
  late final TheoryController theoryController;
  late final QuizController quizController;

  @override
  void initState() {
    super.initState();
    theoryController = Get.put(TheoryController());
    quizController = Get.put(QuizController());
    theoryController.loadTheory(widget.subject, widget.grade);
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> featureCards = [
      {
        "title": "Lý thuyết",
        "icon": Icons.menu_book_rounded,
        "color": Colors.blue,
        "onTap": () {
          Get.toNamed(
            AppRoutes.theory,
            arguments: {'subject': widget.subject, 'grade': widget.grade},
          );
        }
      },
      {
        "title": "Giải bài tập",
        "icon": Icons.edit_document,
        "color": Colors.green,
        "onTap": () {
          // TODO: mở trang giải bài tập
        }
      },
      {
        "title": "Quiz",
        "icon": Icons.quiz_rounded,
        "color": Colors.orange,
        "onTap": () async {
          await quizController.loadQuiz(widget.subject, widget.grade);
          Get.toNamed(
            AppRoutes.quizDetail,
            arguments: {'subject': widget.subject, 'grade': widget.grade},
          );
        }
      },
      {
        "title": "Bộ đề thi",
        "icon": Icons.article_rounded,
        "color": Colors.purple,
        "onTap": () {
          Get.toNamed(
            AppRoutes.exam,
            arguments: {'subject': widget.subject, 'grade': widget.grade},
          );
        }
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Khối ${widget.grade} - ${widget.subject}"),
        backgroundColor: primaryGreen,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.subject} cho Khối ${widget.grade}",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Chọn nội dung bạn muốn học bên dưới:",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                itemCount: featureCards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.05,
                ),
                itemBuilder: (context, index) {
                  final card = featureCards[index];
                  return InkWell(
                    onTap: card["onTap"],
                    borderRadius: BorderRadius.circular(18),
                    splashColor: card["color"].withOpacity(0.2),
                    highlightColor: Colors.white.withOpacity(0.1),
                    child: Card(
                      elevation: 6,
                      shadowColor: card["color"].withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: card["color"].withOpacity(0.15),
                                boxShadow: [
                                  BoxShadow(
                                    color: card["color"].withOpacity(0.5),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Icon(
                                card["icon"],
                                size: 38,
                                color: card["color"],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              card["title"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: card["color"],
                              ),
                            ),
                            if (card["title"] == "Lý thuyết") ...[
                              const SizedBox(height: 12),
                              Obx(() {
                                double progress = theoryController.getProgress(widget.subject, widget.grade);
                                return Column(
                                  children: [
                                    LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 8,
                                      backgroundColor: card["color"].withOpacity(0.2),
                                      color: card["color"],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${(progress * 100).toStringAsFixed(0)}% Hoàn thành",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
