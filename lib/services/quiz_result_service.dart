import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizResultService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveQuizResultAndUpdateUser({
    required String planetId,
    required String planetName,
    required int totalQuestions,
    required int correctAnswers,
    required int timeLimit,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User chưa đăng nhập");
    }

    final uid = user.uid;
    final scorePercent = correctAnswers / totalQuestions;

    final WriteBatch batch = _db.batch();

    //  Lưu lịch sử quiz
    final quizResultRef = _db.collection('quiz_results').doc();
    batch.set(quizResultRef, {
      'userId': uid,
      'planetId': planetId,
      'planetName': planetName,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'scorePercent': scorePercent,
      'timeLimit': timeLimit,
      'createdAt': FieldValue.serverTimestamp(),
    });

    //  Update user tổng
    final userRef = _db.collection('users').doc(uid);
    batch.update(userRef, {
      'totalQuizDone': FieldValue.increment(1),
      'totalScore': FieldValue.increment(correctAnswers),
    });

    await batch.commit();
  }

  Future<QuerySnapshot> getQuizHistoryByUser() async {
    final user = _auth.currentUser;
    print("CURRENT UID: ${_auth.currentUser!.uid}");
    if (user == null) throw Exception("User chưa đăng nhập");

    return await _db
        .collection('quiz_results')
        .where('userId', isEqualTo: user.uid)
        // .orderBy('createdAt', descending: true)
        .get();
  }

}
