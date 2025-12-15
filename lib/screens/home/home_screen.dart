import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}


class PlanetData {
  final String name;
  final String description;
  final Color color;
  final double distanceFromSun;
  final double size; // Kích thước hiển thị
  final String imagePath; // Đường dẫn ảnh 2D

  PlanetData({
    required this.name,
    required this.description,
    required this.color,
    required this.distanceFromSun,
    required this.size,
    required this.imagePath,
  });
}


final List<PlanetData> planets = [
  PlanetData(
    name: "Sao Thủy",
    description:
    "Tên tiếng Anh là Mercury, là hành tinh thứ nhất tính từ Mặt Trời, có kích thước nhỏ nhất và chênh lệch nhiệt độ ngày đêm rất lớn.",
    color: Colors.grey,
    distanceFromSun: 180,
    size: 35,
    imagePath: "assets/images/mercury.png",
  ),
  PlanetData(
    name: "Sao Kim",
    description:
    "Tên tiếng Anh là Venus, là hành tinh thứ hai tính từ Mặt Trời, có nhiệt độ bề mặt cao nhất do hiệu ứng nhà kính mạnh.",
    color: Colors.orangeAccent,
    distanceFromSun: 320,
    size: 50,
    imagePath: "assets/images/venus.png",
  ),
  PlanetData(
    name: "Trái Đất",
    description:
    "Tên tiếng Anh là Earth, là hành tinh thứ ba tính từ Mặt Trời, là hành tinh duy nhất được biết đến có sự sống.",
    color: Colors.blue,
    distanceFromSun: 440,
    size: 52,
    imagePath: "assets/images/earth.png",
  ),
  PlanetData(
    name: "Sao Hỏa",
    description:
    "Tên tiếng Anh là Mars, là hành tinh thứ tư tính từ Mặt Trời, nổi bật với bề mặt màu đỏ và dấu hiệu từng có nước trong quá khứ.",
    color: Colors.redAccent,
    distanceFromSun: 560,
    size: 50,
    imagePath: "assets/images/mars.png",
  ),
  PlanetData(
    name: "Sao Mộc",
    description:
    "Tên tiếng Anh là Jupiter, là hành tinh thứ năm tính từ Mặt Trời, lớn nhất trong Hệ Mặt Trời và có Vết Đỏ Lớn nổi tiếng.",
    color: Colors.brown,
    distanceFromSun: 780,
    size: 140,
    imagePath: "assets/images/jupiter.png",
  ),
  PlanetData(
    name: "Sao Thổ",
    description:
    "Tên tiếng Anh là Saturn, là hành tinh thứ sáu tính từ Mặt Trời, nổi bật với hệ thống vành đai lớn và đẹp nhất.",
    color: Colors.amber,
    distanceFromSun: 1050,
    size: 180,
    imagePath: "assets/images/saturn.png",
  ),
  PlanetData(
    name: "Thiên Vương Tinh",
    description:
    "Tên tiếng Anh là Uranus, là hành tinh thứ bảy tính từ Mặt Trời, có trục quay nghiêng gần 98° và quay gần như nằm ngang.",
    color: Colors.cyan,
    distanceFromSun: 1300,
    size: 80,
    imagePath: "assets/images/uranus.png",
  ),
  PlanetData(
    name: "Hải Vương Tinh",
    description:
    "Tên tiếng Anh là Neptune, là hành tinh thứ tám tính từ Mặt Trời, nổi bật với màu xanh đậm và gió mạnh nhất Hệ Mặt Trời.",
    color: Colors.indigoAccent,
    distanceFromSun: 1500,
    size: 78,
    imagePath: "assets/images/neptune.png",
  ),
];


//
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<HomeScreen> {
  late PageController _pageController;
  double _currentScrollValue = 2.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 2, viewportFraction: 1.0);
    _pageController.addListener(() {
      setState(() {
        _currentScrollValue = _pageController.page ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenCenterY = size.height / 2;
    final screenCenterX = size.width / 2;

    // Logic tính toán vị trí trượt
    int activeIndex = _currentScrollValue.round();

    double currentFocusDistance = 0;
    int floorIndex = _currentScrollValue.floor();
    int ceilIndex = _currentScrollValue.ceil();

    if (floorIndex == ceilIndex) {
      currentFocusDistance = planets[floorIndex].distanceFromSun;
    } else {
      double t = _currentScrollValue - floorIndex;
      double dist1 = planets[floorIndex].distanceFromSun;
      double dist2 = (ceilIndex < planets.length) ? planets[ceilIndex].distanceFromSun : dist1;
      currentFocusDistance = dist1 + (dist2 - dist1) * t;
    }

    // Đặt Mặt Trời lệch về bên trái màn hình một chút để tạo độ cong cho quỹ đạo
    double sunPositionX = -size.width * 0.5;

    // Offset tổng để dịch chuyển cả hệ thống
    double globalOffsetX = screenCenterX - (sunPositionX + currentFocusDistance);

    return Scaffold(
      // backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/space1.png",
              fit: BoxFit.cover,
              // Thêm một lớp phủ màu tối nhẹ nếu ảnh nền quá sáng, làm chìm hành tinh
              color: Colors.black.withOpacity(0.5),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          // LỚP 1: VŨ TRỤ
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(globalOffsetX, 0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // A. MẶT TRỜI
                  Positioned(
                    left: sunPositionX - 150, // Căn tâm (size 300 / 2 = 150)
                    top: screenCenterY - 150,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [Colors.yellow, Colors.orange, Colors.red.withOpacity(0.0)],
                            stops: const [0.4, 0.7, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.orange.withOpacity(0.4),
                                blurRadius: 80,
                                spreadRadius: 20
                            )
                          ]
                      ),
                    ),
                  ),

                  // B. VẼ QUỸ ĐẠO TRÒN
                  CustomPaint(
                    size: Size.infinite,
                    painter: OrbitsPainter(
                      sunPosition: Offset(sunPositionX, screenCenterY),
                      planetDistances: planets.map((e) => e.distanceFromSun).toList(),
                    ),
                  ),

                  // C. CÁC HÀNH TINH
                  ...List.generate(planets.length, (index) {
                    final p = planets[index];

                    // Logic Scale: To lên khi ở giữa
                    double scale = (2.0 - (_currentScrollValue - index).abs()).clamp(0.9, 1.6);

                    return Positioned(
                      left: sunPositionX + p.distanceFromSun - (p.size / 2),
                      top: screenCenterY - (p.size / 2),
                      child: Transform.scale(
                        scale: scale,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // ẢNH HÀNH TINH
                            Image.asset(
                              p.imagePath,
                              width: p.size,
                              height: p.size,
                              fit: BoxFit.contain,
                              errorBuilder: (ctx, err, stack) {
                                return Container(
                                  width: p.size,
                                  height: p.size,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: p.color,
                                      boxShadow: [BoxShadow(color: p.color.withOpacity(0.6), blurRadius: 20)]
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 15),

                            // TÊN HÀNH TINH
                            Opacity(
                              opacity: (scale > 1.0) ? 1.0 : 0.5,
                              child: Text(
                                p.name.toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    letterSpacing: 1.5,
                                    shadows: [BoxShadow(color: Colors.black, blurRadius: 5)]
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // LỚP 2: THÔNG TIN
          Positioned(
            top: 60, // Có thể chỉnh số này nếu muốn text cao hơn/thấp hơn
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Tiêu đề nhỏ phía trên
                const Text(
                  "HỆ MẶT TRỜI",
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4, // Tăng khoảng cách chữ tạo cảm giác rộng lớn
                  ),
                ),

                const SizedBox(height: 10),

                // Phần tên và mô tả có hiệu ứng chuyển đổi
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  // Hiệu ứng mờ dần + trượt nhẹ từ dưới lên
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.2), // Trượt từ dưới lên 1 chút
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    key: ValueKey<int>(activeIndex), // Key quan trọng để kích hoạt animation
                    children: [
                      // Tên Hành Tinh
                      Text(
                        planets[activeIndex].name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            // Bóng đổ
                            BoxShadow(color: Colors.blueAccent, blurRadius: 20, spreadRadius: -10),
                            BoxShadow(color: Colors.black, blurRadius: 10, offset: Offset(0, 4))
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Mô tả
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40), // Cách lề 2 bên 40px
                        child: Text(
                          planets[activeIndex].description,
                          textAlign: TextAlign.center, // Căn giữa
                          maxLines: 3, // Chỉ hiện tối đa 3 dòng
                          overflow: TextOverflow.ellipsis, // Dài quá thì hiện dấu "..."
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            height: 1.6,
                            shadows: [
                              BoxShadow(color: Colors.black, blurRadius: 4, offset: Offset(0, 1))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // LỚP 3: CẢM ỨNG (PageView Tàng Hình)
          PageView.builder(
            controller: _pageController,
            itemCount: planets.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(color: Colors.transparent);
            },
          ),

          // LỚP 4: THANH CHỌN DƯỚI
          Positioned(
            bottom: 120,
            left: 20,
            right: 20,
            child: Center(
              child: Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: planets.length,
                  itemBuilder: (context, index) {
                    bool isSelected = index == activeIndex;
                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(index, duration: const Duration(milliseconds: 600), curve: Curves.easeOutCubic);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: isSelected ? 55 : 35,
                          height: isSelected ? 55 : 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: isSelected ? Border.all(color: Colors.cyanAccent, width: 2) : null,
                            boxShadow: isSelected ? [BoxShadow(color: Colors.cyanAccent.withOpacity(0.3), blurRadius: 10)] : null,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              planets[index].imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(color: planets[index].color);
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// --- 4. ORBIT PAINTER (VẼ QUỸ ĐẠO TRÒN) ---
class OrbitsPainter extends CustomPainter {
  final Offset sunPosition;
  final List<double> planetDistances;

  OrbitsPainter({required this.sunPosition, required this.planetDistances});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15) // Màu đường trắng mờ
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Vẽ các vòng tròn đồng tâm lấy Mặt Trời làm gốc
    for (double radius in planetDistances) {
      canvas.drawCircle(sunPosition, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}