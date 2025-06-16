import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:signlingo_1/utils/app_themes.dart';
import 'package:signlingo_1/widgets/translation_history_item.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

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
  String _livePreviewText = '';


  // Lista de historiales de traducción
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
      // Desactivar cámara
      setState(() {
        _isCameraMode = false;
        _cameraController?.dispose();
        _cameraController = null;
      });
    } else {
      // Solicitar permiso y activar cámara
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

  /// Toma una foto con la cámara activa, la convierte a Base64
  /// y hace la petición POST a Roboflow. Devuelve la clase detectada.
  Future<String> _callSignRecognitionAPI() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return 'Cámara no disponible';
    }

    try {
      // 1. Tomar una foto
      final XFile rawImage = await _cameraController!.takePicture();
      final bytes = await rawImage.readAsBytes();
      final base64Image = base64Encode(bytes);

      // 2. Construir la URL con tu API key
      final uri = Uri.parse(
        'https://detect.roboflow.com/american-sign-language-v36cz/1?api_key=VBpTkFBTwED0IYlB4Jau&name=FRAME.jpg',
      );

      // 3. Enviar la petición POST
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: base64Image,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Asumimos que "predictions" es una lista de objetos con clave "class"
        final predictions = jsonResponse['predictions'] as List<dynamic>?;
        if (predictions != null && predictions.isNotEmpty) {
          // Solo devolvemos la clase detectada, sin prefijo
          return predictions[0]['class']?.toString() ?? 'Sin resultado';
        } else {
          return 'Sin resultado';
        }
      } else {
        return 'Error API: ${response.statusCode}';
      }
    } catch (e) {
      debugPrint('Error al llamar a la API: $e');
      return 'Error en la traducción';
    }
  }


  void _toggleRecording() async {
    if (_isRecording) {
      setState(() {
        _isRecording = false;
      });
      return;
    }

    setState(() {
      _isRecording = true;
      _isTranslating = true;
    });

    List<String> detectedSigns = [];

    while (_isRecording && mounted) {
      final detectedClass = await _callSignRecognitionAPI();

      if (!_isRecording || !mounted) break;

      // Solo añadir si no es "Sin resultado"
      if (detectedClass != 'Sin resultado') {
        detectedSigns.add(detectedClass);
        setState(() {
          _livePreviewText = detectedSigns.join(' ');
        });
      }


      await Future.delayed(const Duration(seconds: 2));
    }

    if (!mounted) return;

    setState(() {
      _isTranslating = false;
      _isRecording = false;
      _livePreviewText = '';

      if (detectedSigns.isNotEmpty) {
        final combinedResult = detectedSigns.join(' ');
        _historyItems.insert(
          0,
          TranslationHistoryItem(
            originalText: combinedResult,
            translationType: TranslationType.signToText,
            timestamp: DateTime.now(),
          ),
        );
      }
    });
  }




  void _translateText() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _isTranslating = true;
      });

      // Simular proceso de traducción de texto a señas
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          _isTranslating = false;
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
            clipBehavior: Clip.antiAlias,
            child: _isCameraMode &&
                _cameraController != null &&
                _cameraController!.value.isInitialized
                ? AspectRatio(
              aspectRatio: _cameraController!.value.aspectRatio,
              child: Stack(
                children: [
                  CameraPreview(_cameraController!),
                  if (_livePreviewText.isNotEmpty)
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _livePreviewText,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            )
                : Container(
              height: 300,
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _toggleCameraMode,
                icon: Icon(
                    _isCameraMode ? Icons.videocam_off : Icons.camera_alt),
                label: Text(_isCameraMode ? 'Desactivar' : 'Activar cámara'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  _isCameraMode ? Colors.red : AppColors.accentColor,
                ),
              ),
              if (_isCameraMode)
                ElevatedButton.icon(
                  onPressed: _toggleRecording,
                  icon: Icon(
                      _isRecording ? Icons.stop : Icons.record_voice_over),
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
              child: Text('No hay Traducciones Recientes'),
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
