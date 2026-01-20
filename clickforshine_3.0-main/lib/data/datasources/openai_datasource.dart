import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class OpenAIDatasource {
  final Dio _dio;
  OpenAIDatasource(this._dio);

  Future<String> analyzeSurface(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path),
        'model': 'gpt-4-vision-preview',
      });

      final response = await _dio.post(
        'https://api.openai.com/v1/chat/completions',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer SEU_TOKEN'}),
      );

      return response.data['choices'][0]['message']['content'];
    } on DioException catch (e) {
      debugPrint('Erro Dio: ${e.message}');
      throw Exception('Falha na análise');
    }
  }
}
