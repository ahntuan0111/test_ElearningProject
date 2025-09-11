class Exam {
  final String title;
  final String description;
  final String pdfPath;

  Exam({
    required this.title,
    required this.description,
    required this.pdfPath,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      title: json['title'],
      description: json['description'],
      pdfPath: json['pdfPath'],
    );
  }
}
