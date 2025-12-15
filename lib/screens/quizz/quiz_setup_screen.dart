import 'package:flutter/material.dart';
import 'dart:ui';
import '../../models/planet_model.dart';
import 'quiz_play_screen.dart';


const Color appDarkColor = Color(0xFF05052B);
const Color appHighlightColor = Color(0xFF00E5FF);
const Color appAccentColor = Color(0xFF2979FF);

class QuizSetupScreen extends StatefulWidget {
  final PlanetModel planet;

  const QuizSetupScreen({super.key, required this.planet});

  @override
  State<QuizSetupScreen> createState() => _QuizSetupScreenState();
}

class _QuizSetupScreenState extends State<QuizSetupScreen> {
  int selectedQuestionCount = 5;
  int selectedTime = 60; // giây

  @override
  Widget build(BuildContext context) {
    final planet = widget.planet;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "THIẾT LẬP NHIỆM VỤ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white,
            shadows: [
              const Shadow(blurRadius: 10, color: appHighlightColor, offset: Offset(0, 2))
            ],
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // ===== 1. BACKGROUND=====
          Positioned.fill(
            child: Image.asset(
              "assets/images/space1.png",
              fit: BoxFit.cover,
              color: appDarkColor.withOpacity(0.6),
              colorBlendMode: BlendMode.hardLight,
            ),
          ),

          // Hiệu ứng ánh sáng nền
          Positioned(
              top: 100, left: -50,
              child: Container(
                width: 300, height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                      colors: [
                        appHighlightColor.withOpacity(0.15),
                        Colors.transparent
                      ]
                  ),
                ),
              )
          ),

          // ===== 2. MAIN CARD =====
          Center(
            child: SingleChildScrollView( // Thêm scroll để tránh lỗi trên màn hình nhỏ
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        // Gradient nền thẻ tối
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              appDarkColor.withOpacity(0.9),
                              Colors.black.withOpacity(0.7),
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
                                blurRadius: 20, offset: const Offset(0, 10)
                            )
                          ]
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // --- ẢNH HÀNH TINH (Có hào quang) ---
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 90, height: 90,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          color: appHighlightColor.withOpacity(0.3),
                                          blurRadius: 40, spreadRadius: 5
                                      )
                                    ]
                                ),
                              ),
                              Image.asset(
                                planet.media.image2d,
                                width: 120,
                                height: 120,
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          Text(
                            "MỤC TIÊU: ${planet.nameVi.toUpperCase()}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                shadows: [Shadow(color: Colors.black, blurRadius: 4, offset: Offset(2,2))]
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Cấu hình bài kiểm tra kiến thức",
                            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                          ),

                          const SizedBox(height: 30),
                          const Divider(color: Colors.white24),
                          const SizedBox(height: 20),

                          // ===== SỐ CÂU HỎI =====
                          _buildSectionTitle("SỐ LƯỢNG CÂU HỎI", Icons.quiz),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [5, 10, 15].map((count) {
                              return _buildCustomOption(
                                label: "$count câu",
                                isSelected: selectedQuestionCount == count,
                                onTap: () => setState(() => selectedQuestionCount = count),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 30),

                          // ===== THỜI GIAN =====
                          _buildSectionTitle("GIỚI HẠN THỜI GIAN", Icons.timer),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [60, 120, 180].map((time) {
                              return _buildCustomOption(
                                label: "${time ~/ 60} phút",
                                isSelected: selectedTime == time,
                                onTap: () => setState(() => selectedTime = time),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 40),

                          // ===== START BUTTON =====
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => QuizPlayScreen(
                                    planet: planet,
                                    questionCount: selectedQuestionCount,
                                    timeLimit: selectedTime,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 55,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [appAccentColor, appHighlightColor],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: appHighlightColor.withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "BẮT ĐẦU NGAY",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.rocket_launch, color: Colors.white, size: 20),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- Widget tiêu đề mục ---
  Widget _buildSectionTitle(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: appHighlightColor, size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: appHighlightColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  // --- Widget Nút chọn tùy chỉnh (Thay thế ChoiceChip) ---
  Widget _buildCustomOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? appHighlightColor.withOpacity(0.2) // Nền sáng khi chọn
                : Colors.white.withOpacity(0.05),    // Nền tối khi không chọn
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? appHighlightColor : Colors.white24,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: appHighlightColor.withOpacity(0.2),
                blurRadius: 8,
              )
            ] : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}