import 'package:flutter/material.dart';
import 'dart:ui';
import '../../models/planet_model.dart';
import '../../services/planet_service.dart';
import '../planet/planet_3d_screen.dart';

/// --- BẢNG MÀU ĐỒNG BỘ ---
const Color appDarkColor = Color(0xFF05052B); // Xanh đen thẫm
const Color appHighlightColor = Color(0xFF00E5FF); // Cyan sáng

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final PlanetService _planetService = PlanetService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "KHÁM PHÁ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.white,
            shadows: [
              Shadow(blurRadius: 10, color: appHighlightColor, offset: Offset(0, 2))
            ],
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
              // Phủ màu xanh đen thẫm lên ảnh nền
              color: appDarkColor.withOpacity(0.6),
              colorBlendMode: BlendMode.hardLight,
            ),
          ),

          // ===== CONTENT =====
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 100, 16, 0),
            child: FutureBuilder<List<PlanetModel>>(
              future: _planetService.getAllPlanets(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: appHighlightColor),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      "Lỗi tải dữ liệu",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                final planets = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.70, // Chỉnh lại tỷ lệ cho thẻ dài hơn chút
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: planets.length,
                  itemBuilder: (context, index) {
                    return _buildPlanetCard(planets[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= PLANET CARD =================
  Widget _buildPlanetCard(PlanetModel planet) {
    return GestureDetector(
      onTap: () {
        // Chuyển hướng khi bấm vào toàn bộ thẻ
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Planet3DScreen(
              planetId: planet.planetId,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            // Bóng đổ đậm
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
            // Viền sáng nhẹ
            BoxShadow(
                color: appHighlightColor.withOpacity(0.1),
                blurRadius: 10, spreadRadius: -2
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                // Gradient nền thẻ: Xanh đen -> Trong suốt
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    appDarkColor.withOpacity(0.9),
                    appDarkColor.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: appHighlightColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // --- ẢNH HÀNH TINH ---
                  Expanded(
                    flex: 4,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Hào quang sau hành tinh
                        Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: appHighlightColor.withOpacity(0.2),
                                    blurRadius: 40, spreadRadius: 5
                                )
                              ]
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Hero(
                            tag: planet.planetId,
                            child: Image.asset(
                              planet.media.image2d,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- THÔNG TIN ---
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            planet.nameVi.toUpperCase(),
                            maxLines: 1,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                shadows: [Shadow(color: Colors.black, blurRadius: 2, offset: Offset(1,1))]
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            planet.shortDescription,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 11,
                            ),
                          ),
                          const Spacer(),

                          // NÚT CHI TIẾT (Trang trí)
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: appHighlightColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: appHighlightColor.withOpacity(0.5)),
                            ),
                            child: const Text(
                              "Khám phá",
                              style: TextStyle(
                                  color: appHighlightColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5
                              ),
                            ),
                          )
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
    );
  }
}