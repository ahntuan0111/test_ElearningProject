import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/exam_controller.dart';
import '../screens/exam_pdf_viewer.dart';
import '../model/exam_model.dart'; // Import model Exam từ file riêng

class ExamScreen extends StatefulWidget {
  final String subject;
  final int grade;

  const ExamScreen({super.key, required this.subject, required this.grade});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final ExamController controller = Get.put(ExamController());
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    controller.loadExams(widget.subject, widget.grade);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        controller.loadMoreExams(widget.subject, widget.grade);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<Exam> get _filteredExams {
    if (_searchQuery.isEmpty) return controller.exams;
    return controller.exams.where((exam) =>
        exam.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        exam.description.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: Text("Đề thi ${widget.subject} lớp ${widget.grade}"),
        backgroundColor: primaryGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ExamSearchDelegate(controller.exams),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm đề thi...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          // Filter chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              children: [
                FilterChip(
                  label: const Text('Tất cả'),
                  selected: true,
                  selectedColor: primaryGreen.withOpacity(0.2),
                  checkmarkColor: primaryGreen,
                  labelStyle: TextStyle(
                    color: primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (_) {
                    controller.loadExams(widget.subject, widget.grade);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Đề mới nhất'),
                  selectedColor: primaryGreen.withOpacity(0.2),
                  checkmarkColor: primaryGreen,
                  labelStyle: TextStyle(color: primaryGreen),
                  onSelected: (_) {
                    controller.sortExamsByDate();
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Đề khó'),
                  selectedColor: primaryGreen.withOpacity(0.2),
                  checkmarkColor: primaryGreen,
                  labelStyle: TextStyle(color: primaryGreen),
                  onSelected: (_) {
                    controller.filterExamsByDifficulty('Khó');
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.exams.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.exams.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        "Chưa có đề thi",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await controller.refreshExams(widget.subject, widget.grade);
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _filteredExams.length +
                      (controller.hasMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _filteredExams.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final exam = _filteredExams[index];
                    return _buildExamCard(exam, context);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildExamCard(Exam exam, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          if (exam.pdfPath.isNotEmpty) {
            Get.to(() => PDFReaderScreen(assetPath: exam.pdfPath));
          } else {
            Get.snackbar(
              "Lỗi",
              "Đường dẫn PDF không hợp lệ",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.picture_as_pdf,
                    color: Colors.green, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exam.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          "90 phút",
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.bar_chart,
                            size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          exam.difficulty,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

// Search delegate
class ExamSearchDelegate extends SearchDelegate {
  final List<Exam> exams;

  ExamSearchDelegate(this.exams);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = exams.where((exam) =>
        exam.title.toLowerCase().contains(query.toLowerCase()) ||
        exam.description.toLowerCase().contains(query.toLowerCase())).toList();

    return _buildSearchResults(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? exams
        : exams
            .where((exam) =>
                exam.title.toLowerCase().contains(query.toLowerCase()) ||
                exam.description
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();

    return _buildSearchResults(suggestions);
  }

  Widget _buildSearchResults(List<Exam> results) {
    if (results.isEmpty) {
      return const Center(
        child: Text('Không tìm thấy đề thi phù hợp'),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final exam = results[index];
        return ListTile(
          leading: const Icon(Icons.picture_as_pdf, color: Colors.green),
          title: Text(exam.title),
          subtitle: Text(exam.description),
          onTap: () {
            close(context, null);
            Get.to(() => PDFReaderScreen(assetPath: exam.pdfPath));
          },
        );
      },
    );
  }
}
