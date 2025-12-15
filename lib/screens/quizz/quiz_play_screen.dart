import 'dart:async';
import 'dart:ui'; // Để dùng ImageFilter
import 'package:flutter/material.dart';
import 'quiz_result_screen.dart';
import '../../models/planet_model.dart';
import '../../models/quiz_question_model.dart';
import '../../services/quiz_service.dart';
import '../../services/quiz_result_service.dart';


const Color appDarkColor = Color(0xFF05052B);
const Color appHighlightColor = Color(0xFF00E5FF);
const Color appCorrectColor = Color(0xFF00E676); // Xanh lá (Đúng)
const Color appWrongColor = Color(0xFFFF5252);   // Đỏ (Sai)

class QuizPlayScreen extends StatefulWidget {
  final PlanetModel planet;
  final int questionCount;
  final int timeLimit; // giây

  const QuizPlayScreen({
    super.key,
    required this.planet,
    required this.questionCount,
    required this.timeLimit,
  });

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  final QuizService _quizService = QuizService();
  final QuizResultService _resultService = QuizResultService();

  // Biến Future để giữ dữ liệu, tránh load lại khi setState
  late Future<List<QuizQuestionModel>> _questionsFuture;

  List<QuizQuestionModel> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int _remainingTime = 0;
  Timer? _timer;

  int? _selectedIndex;
  bool _isAnswered = false; // Đã chọn đáp án chưa?
  bool _isLoading = true;   // Đang tải câu hỏi?

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.timeLimit;

    // Khởi tạo việc tải câu hỏi ngay khi vào màn hình
    _questionsFuture = _quizService.getQuestions(
      planetNameEn: widget.planet.nameEn,
      limit: widget.questionCount,
    );

    // Xử lý sau khi tải xong để bắt đầu tính giờ
    _questionsFuture.then((data) {
      if (mounted) {
        setState(() {
          _questions = data;
          _isLoading = false;
        });
        if (_questions.isNotEmpty) {
          _startTimer();
        }
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime <= 0) {
        timer.cancel();
        _finishQuiz();
      } else {
        setState(() {
          _remainingTime--;
        });
      }
    });
  }

  void _onAnswerSelected(int index) {
    if (_isAnswered) return; // Chặn nếu đã chọn rồi

    setState(() {
      _selectedIndex = index;
      _isAnswered = true;

      if (index == _questions[_currentIndex].correctIndex) {
        _score++;
      }
    });

    // Chuyển câu sau 1.5s để người dùng kịp nhìn đáp án đúng/sai
    Future.delayed(const Duration(milliseconds: 1500), _nextQuestion);
  }

  void _nextQuestion() {
    if (!mounted) return;

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedIndex = null;
        _isAnswered = false;
      });
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() async {
    _timer?.cancel();

    // Hiển thị dialog loading trong lúc lưu kết quả
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => const Center(child: CircularProgressIndicator(color: appHighlightColor)),
    );

    try {
      await _resultService.saveQuizResultAndUpdateUser(
        planetId: widget.planet.planetId,
        planetName: widget.planet.nameVi,
        totalQuestions: _questions.length,
        correctAnswers: _score,
        timeLimit: widget.timeLimit,
      );
    } catch (e) {
      debugPrint("Lỗi lưu quiz: $e");
    }

    if (!mounted) return;
    Navigator.pop(context); // Tắt dialog loading

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultScreen(
          planet: widget.planet,
          totalQuestions: _questions.length,
          correctAnswers: _score,
          timeLimit: widget.timeLimit,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tính toán tiến độ
    double progress = 0;
    if (_questions.isNotEmpty) {
      progress = (_currentIndex + 1) / _questions.length;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Tự xử lý nút back nếu cần
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Nút thoát
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white70),
              onPressed: () {
                _timer?.cancel();
                Navigator.pop(context);
              },
            ),
            // Đồng hồ đếm ngược
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _remainingTime < 10 ? appWrongColor : appHighlightColor,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                      Icons.timer_outlined,
                      color: _remainingTime < 10 ? appWrongColor : appHighlightColor,
                      size: 18
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "$_remainingTime s",
                    style: TextStyle(
                      color: _remainingTime < 10 ? appWrongColor : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            // Điểm số hiện tại
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: appCorrectColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Score: $_score",
                style: const TextStyle(color: appCorrectColor, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // ===== 1. BACKGROUND =====
          Positioned.fill(
            child: Image.asset(
              "assets/images/space1.png",
              fit: BoxFit.cover,
              color: appDarkColor.withOpacity(0.7),
              colorBlendMode: BlendMode.hardLight,
            ),
          ),

          // ===== 2. CONTENT =====
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: appHighlightColor))
          else if (_questions.isEmpty)
            const Center(child: Text("Không tải được câu hỏi", style: TextStyle(color: Colors.white)))
          else
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 60),

                // PROGRESS BAR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white10,
                      valueColor: const AlwaysStoppedAnimation<Color>(appHighlightColor),
                      minHeight: 6,
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                Text(
                  "Câu hỏi ${_currentIndex + 1}/${_questions.length}",
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                ),

                const SizedBox(height: 20),

                // QUESTION CARD (Expanded để đẩy câu hỏi ra giữa)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // Hộp câu hỏi
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                  color: const Color(0xFF1A1A2E).withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 15, offset: const Offset(0, 5)
                                    )
                                  ]
                              ),
                              child: Text(
                                _questions[_currentIndex].question,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // OPTIONS LIST
                        ...List.generate(_questions[_currentIndex].options.length, (index) {
                          return _buildAnswerButton(
                              index,
                              _questions[_currentIndex].options[index],
                              _questions[_currentIndex].correctIndex
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
        ],
      ),
    );
  }

  // --- Widget Nút trả lời ---
  Widget _buildAnswerButton(int index, String text, int correctIndex) {
    // Xác định trạng thái màu sắc
    Color borderColor = Colors.white.withOpacity(0.1);
    Color bgColor = Colors.white.withOpacity(0.05);
    Color textColor = Colors.white;
    IconData? icon;
    Color iconColor = Colors.transparent;

    if (_isAnswered) {
      if (index == correctIndex) {
        // Đáp án ĐÚNG -> Màu xanh lá
        borderColor = appCorrectColor;
        bgColor = appCorrectColor.withOpacity(0.2);
        icon = Icons.check_circle;
        iconColor = appCorrectColor;
      } else if (index == _selectedIndex) {
        // Đã chọn nhưng SAI -> Màu đỏ
        borderColor = appWrongColor;
        bgColor = appWrongColor.withOpacity(0.2);
        icon = Icons.cancel;
        iconColor = appWrongColor;
      } else {
        // Các đáp án còn lại -> Làm mờ đi
        textColor = Colors.white38;
      }
    }

    return GestureDetector(
      onTap: () => _onAnswerSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: _isAnswered && (index == correctIndex || index == _selectedIndex)
              ? [BoxShadow(color: borderColor.withOpacity(0.3), blurRadius: 10)]
              : [],
        ),
        child: Row(
          children: [
            // Ký tự A, B, C, D
            Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                String.fromCharCode(65 + index), // 65 là mã ASCII của 'A'
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(width: 15),

            // Nội dung đáp án
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Icon đúng sai
            if (icon != null)
              Icon(icon, color: iconColor),
          ],
        ),
      ),
    );
  }
}