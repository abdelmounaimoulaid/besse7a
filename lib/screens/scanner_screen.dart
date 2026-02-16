
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mobile_app/services/api_service.dart';
import 'package:mobile_app/screens/product_result_screen.dart';
import 'package:mobile_app/utils/arabic_strings.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool _isProcessing = false;
  final TextEditingController _barcodeController = TextEditingController();
  MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  @override
  void dispose() {
    _barcodeController.dispose();
    controller.dispose();
    super.dispose();
  }

  void _processBarcode(String? barcode) async {
    if (_isProcessing || barcode == null) return;
    if (barcode.length < 8) return; 

    setState(() {
      _isProcessing = true;
    });

    try {
      // Pause camera while we fetch (only on mobile)
      if (!kIsWeb) {
        controller.stop();
      }
      
      final product = await ApiService.fetchProduct(barcode);
      
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductResultScreen(product: product),
        ),
      ).then((_) {
        // Resume scanning when coming back (only on mobile)
        setState(() {
          _isProcessing = false;
        });
        if (!kIsWeb) {
          controller.start();
        }
      });
      
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${ArabicStrings.productNotFound} ($barcode)'),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 3),
        ),
      );
      
      // Resume to allow re-scan (only on mobile)
      setState(() {
        _isProcessing = false;
      });
      if (!kIsWeb) {
        controller.start();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // For web, show manual input instead of camera
    if (kIsWeb) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFF0F172A),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              ArabicStrings.enterBarcode,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          body: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.all(24),
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.qr_code_scanner,
                    size: 64,
                    color: Color(0xFF059669),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    ArabicStrings.cameraNotAvailable,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    ArabicStrings.enterManually,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _barcodeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: ArabicStrings.barcodeLabel,
                      hintText: ArabicStrings.barcodeHint,
                      prefixIcon: const Icon(Icons.barcode_reader),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF059669), width: 2),
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _processBarcode(value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isProcessing
                        ? null
                        : () {
                            if (_barcodeController.text.isNotEmpty) {
                              _processBarcode(_barcodeController.text);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            ArabicStrings.searchProduct,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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
    
    // For mobile, show camera scanner
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            MobileScanner(
              controller: controller,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  _processBarcode(barcode.rawValue);
                }
              },
            ),
            
            // Overlay Guide
            Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    // Corner markers
                    const Positioned(top: 0, left: 0, child: _Corner(isTop: true, isLeft: true)),
                    const Positioned(top: 0, right: 0, child: _Corner(isTop: true, isLeft: false)),
                    const Positioned(bottom: 0, left: 0, child: _Corner(isTop: false, isLeft: true)),
                    const Positioned(bottom: 0, right: 0, child: _Corner(isTop: false, isLeft: false)),
                    
                    // Scanning Line Animation (simplified for now as just a centered line)
                    Center(
                      child: Container(
                        height: 1,
                        width: 260,
                        color: Colors.redAccent.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Header / Back Button
            Positioned(
              top: 50,
              right: 20, // Changed to right for RTL
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            
            if (_isProcessing)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),

              // Manual Entry Button
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: TextButton.icon(
                  onPressed: () {
                    // Show manual input dialog
                    showDialog(
                      context: context,
                      builder: (context) => _ManualInputPopup(
                        onSubmitted: (code) {
                          Navigator.pop(context);
                          _processBarcode(code);
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.keyboard, color: Colors.white),
                  label: const Text(
                    ArabicStrings.enterManually,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black54,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Colors.white54),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple popup for manual input
class _ManualInputPopup extends StatefulWidget {
  final Function(String) onSubmitted;
  const _ManualInputPopup({required this.onSubmitted});

  @override
  State<_ManualInputPopup> createState() => _ManualInputPopupState();
}

class _ManualInputPopupState extends State<_ManualInputPopup> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        ArabicStrings.enterBarcode, 
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          hintText: '3017620422003',
          border: OutlineInputBorder(),
        ),
        autofocus: true,
        onSubmitted: (val) {
          if (val.isNotEmpty) widget.onSubmitted(val);
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'), // Cancel
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onSubmitted(_controller.text);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669)),
          child: const Text('بحث', style: TextStyle(color: Colors.white)), // Search
        ),
      ],
    );
  }
}

class _Corner extends StatelessWidget {
  final bool isTop;
  final bool isLeft;

  const _Corner({required this.isTop, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          top: isTop ? const BorderSide(color: Color(0xFF059669), width: 4) : BorderSide.none,
          bottom: !isTop ? const BorderSide(color: Color(0xFF059669), width: 4) : BorderSide.none,
          left: isLeft ? const BorderSide(color: Color(0xFF059669), width: 4) : BorderSide.none,
          right: !isLeft ? const BorderSide(color: Color(0xFF059669), width: 4) : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: isTop && isLeft ? const Radius.circular(16) : Radius.zero,
          topRight: isTop && !isLeft ? const Radius.circular(16) : Radius.zero,
          bottomLeft: !isTop && isLeft ? const Radius.circular(16) : Radius.zero,
          bottomRight: !isTop && !isLeft ? const Radius.circular(16) : Radius.zero,
        ),
      ),
    );
  }
}
