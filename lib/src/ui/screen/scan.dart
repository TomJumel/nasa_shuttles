import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shuttles_scanner/src/ui/component/shuttle_dialogs.dart';
import 'package:shuttles_scanner/src/ui/style/colors.dart';

class ScanPage extends StatefulWidget {
  final bool canScan;
  const ScanPage({super.key, this.canScan=true });

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Composteur Nasa',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<PermissionStatus>(
        future: _checkPerm(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Une erreur est survenue"),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data == PermissionStatus.granted) {
              return _mobileScannerContent();
            }
            return const Center(
              child: Text(
                "Vous devez autoriser l'accès à la caméra dans les paramètres",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      //torch toggle button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedBuilder(
        animation: _scannerController.torchState,
        builder: (context, snapshot) {
          return FloatingActionButton(
            onPressed: _toggleTorch,
            child: _scannerController.torchState.value == TorchState.on
                ? const Icon(Icons.flash_off)
                : const Icon(Icons.flash_on),
          );
        },
      ),
    );
  }

  Future<PermissionStatus> _checkPerm() {
    return Permission.camera.request();
  }

  final MobileScannerController _scannerController = MobileScannerController(
    formats: [
      BarcodeFormat.qrCode,
    ],
  );

  _toggleTorch() {
    _scannerController.toggleTorch();
  }

  bool isScanning = false;

  Widget _mobileScannerContent() => Stack(
        children: [
          MobileScanner(
            allowDuplicates: true,
            controller: _scannerController,
            onDetect: (barcode, args) async {
              //add flag to avoid duplicate detection
              if (isScanning || !widget.canScan) return;
              isScanning = true;
              if (barcode.rawValue == null) {
              } else {
                final String code = barcode.rawValue!;
                //decode and popup
                try {
                  await showDialog(
                    context: context,
                    builder: (context) => TicketDialog(ticket: code),
                    barrierDismissible: false,
                  );
                } catch (e) {
                  if (kDebugMode) {
                    print(e);
                  }
                } finally {
                  await Future.delayed(const Duration(milliseconds: 100));
                  isScanning = false;
                }
              }
            },
          ),
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              AppColors.primary.shade50.withOpacity(0.2),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter.add(const Alignment(0, 0.3)),
            child: const Text(
              "Scannez le QR code",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      );
}
