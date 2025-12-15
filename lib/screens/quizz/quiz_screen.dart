import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/planet_model.dart';
import '../../services/planet_service.dart';
import 'quiz_setup_screen.dart';


const Color quizDarkColor = Color(0xFF05052B);
const Color quizHighlightColor = Color(0xFF00E5FF);

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PlanetService planetService = PlanetService();
    final paddingTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "THỬ THÁCH KHÔNG GIAN",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontSize: 22,
              shadows: [
                // Bóng chữ màu xanh sáng
                Shadow(blurRadius: 15, color: quizHighlightColor, offset: Offset(0,2))
              ]
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // ===== BACKGROUND =====
          Positioned.fill(
            child: Image.asset(
              "assets/images/space1.png",
              fit: BoxFit.cover,
              // Phủ lớp màu #05052b nhẹ lên toàn bộ nền để đồng bộ
              color: quizDarkColor.withOpacity(0.6),
              colorBlendMode: BlendMode.hardLight,
            ),
          ),

          // Đốm sáng nền
          Positioned(
              top: -100, right: -100,
              child: Container(
                width: 350, height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                      colors: [
                        quizHighlightColor.withOpacity(0.15),
                        Colors.transparent
                      ]
                  ),
                ),
              )
          ),

          // ===== CONTENT =====
          Padding(
            padding: EdgeInsets.only(top: paddingTop + 60),
            child: FutureBuilder<List<PlanetModel>>(
              future: planetService.getAllPlanets(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: quizHighlightColor,
                      strokeWidth: 3,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Lỗi tải dữ liệu", style: TextStyle(color: Colors.white)));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Chưa có dữ liệu", style: TextStyle(color: Colors.white)));
                }

                final planets = snapshot.data!;

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                  physics: const BouncingScrollPhysics(),
                  itemCount: planets.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final planet = planets[index];
                    return _QuizPlanetItem(planet: planet);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizPlanetItem extends StatelessWidget {
  final PlanetModel planet;

  const _QuizPlanetItem({required this.planet});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuizSetupScreen(planet: planet),
          ),
        );
      },
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            // Bóng đổ đậm màu tối #05052b
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
            // Viền sáng nhẹ bao quanh bóng
            BoxShadow(
                color: quizHighlightColor.withOpacity(0.1),
                blurRadius: 20, spreadRadius: -5
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                // Gradient bắt đầu từ màu bạn chọn #05052b
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    quizDarkColor.withOpacity(0.95), // Màu #05052b đậm đặc
                    quizDarkColor.withOpacity(0.7),  // Màu #05052b nhạt hơn chút
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                // Viền mỏng màu Cyan để tách biệt thẻ với nền đen
                border: Border.all(
                  color: quizHighlightColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // ===== IMAGE =====
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow sau ảnh
                      Container(
                        width: 55, height: 55,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: quizHighlightColor.withOpacity(0.2),
                                  blurRadius: 30, spreadRadius: 5
                              )
                            ]
                        ),
                      ),
                      Hero(
                        tag: "quiz_${planet.planetId}",
                        child: Image.asset(
                          planet.media.image2d,
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 20),

                  // ===== TEXT =====
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          planet.nameVi.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.directions_run_outlined, color: quizHighlightColor, size: 14),
                            const SizedBox(width: 5),
                            Text(
                              "Bắt đầu thử thách",
                              style: const TextStyle(
                                  color: quizHighlightColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ===== PLAY BUTTON =====
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1), // Nền nút trong suốt nhẹ
                        shape: BoxShape.circle,
                        border: Border.all(color: quizHighlightColor), // Viền nút màu Cyan
                        boxShadow: [
                          BoxShadow(
                              color: quizHighlightColor.withOpacity(0.2),
                              blurRadius: 10
                          )
                        ]
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: quizHighlightColor,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}