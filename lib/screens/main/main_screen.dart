import 'package:flutter/material.dart';
import 'dart:ui'; // Cần import để dùng ImageFilter (Hiệu ứng mờ)

// Import các màn hình con của bạn
import '../home/home_screen.dart';
import '../explore/explore_screen.dart'; // Giả sử bạn có file này
import '../quizz/quiz_screen.dart';       // Giả sử bạn có file này
import '../account/account_screen.dart';   // Giả sử bạn có file này
import '../../db.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // final DBService _dbService = DBService();
  //
  // @override
  // void initState() {
  //   super.initState();
  //
  //
  //   // _dbService.insertAllPlanets();
  // }

  final List<Widget> _screens = const [
    HomeScreen(),
    ExploreScreen(),
    QuizScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Màu nền đen thẳm để khớp với vũ trụ
      backgroundColor: Colors.black,

      // Quan trọng: Cho phép nội dung tràn xuống dưới thanh điều hướng
      extendBody: true,

      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // Tùy chỉnh thanh điều hướng
      bottomNavigationBar: Container(
        // Tạo khoảng cách 2 bên và phía dưới để tạo hiệu ứng "nổi" (Floating)
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: ClipRRect(
          // Bo tròn thanh điều hướng
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            // Hiệu ứng làm mờ nền phía sau (Glassmorphism)
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                // Màu nền bán trong suốt
                color: const Color(0xFF1A1A2E).withOpacity(0.8),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1), // Viền mỏng tinh tế
                  width: 1,
                ),
                boxShadow: [
                  // Đổ bóng nhẹ màu xanh neon
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 0,
                  )
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() => _currentIndex = index);
                },
                // Các thuộc tính để làm trong suốt BottomNavigationBar mặc định
                backgroundColor: Colors.transparent,
                elevation: 0,
                type: BottomNavigationBarType.fixed,

                // Màu sắc chủ đề
                selectedItemColor: Colors.cyanAccent, // Màu neon khi chọn
                unselectedItemColor: Colors.grey.shade500, // Màu xám khi không chọn
                showUnselectedLabels: true, // Ẩn chữ khi không chọn cho gọn
                selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),

                items: const [
                  BottomNavigationBarItem(
                    // Icon tên lửa hợp với chủ đề vũ trụ hơn
                    icon: Icon(Icons.rocket_launch_outlined),
                    activeIcon: Icon(Icons.rocket_launch),
                    label: 'Vũ trụ',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.travel_explore_outlined),
                    activeIcon: Icon(Icons.travel_explore),
                    label: 'Khám phá',
                  ),
                  BottomNavigationBarItem(
                    // Icon ngôi sao hoặc não bộ cho Quiz
                    icon: Icon(Icons.stars_outlined),
                    activeIcon: Icon(Icons.stars),
                    label: 'Quiz',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.perm_identity),
                    activeIcon: Icon(Icons.person),
                    label: 'Tài khoản',
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