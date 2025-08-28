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
            Obx(() => Text(
              "Xin chào, ${userController.userName.value.isEmpty ? "Người dùng" : userController.userName.value} 👋",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            )),
            const SizedBox(height: 8),
            const Text(
              "Chào mừng bạn quay trở lại E-learning App!",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

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

            for (var i = 0; i < grades.length; i++) ...[
              _buildGradeSection(grades[i], gradeColors[i]),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      width: 105,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeSection(int grade, Color gradeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Lớp $grade",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: gradeColor),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: subjects.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2,
          ),
          itemBuilder: (context, index) {
            return _buildSubjectCard(subjects[index], grade, gradeColor);
          },
        ),
      ],
    );
  }

  Widget _buildSubjectCard(String subject, int grade, Color gradeColor) {
    return InkWell(
      onTap: () {
        Get.to(() => SubjectDetailScreen(grade: grade, subject: subject));
      },
      child: Container(
        decoration: BoxDecoration(
          color: gradeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: gradeColor.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 3)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(subjectIcons[subject], color: gradeColor),
            const SizedBox(width: 8),
            Text(
              subject,
              style: TextStyle(fontWeight: FontWeight.bold, color: gradeColor, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
