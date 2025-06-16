import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

class SignRecognitionService {
  static Future<String> recognizeSign(CameraController? controller) async {
    if (controller == null || !controller.value.isInitialized) {
      return 'Cámara no disponible';
    }

    try {
      final XFile rawImage = await controller.takePicture();
      final bytes = await rawImage.readAsBytes();
      final base64Image = base64Encode(bytes);

      final uri = Uri.parse(
        'https://detect.roboflow.com/american-sign-language-v36cz/1?api_key=VBpTkFBTwED0IYlB4Jau&name=FRAME.jpg',
      );

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: base64Image,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final predictions = jsonResponse['predictions'] as List<dynamic>?;
        if (predictions != null && predictions.isNotEmpty) {
          return predictions[0]['class']?.toString() ?? 'Sin resultado';
        }
        return 'Sin resultado';
      } else {
        return 'Error API: ${response.statusCode}';
      }
    } catch (_) {
      return 'Error en la traducción';
    }
  }
}
