import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class SubjectDetailScreen extends StatelessWidget {
  final int grade;
  final String subject;

  const SubjectDetailScreen({
    super.key,
    required this.grade,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> featureCards = [
      {
        "title": "Lý thuyết",
        "icon": Icons.menu_book_rounded,
        "color": Colors.blue,
        "onTap": () {
          // TODO: Mở trang lý thuyết
          Get.toNamed(
            AppRoutes.theory,
            arguments: {
              'subject': subject,
              'grade': grade,
            },
          );
        }
      },
      {
        "title": "Giải bài tập",
        "icon": Icons.edit_document,
        "color": Colors.green,
        "onTap": () {
          // TODO: Mở trang giải bài tập
        }
      },
      {
        "title": "Quiz",
        "icon": Icons.quiz_rounded,
        "color": Colors.orange,
        "onTap": () {
          // TODO: Mở quiz liên quan
        }
      },
      {
        "title": "Bộ đề thi",
        "icon": Icons.article_rounded,
        "color": Colors.purple,
        "onTap": () {
          // TODO: Mở bộ đề thi
        }
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Khối $grade - $subject"),
        backgroundColor: Colors.red,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$subject cho Khối $grade",
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

            // Dùng GridView để hiển thị 4 Card gọn gàng
            Expanded(
              child: GridView.builder(
                itemCount: featureCards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 card mỗi hàng
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
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            colors: [
                              card["color"].withOpacity(0.1),
                              card["color"].withOpacity(0.25),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
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
                                  color: card["color"].shade700,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.15),
                                      offset: const Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
