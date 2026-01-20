import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraAnalyzerView extends StatefulWidget {
  final Function(XFile) onPhotoCapture;
  final Function(FlashMode) onFlashToggle;

  const CameraAnalyzerView({
    Key? key,
    required this.onPhotoCapture,
    required this.onFlashToggle,
  }) : super(key: key);

  @override
  State<CameraAnalyzerView> createState() => _CameraAnalyzerViewState();
}

class _CameraAnalyzerViewState extends State<CameraAnalyzerView> with WidgetsBindingObserver {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  FlashMode _flashMode = FlashMode.torch;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(backCamera, ResolutionPreset.high, enableAudio: false);
      _initializeControllerFuture = _cameraController.initialize();
      await _cameraController.setFlashMode(_flashMode);
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Erro: $e');
    }
  }

  Future<void> _toggleFlash() async {
    final newMode = _flashMode == FlashMode.torch ? FlashMode.off : FlashMode.torch;
    await _cameraController.setFlashMode(newMode);
    widget.onFlashToggle(newMode);
    if (mounted) setState(() => _flashMode = newMode);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              CameraPreview(_cameraController),
              Positioned.fill(child: CustomPaint(painter: TechnicalGridPainter())),
              _buildControls(),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildControls() {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter, end: Alignment.topCenter,
            colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _flashMode == FlashMode.torch ? '📸 Posicione a 30cm' : '⚠️ Ative o flash',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: _toggleFlash,
                  child: Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _flashMode == FlashMode.torch ? const Color(0xFFD4AF37) : Colors.grey.withValues(alpha: 0.3),
                    ),
                    child: Icon(Icons.flash_on, color: _flashMode == FlashMode.torch ? Colors.black : Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TechnicalGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.2)..strokeWidth = 1;
    for (int i = 1; i < 3; i++) {
      canvas.drawLine(Offset(0, (size.height / 3) * i), Offset(size.width, (size.height / 3) * i), paint);
      canvas.drawLine(Offset((size.width / 3) * i, 0), Offset((size.width / 3) * i, size.height), paint);
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
