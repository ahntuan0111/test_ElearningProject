class Exercise {
  final String id;
  final String question;
  final String solution;

  Exercise({
    required this.id,
    required this.question,
    required this.solution,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json["id"].toString(),
      question: json["question"] ?? "",
      solution: json["solution"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "question": question,
      "solution": solution,
    };
  }
}
