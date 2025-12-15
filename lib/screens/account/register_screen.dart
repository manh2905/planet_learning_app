import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = AuthService();
  final _userService = UserService();

  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  bool loading = false;
  String? error;

  Future<void> _register() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final user = await _auth.register(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );

      if (user == null) throw Exception('Đăng ký thất bại');

      // Tạo User trong Firestore
      final appUser = AppUser(
        uid: user.uid,
        email: user.email!,
        displayName: _nameCtrl.text.trim().isEmpty ? "Phi hành gia mới" : _nameCtrl.text.trim(),
        createdAt: DateTime.now(),
      );

      await _userService.createUser(appUser);

      if (!mounted) return;
      Navigator.pop(context); // Quay về login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tạo tài khoản thành công! Hãy đăng nhập.")),
      );
    } catch (e) {
      setState(() => error = "Lỗi đăng ký: Email có thể đã tồn tại hoặc mật khẩu quá yếu.");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("GIA NHẬP PHI ĐỘI", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // LỚP 1: HÌNH NỀN VŨ TRỤ
          Positioned.fill(
            child: Image.asset(
              "assets/images/space1.png",
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.6),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          // LỚP 2: NỘI DUNG
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Icon
                  const Icon(Icons.person_add_alt_1, size: 80, color: Colors.cyanAccent),
                  const SizedBox(height: 20),
                  const Text(
                    "TẠO HỒ SƠ MỚI",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Name Input
                  _buildGlassTextField(
                    controller: _nameCtrl,
                    hintText: "Tên phi hành gia",
                    icon: Icons.badge_outlined,
                  ),
                  const SizedBox(height: 16),

                  // Email Input
                  _buildGlassTextField(
                    controller: _emailCtrl,
                    hintText: "Email",
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),

                  // Password Input
                  _buildGlassTextField(
                    controller: _passCtrl,
                    hintText: "Mật khẩu (Trên 6 ký tự)",
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  const SizedBox(height: 20),
                  if (error != null)
                    Text(error!, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold), textAlign: TextAlign.center),

                  const SizedBox(height: 30),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: loading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.cyanAccent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(color: Colors.cyanAccent, width: 2)
                        ),
                      ),
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.cyanAccent)
                          : const Text("KHỞI TẠO TÀI KHOẢN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget con tái sử dụng
  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          prefixIcon: Icon(icon, color: Colors.cyanAccent.withOpacity(0.8)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}