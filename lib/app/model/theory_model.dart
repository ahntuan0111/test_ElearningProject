class Lesson {
  final String title;
  final String content;
  final String videoUrl;

  Lesson({
    required this.title,
    required this.content,
    required this.videoUrl,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      title: json['title'],
      content: json['content'],
      videoUrl: json['videoUrl'],
    );
  }
}

class Chapter {
  final String title;
  final List<Lesson> lessons;

  Chapter({required this.title, required this.lessons});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      title: json['title'],
      lessons: List<Lesson>.from(
        json['lessons'].map((lesson) => Lesson.fromJson(lesson)),
      ),
    );
  }
}
