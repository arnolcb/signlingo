import 'package:flutter/material.dart';
import 'package:signlingo_1/utils/app_themes.dart';
import 'package:signlingo_1/widgets/translation_history_item.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({Key? key}) : super(key: key);

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _textController = TextEditingController();
  bool _isRecording = false;
  bool _isTranslating = false;
  bool _isCameraMode = false;
  CameraController? _cameraController;
  List<CameraDescription> cameras = [];

  // Lista de historiales de traducción (simulados)
  final List<TranslationHistoryItem> _historyItems = [
    TranslationHistoryItem(
      originalText: 'Hola, ¿cómo estás?',
      translationType: TranslationType.textToSign,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    TranslationHistoryItem(
      originalText: 'Buenos días',
      translationType: TranslationType.textToSign,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    TranslationHistoryItem(
      originalText: 'Gracias',
      translationType: TranslationType.signToText,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras[0],
          ResolutionPreset.high,
          enableAudio: false,
        );
      }
    } catch (e) {
      debugPrint('Error al inicializar la cámara: $e');
    }
  }

  Future<void> _toggleCameraMode() async {
    if (_isCameraMode) {
      setState(() {
        _isCameraMode = false;
        _cameraController?.dispose();
      });
    } else {
      final status = await Permission.camera.request();
      if (status.isGranted) {
        if (_cameraController == null) {
          await _initializeCamera();
        }

        try {
          await _cameraController?.initialize();
          setState(() {
            _isCameraMode = true;
          });
        } catch (e) {
          debugPrint('Error al inicializar la cámara: $e');
        }
      }
    }
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });

    if (_isRecording) {
      // Simular reconocimiento después de 3 segundos
      Timer(const Duration(seconds: 3), () {
        if (mounted && _isRecording) {
          setState(() {
            _isRecording = false;
            _isTranslating = true;
          });

          // Simular proceso de traducción
          Timer(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _isTranslating = false;
                // Aquí se añadiría el resultado al historial
                _historyItems.insert(
                  0,
                  TranslationHistoryItem(
                    originalText: "Gracias por usar SignLingo",
                    translationType: TranslationType.signToText,
                    timestamp: DateTime.now(),
                  ),
                );
              });
            }
          });
        }
      });
    }
  }

  void _translateText() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _isTranslating = true;
      });

      // Simular proceso de traducción
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isTranslating = false;
            // Aquí se añadiría el resultado al historial
            _historyItems.insert(
              0,
              TranslationHistoryItem(
                originalText: _textController.text,
                translationType: TranslationType.textToSign,
                timestamp: DateTime.now(),
              ),
            );
            _textController.clear();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SignLingo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Texto a Señas'),
            Tab(text: 'Señas a Texto'),
          ],
          labelColor: AppColors.whiteColor,
          unselectedLabelColor: AppColors.whiteColor.withOpacity(0.7),
          indicatorColor: AppColors.accentColor,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTextToSignTab(),
          _buildSignToTextTab(),
        ],
      ),
    );
  }

  Widget _buildTextToSignTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _textController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText:
                          'Escribe aquí el texto que deseas traducir a señas...',
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Implementar función de micrófono (texto por voz)
                        },
                        icon: const Icon(Icons.mic,
                            color: AppColors.primaryColor),
                      ),
                      SizedBox(
                        height: 50,
                        width: 140,
                        child: ElevatedButton(
                          onPressed: _isTranslating ? null : _translateText,
                          child: _isTranslating
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Traducir'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Historial',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _historyItems.isEmpty
                ? const Center(
                    child: Text('No hay traducciones recientes'),
                  )
                : ListView.separated(
                    itemCount: _historyItems.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return TranslationHistoryItemWidget(
                        item: _historyItems[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignToTextTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              height: 300,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: _isCameraMode &&
                      _cameraController != null &&
                      _cameraController!.value.isInitialized
                  ? CameraPreview(_cameraController!)
                  : Container(
                      color: Colors.black87,
                      child: const Center(
                        child: Text(
                          'Activa la cámara para comenzar a traducir señas',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _toggleCameraMode,
                icon:
                    Icon(_isCameraMode ? Icons.videocam_off : Icons.camera_alt),
                label: Text(_isCameraMode ? 'Desactivar' : 'Activar cámara'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isCameraMode ? Colors.red : AppColors.accentColor,
                ),
              ),
              if (_isCameraMode)
                ElevatedButton.icon(
                  onPressed: _isTranslating ? null : _toggleRecording,
                  icon:
                      Icon(_isRecording ? Icons.stop : Icons.record_voice_over),
                  label: Text(_isRecording ? 'Detener' : 'Reconocer señas'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isRecording ? Colors.red : AppColors.primaryColor,
                  ),
                ),
            ],
          ),
          if (_isTranslating)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('Traduciendo señas...'),
                ],
              ),
            ),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Historial',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _historyItems.isEmpty
                ? const Center(
                    child: Text('No hay traducciones recientes'),
                  )
                : ListView.separated(
                    itemCount: _historyItems.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return TranslationHistoryItemWidget(
                        item: _historyItems[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
