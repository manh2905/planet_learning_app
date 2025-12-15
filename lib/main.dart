// import 'package:flutter/material.dart';
// import 'screens/main/main_screen.dart';
//
// void main() {
//   runApp(const PlanetApp());
// }
//
// class PlanetApp extends StatelessWidget {
//   const PlanetApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MainScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/main/main_screen.dart';

// 1. Import file cấu hình do CLI tạo ra (Nếu báo đỏ dòng này, xem hướng dẫn bên dưới)
import 'firebase_options.dart';

void main() async {
  // 2. Đợi Flutter Engine
  WidgetsFlutterBinding.ensureInitialized();

  // 3. Khởi tạo Firebase với cấu hình từ CLI
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const PlanetApp());
}

class PlanetApp extends StatelessWidget {
  const PlanetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}