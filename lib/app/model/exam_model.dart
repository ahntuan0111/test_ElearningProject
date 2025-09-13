class Exam {
  final String title;
  final String description;
  final String pdfPath;
  final String difficulty;
  final DateTime date;

  Exam({
    required this.title,
    required this.description,
    required this.pdfPath,
    required this.difficulty,
    required this.date,
  });

  // Chuyển đổi từ JSON
  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      pdfPath: json['pdfPath'] ?? '',
      difficulty: json['difficulty'] ?? 'Trung bình',
      date: DateTime.parse(json['date'] ?? DateTime.now().toString()),
    );
  }

  // Chuyển đổi sang JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'pdfPath': pdfPath,
      'difficulty': difficulty,
      'date': date.toIso8601String(),
    };
  }
}