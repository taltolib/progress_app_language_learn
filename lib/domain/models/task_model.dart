
class TaskModel {
  final int id;
  final String question;
  final List<String> answers;
  final int rightAnswer;


  TaskModel({
    required this.id,
    required this.question,
    required this.answers,
    required this.rightAnswer,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json["id"],
      question: json["question"],
      answers: List<String>.from(json["answers"]),
      rightAnswer: json["correctIndex"],
    );
  }
}
