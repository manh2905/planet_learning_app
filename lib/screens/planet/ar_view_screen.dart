import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class PlanetARScreen extends StatefulWidget {
  final String modelPath;
  final String planetName;

  const PlanetARScreen({
    super.key,
    required this.modelPath,
    required this.planetName,
  });

  @override
  State<PlanetARScreen> createState() => _PlanetARScreenState();
}

class _PlanetARScreenState extends State<PlanetARScreen> {
  CameraController? _cameraController;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    // 1. Lấy danh sách camera
    final cameras = await availableCameras();

    // 2. Lọc lấy Camera Sau (Back)
    // CameraLensDirection.back là từ khóa quan trọng
    final backCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      backCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() => _ready = true);
    } catch (e) {
      debugPrint("Lỗi khởi tạo camera: $e");
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: !_ready
          ? const Center(child: CircularProgressIndicator(color: Colors.cyanAccent))
          : Stack(
        children: [
          // CAMERA PREVIEW
          Positioned.fill(
            child: CameraPreview(_cameraController!),
          ),

          // LỚP PHỦ TỐI NHẸ (Để mô hình 3D nổi bật hơn trên nền camera thực tế)
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),

          // PLANET 3D MODEL
          Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: ModelViewer(
                src: widget.modelPath,
                autoRotate: true,
                cameraControls: true,
                backgroundColor: Colors.transparent,
                ar: false,
              ),
            ),
          ),

          // TOP BAR (Nút Back & Tên)
          Positioned(
            top: 50, // Tăng lên chút để tránh tai thỏ
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nút Back tròn
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24)
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Tên Hành Tinh
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24)
                  ),
                  child: Text(
                    widget.planetName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Hướng dẫn người dùng
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Xoay & Phóng to hành tinh 3D",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}