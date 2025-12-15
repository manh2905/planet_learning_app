import 'dart:ui';
import 'package:flutter/material.dart';

import '../../models/planet_model.dart';
import 'quiz_play_screen.dart';


const Color appDarkColor = Color(0xFF05052B);
const Color appHighlightColor = Color(0xFF00E5FF);
const Color appCorrectColor = Color(0xFF00E676);
const Color appWrongColor = Color(0xFFFF5252);

class QuizResultScreen extends StatelessWidget {
  final PlanetModel planet;
  final int totalQuestions;
  final int correctAnswers;
  final int timeLimit;

  const QuizResultScreen({
    super.key,
    required this.planet,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeLimit,
  });

  double get scorePercent => totalQuestions == 0 ? 0 : correctAnswers / totalQuestions;

  // Lời nhận xét dựa trên điểm số
  String get resultTitle {
    if (scorePercent >= 0.9) return "HUYỀN THOẠI! 🏆";
    if (scorePercent >= 0.7) return "XUẤT SẮC! 🚀";
    if (scorePercent >= 0.5) return "RẤT TỐT! ⭐";
    return "CỐ GẮNG HƠN NHÉ! 💪";
  }

  String get resultMessage {
    if (scorePercent >= 0.9) return "Kiến thức vũ trụ của bạn thật đáng kinh ngạc.";
    if (scorePercent >= 0.7) return "Bạn đã nắm vững rất nhiều kiến thức.";
    if (scorePercent >= 0.5) return "Một kết quả không tệ, hãy tiếp tục phát huy.";
    return "Đừng nản lòng, hãy thử lại để ghi nhớ tốt hơn.";
  }

  @override
  Widget build(BuildContext context) {
    final int percent = (scorePercent * 100).toInt();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "TỔNG KẾT NHIỆM VỤ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Tắt nút back mặc định
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

          // Glow hiệu ứng nền
          Positioned(
              top: -100, right: -100,
              child: Container(
                width: 400, height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                      colors: [appHighlightColor.withOpacity(0.15), Colors.transparent]
                  ),
                ),
              )
          ),

          // ===== 2. MAIN CARD =====
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            appDarkColor.withOpacity(0.9),
                            const Color(0xFF1A1A2E).withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: appHighlightColor.withOpacity(0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 30, offset: const Offset(0, 10)
                          )
                        ]
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // --- HEADER PLANET ---
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 70, height: 70,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: appHighlightColor.withOpacity(0.3),
                                        blurRadius: 30, spreadRadius: 5
                                    )
                                  ]
                              ),
                            ),
                            Image.asset(
                              planet.media.image2d,
                              width: 80, height: 80,
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // --- SCORE CIRCLE ---
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Vòng tròn nền
                            SizedBox(
                              width: 140, height: 140,
                              child: CircularProgressIndicator(
                                value: 1.0,
                                strokeWidth: 10,
                                valueColor: AlwaysStoppedAnimation(Colors.white.withOpacity(0.1)),
                              ),
                            ),
                            // Vòng tròn điểm số
                            SizedBox(
                              width: 140, height: 140,
                              child: CircularProgressIndicator(
                                value: scorePercent,
                                strokeWidth: 10,
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation(
                                    scorePercent >= 0.5 ? appCorrectColor : appWrongColor
                                ),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            // Số % ở giữa
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "$percent%",
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900,
                                    color: scorePercent >= 0.5 ? appCorrectColor : appWrongColor,
                                  ),
                                ),
                                const Text(
                                  "ĐIỂM SỐ",
                                  style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 10,
                                      letterSpacing: 1
                                  ),
                                )
                              ],
                            )
                          ],
                        ),

                        const SizedBox(height: 25),

                        // --- TEXT RESULT ---
                        Text(
                          resultTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          resultMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 30),
                        const Divider(color: Colors.white12),
                        const SizedBox(height: 20),

                        // --- STATISTICS GRID ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem("TỔNG CÂU", "$totalQuestions", Colors.blueAccent),
                            _buildStatItem("ĐÚNG", "$correctAnswers", appCorrectColor),
                            _buildStatItem("SAI", "${totalQuestions - correctAnswers}", appWrongColor),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // --- BUTTONS ---
                        // Nút Làm lại
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => QuizPlayScreen(
                                  planet: planet,
                                  questionCount: totalQuestions,
                                  timeLimit: timeLimit,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF2979FF), appHighlightColor],
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                      color: appHighlightColor.withOpacity(0.3),
                                      blurRadius: 10, offset: const Offset(0, 4)
                                  )
                                ]
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "THỬ THÁCH LẠI",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15, letterSpacing: 1
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Nút Về trang chủ
                        GestureDetector(
                          onTap: () {
                            // Quay về màn hình đầu tiên (thường là Home hoặc Danh sách Quiz)
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.white24)
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "QUAY VỀ DANH SÁCH",
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị cột thống kê nhỏ
  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5
          ),
        ),
      ],
    );
  }
}