// lesson_model.dart
class Lesson {
  final int id;
  final String title;
  final String videoUrl;
  final String content; // tất cả text nối lại
  final String imageUrl; // lấy image đầu tiên nếu có

  Lesson({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.content,
    required this.imageUrl,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    final contents = json['contents'] as List<dynamic>? ?? [];

    String contentText = "";
    String image = "";

    for (var item in contents) {
      final type = item['contentType'] ?? item['type'];
      final value = item['contentValue'] ?? item['value'];
      if (type != null && value != null) {
        if (type.toString().toLowerCase() == 'text') {
          contentText += value + "\n";
        } else if (type.toString().toLowerCase() == 'image' && image.isEmpty) {
          image = value;
        }
      }
    }

    return Lesson(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      videoUrl: json['videoUrl'] ?? "",
      content: contentText.trim(),
      imageUrl: image,
    );
  }
}


