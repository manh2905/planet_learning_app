import 'package:cloud_firestore/cloud_firestore.dart';

class QuizQuestionModel {
  final String id;
  final String planet;
  final String question;
  final List<String> options;
  final int correctIndex;

  QuizQuestionModel({
    required this.id,
    required this.planet,
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  factory QuizQuestionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return QuizQuestionModel(
      id: doc.id,
      planet: data['planet'], 
      question: data['question'],
      options: List<String>.from(data['options']),
      correctIndex: data['correctIndex'],
    );
  }
}
