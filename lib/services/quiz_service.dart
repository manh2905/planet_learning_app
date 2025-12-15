import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_question_model.dart';

class QuizService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<QuizQuestionModel>> getQuestions({
    required String planetNameEn,
    required int limit,
  }) async {
    final snapshot = await _db
        .collection('quizzes')
        .where('planet', isEqualTo: planetNameEn)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => QuizQuestionModel.fromFirestore(doc))
        .toList();
  }
}
