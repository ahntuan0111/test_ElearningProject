class Lesson {
  final String title;

  Lesson({required this.title});

  factory Lesson.fromJson(String title) {
    return Lesson(title: title);
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
