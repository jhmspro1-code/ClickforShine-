import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Datasource responsável pela comunicação com a API da OpenAI
class OpenAIDatasource {
  final Dio _dio;

  OpenAIDatasource(this._dio);

  /// Envia imagem para análise da IA
  Future<String> analyzeSurface(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path),
        'model': 'gpt-4-vision-preview',
      });

      // Aqui o 'Options' e 'Dio' são reconhecidos pelo import
      final response = await _dio.post(
        'https://api.openai.com/v1/chat/completions',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer SEU_TOKEN_AQUI',
          },
        ),
      );

      return response.data['choices'][0]['message']['content'];
    } on DioException catch (e) {
      // Alterado de DioError para DioException para a versão ^5.4.0
      debugPrint('Erro na API OpenAI: ${e.message}');
      throw Exception('Falha na análise da imagem: ${e.response?.data}');
    } catch (e) {
      debugPrint('Erro inesperado: $e');
      throw Exception('Erro ao processar análise');
    }
  }
}
