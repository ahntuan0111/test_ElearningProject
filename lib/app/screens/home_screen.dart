import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import 'subject_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  HomeScreen({super.key});

  final List<int> grades = [6, 7, 8, 9];
  final List<String> subjects = ['Toán', 'Lý', 'Văn', 'Anh'];
  final Map<String, IconData> subjectIcons = {
    'Toán': Icons.calculate,
    'Lý': Icons.science,
    'Văn': Icons.menu_book,
    'Anh': Icons.language,
  };
  final List<Color> gradeColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lời chào
            Obx(() => Text(
              "Xin chào, ${userController.userName.value.isEmpty ? "Người dùng" : userController.userName.value} 👋",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            )),
            const SizedBox(height: 8),
            const Text(
              "Chào mừng bạn quay trở lại E-learning App!",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Dashboard Cards với animation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDashboardCard(
                    title: "Quiz", value: "12", icon: Icons.quiz, color: Colors.blue),
                _buildDashboardCard(
                    title: "Videos", value: "8", icon: Icons.play_circle_fill, color: Colors.green),
                _buildDashboardCard(
                    title: "Điểm cao", value: "95", icon: Icons.star, color: Colors.orange),
              ],
            ),
            const SizedBox(height: 32),

            // Danh sách lớp học
            for (var i = 0; i < grades.length; i++) ...[
              _buildGradeSection(grades[i], gradeColors[i]),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  /// Dashboard Cards với animation mượt mà
  Widget _buildDashboardCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, double scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 115,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 40),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Xây dựng phần từng lớp học
  Widget _buildGradeSection(int grade, Color gradeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Lớp $grade",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: gradeColor,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: subjects.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 2.2,
          ),
          itemBuilder: (context, index) {
            return _buildSubjectCard(subjects[index], grade, gradeColor, index);
          },
        ),
      ],
    );
  }

  /// Subject Card với hiệu ứng click và icon to hơn
  Widget _buildSubjectCard(String subject, int grade, Color gradeColor, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + index * 150),
      curve: Curves.easeOutBack,
      builder: (context, double scale, child) {
        return Transform.scale(
          scale: scale,
          child: InkWell(
            onTap: () {
              Get.to(() => SubjectDetailScreen(grade: grade, subject: subject));
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: gradeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: gradeColor.withOpacity(0.4)),
                boxShadow: [
                  BoxShadow(
                    color: gradeColor.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(subjectIcons[subject], color: gradeColor, size: 32),
                  const SizedBox(width: 10),
                  Text(
                    subject,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: gradeColor,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
