import 'package:flutter/material.dart';
import 'dart:ui'; // Cần import để dùng ImageFilter
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/auth_service.dart';
import '../../services/quiz_result_service.dart';
import 'login_screen.dart';
import 'register_screen.dart';

/// --- BẢNG MÀU ĐỒNG BỘ ---
const Color appDarkColor = Color(0xFF05052B);
const Color appHighlightColor = Color(0xFF00E5FF);
const Color appCorrectColor = Color(0xFF00E676); // Màu Đạt (Green)
const Color appWrongColor = Color(0xFFFF5252);   // Màu Trượt (Red)

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AuthService _auth = AuthService();
  final QuizResultService _quizService = QuizResultService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "HỒ SƠ PHI HÀNH GIA",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontSize: 18,
              shadows: [Shadow(color: appHighlightColor, blurRadius: 10)]
          ),
        ),
        centerTitle: true,
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

          // Glow nền trang trí
          Positioned(
              top: -50, left: -50,
              child: Container(
                width: 300, height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                      colors: [appHighlightColor.withOpacity(0.15), Colors.transparent]
                  ),
                ),
              )
          ),

          // ===== 2. AUTH STATE =====
          StreamBuilder<User?>(
            stream: _auth.authStateChanges,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: appHighlightColor),
                );
              }

              if (snapshot.hasData) {
                return _buildLoggedInView(snapshot.data!);
              } else {
                return _buildGuestView();
              }
            },
          ),
        ],
      ),
    );
  }

  // =====================================================
  // GUEST VIEW (Giao diện khách)
  // =====================================================
  Widget _buildGuestView() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon tên lửa
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                    border: Border.all(color: appHighlightColor.withOpacity(0.5)),
                    boxShadow: [
                      BoxShadow(
                          color: appHighlightColor.withOpacity(0.2),
                          blurRadius: 40, spreadRadius: 5
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.rocket_launch_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "CHÀO MỪNG!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Đăng nhập để lưu lại hành trình khám phá vũ trụ của bạn.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),
                const SizedBox(height: 35),

                // Nút Đăng nhập
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appHighlightColor,
                      foregroundColor: Colors.black,
                      elevation: 10,
                      shadowColor: appHighlightColor.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "ĐĂNG NHẬP",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Nút Đăng ký
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: appHighlightColor),
                      foregroundColor: appHighlightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "TẠO TÀI KHOẢN",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // LOGGED IN VIEW (Giao diện đã đăng nhập)
  Widget _buildLoggedInView(User user) {
    final displayName = user.displayName ?? "Phi hành gia";
    final email = user.email ?? "";

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 100, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ===== 1. AVATAR GLOW =====
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 110, height: 110,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: appHighlightColor.withOpacity(0.5),
                          blurRadius: 50, spreadRadius: 1
                      )
                    ]
                ),
              ),
              CircleAvatar(
                radius: 55,
                backgroundColor: const Color(0xFF1A1A2E),
                backgroundImage: const AssetImage("assets/images/earth.png"),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ===== 2. USER INFO =====
          Text(
            displayName.toUpperCase(),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                shadows: [Shadow(color: Colors.black, blurRadius: 5)]
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              email,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),

          const SizedBox(height: 40),

          // ===== 3. HISTORY HEADER =====
          Row(
            children: [
              const Icon(Icons.history_edu, color: appHighlightColor),
              const SizedBox(width: 10),
              const Text(
                "NHẬT KÝ NHIỆM VỤ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // ===== 4. HISTORY LIST =====
          FutureBuilder<QuerySnapshot>(
            future: _quizService.getQuizHistoryByUser(),
            builder: (context, snapshot) {
              // Loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(color: appHighlightColor),
                );
              }

              // Error
              if (snapshot.hasError) {
                return Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.redAccent),
                  ),
                  child: Text(
                    "Lỗi tải dữ liệu: ${snapshot.error}",
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              // Empty
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(30),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.inbox, color: Colors.white24, size: 40),
                      SizedBox(height: 10),
                      Text(
                        "Chưa có dữ liệu bài làm",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ],
                  ),
                );
              }

              final docs = snapshot.data!.docs;

              return ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: docs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _buildQuizHistoryCard(docs[index]);
                },
              );
            },
          ),

          const SizedBox(height: 40),

          // ===== 5. LOGOUT BUTTON =====
          SizedBox(
            width: double.infinity,
            height: 55,
            child: TextButton.icon(
              onPressed: () async {
                await _auth.logout();
              },
              icon: const Icon(Icons.logout_rounded, color: appWrongColor),
              label: const Text(
                "ĐĂNG XUẤT",
                style: TextStyle(color: appWrongColor, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
              style: TextButton.styleFrom(
                backgroundColor: appWrongColor.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: appWrongColor.withOpacity(0.3))
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  // QUIZ HISTORY CARD

  Widget _buildQuizHistoryCard(QueryDocumentSnapshot doc) {
    final planetName = doc['planetName'] ?? 'Không tên';
    final correct = doc['correctAnswers'] ?? 0;
    final total = doc['totalQuestions'] ?? 0;

    // Lấy phần trăm điểm (0.0 -> 1.0)
    final double scoreVal = (doc['scorePercent'] as num).toDouble();
    final String percentText = (scoreVal * 100).toStringAsFixed(0);

    // Logic Đậu/Rớt: >= 50% là Đậu
    final bool isPass = scoreVal >= 0.5;

    Timestamp? ts = doc['createdAt'];
    final date = ts != null
        ? DateTime.fromMillisecondsSinceEpoch(ts.millisecondsSinceEpoch)
        : DateTime.now();

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
            // Gradient nhẹ cho thẻ
            gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // 1. Icon Hành tinh
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: appHighlightColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.public, color: appHighlightColor, size: 24),
                ),

                const SizedBox(width: 15),

                // 2. Thông tin chính
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        planetName.toString().toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${_formatDate(date)}",
                        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
                      ),
                      const SizedBox(height: 4),
                      // Hiển thị số câu đúng/sai
                      Row(
                        children: [
                          Text("Đúng: $correct/$total", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                ),

                // 3. Kết quả & Icon Pass/Fail
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Điểm số %
                    Text(
                      "$percentText%",
                      style: TextStyle(
                        color: isPass ? appCorrectColor : appWrongColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Icon trạng thái (Yêu cầu của bạn)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: isPass ? appCorrectColor.withOpacity(0.2) : appWrongColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: isPass ? appCorrectColor.withOpacity(0.5) : appWrongColor.withOpacity(0.5),
                              width: 1
                          )
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                              isPass ? Icons.check_circle : Icons.cancel,
                              size: 14,
                              color: isPass ? appCorrectColor : appWrongColor
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isPass ? "ĐẠT" : "KHÔNG ĐẠT",
                            style: TextStyle(
                                color: isPass ? appCorrectColor : appWrongColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}