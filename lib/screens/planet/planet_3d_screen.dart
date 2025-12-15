import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui'; // Để dùng ImageFilter.blur
import 'ar_view_screen.dart';
import '../../models/planet_model.dart';

class Planet3DScreen extends StatelessWidget {
  final String planetId;

  const Planet3DScreen({
    super.key,
    required this.planetId,
  });

  Future<PlanetModel> _loadPlanet() async {
    final doc = await FirebaseFirestore.instance
        .collection('planets')
        .doc(planetId)
        .get();
    return PlanetModel.fromFirestore(doc.data()!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cho phép nội dung tràn lên sau AppBar
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: FutureBuilder<PlanetModel>(
        future: _loadPlanet(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Lỗi tải dữ liệu", style: TextStyle(color: Colors.white)));
          }

          final planet = snapshot.data!;

          return Stack(
            children: [
              // 1. HÌNH NỀN TOÀN MÀN HÌNH
              Positioned.fill(
                child: Image.asset(
                  'assets/images/space1.png', // Đảm bảo ảnh này tối màu hoặc thêm lớp phủ
                  fit: BoxFit.cover,
                ),
              ),

              // 2. NỘI DUNG CHÍNH
              Column(
                children: [
                  // --- PHẦN TRÊN: 3D MODEL ---
                  Expanded(
                    flex: 5, // Chiếm 5 phần màn hình
                    child: Stack(
                      children: [
                        // Model 3D
                        ModelViewer(
                          src: planet.media.model3d,
                          autoRotate: true,
                          cameraControls: true,
                          disableZoom: false,
                          backgroundColor: Colors.transparent,
                        ),

                      ],
                    ),
                  ),

                  // --- PHẦN DƯỚI: THÔNG TIN CHI TIẾT ---
                  Expanded(
                    flex: 6, // Chiếm 6 phần màn hình
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6), // Nền đen mờ
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        border: Border(
                          top: BorderSide(color: Colors.white.withOpacity(0.2)),
                        ),
                      ),
                      // Sử dụng ClipRRect và BackdropFilter để làm hiệu ứng kính mờ (Blur)
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header Tên & Mô tả ngắn
                                Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        planet.nameVi.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.cyanAccent,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        planet.shortDescription,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Nút AR Lớn
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.view_in_ar),
                                    label: const Text("TRẢI NGHIỆM AR", style: TextStyle(fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.cyanAccent,
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                      elevation: 10,
                                      shadowColor: Colors.cyanAccent.withOpacity(0.4),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => PlanetARScreen(
                                            modelPath: planet.media.model3d,
                                            planetName: planet.nameVi,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 25),

                                // GIỚI THIỆU CHUNG
                                const Text("TỔNG QUAN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 10),
                                Text(
                                  planet.overview,
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(color: Colors.white70, height: 1.5),
                                ),
                                const SizedBox(height: 25),

                                // LƯỚI THÔNG SỐ (GRID STATS)
                                const Text("THÔNG SỐ VẬT LÝ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 10),
                                GridView.count(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                  childAspectRatio: 1.8, // Chiều rộng / Chiều cao thẻ
                                  children: [
                                    _buildStatCard(Icons.public, "Bán kính", "${planet.physical.radiusKm} km"),
                                    _buildStatCard(Icons.scale, "Khối lượng", "${planet.physical.massKg} kg"), // Bạn có thể format lại số này cho gọn
                                    _buildStatCard(Icons.arrow_downward, "Trọng lực", "${planet.physical.gravity} m/s²"),
                                    _buildStatCard(Icons.thermostat, "Nhiệt độ", "${planet.physical.temperatureAvgC} °C"),
                                  ],
                                ),

                                const SizedBox(height: 25),

                                // THÔNG TIN QUỸ ĐẠO (Dạng Row)
                                _buildSectionTitle("QUỸ ĐẠO & KHÍ QUYỂN"),
                                _buildInfoRow("Khoảng cách MT", "${planet.orbit.distanceFromSunKm} km"),
                                _buildInfoRow("Chu kỳ quay", "${planet.orbit.orbitalPeriodDays} ngày"),
                                _buildInfoRow("Tự quay", "${planet.orbit.rotationPeriodHours} giờ"),
                                _buildInfoRow("Vệ tinh", "${planet.moons.count} (${planet.moons.names.join(', ')})"),
                                _buildInfoRow("Khí quyển", planet.atmosphere.mainGases.join(", ")),

                                const SizedBox(height: 25),

                                // ĐẶC ĐIỂM (Chips)
                                _buildSectionTitle("ĐẶC ĐIỂM NỔI BẬT"),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: planet.specialFeatures.map((e) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.cyanAccent.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                                    ),
                                    child: Text(e, style: const TextStyle(color: Colors.cyanAccent, fontSize: 12)),
                                  )).toList(),
                                ),

                                const SizedBox(height: 50), // Padding bottom
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // ---  Thẻ thông số (Stat Card) ---
  Widget _buildStatCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.cyanAccent, size: 20),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // --- WIDGET CON: Dòng thông tin (Row Info) ---
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}