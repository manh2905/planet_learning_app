import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  late final String _apiKey;
  final List<Map<String, dynamic>> _conversationHistory = [];

  // System prompt để AI focus vào chủ đề hành tinh
  static const String _systemPrompt = '''
Bạn là một trợ lý AI chuyên về thiên văn học và các hành tinh trong hệ mặt trời.

Nhiệm vụ của bạn:
- Trả lời các câu hỏi về hành tinh, mặt trăng, và các thiên thể trong hệ mặt trời một cách chính xác, dễ hiểu và thú vị.
- Sử dụng ngôn ngữ tiếng Việt, thân thiện và phù hợp với người học.
- Giải thích bằng các ví dụ sinh động để dễ hình dung.
- Nếu được hỏi về các chủ đề KHÔNG liên quan đến hành tinh hoặc thiên văn học, hãy lịch sự từ chối và khuyến khích người dùng hỏi về hệ mặt trời.

Hãy trả lời ngắn gọn (2–4 câu) trừ khi người dùng yêu cầu giải thích chi tiết.
''';

  GeminiService() {
    _initialize();
  }

  void _initialize() {
    // Lấy API key từ file .env
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    if (apiKey == null || apiKey.isEmpty || apiKey == 'your_api_key_here') {
      throw Exception(
        'Chưa cấu hình GEMINI_API_KEY!\n'
            'Vui lòng thêm API key vào file .env',
      );
    }

    _apiKey = apiKey;
    
    // Thêm system prompt vào lịch sử hội thoại
    _conversationHistory.add({
      'role': 'user',
      'parts': [
        {'text': _systemPrompt}
      ]
    });
    _conversationHistory.add({
      'role': 'model',
      'parts': [
        {'text': 'Tôi đã sẵn sàng trả lời các câu hỏi về hành tinh và hệ mặt trời.'}
      ]
    });
  }

  /// Gửi tin nhắn đến Gemini AI và nhận phản hồi
  Future<String> sendMessage(String userMessage) async {
    try {
      // Thêm tin nhắn user vào lịch sử
      _conversationHistory.add({
        'role': 'user',
        'parts': [
          {'text': userMessage}
        ]
      });

      // Tạo request body
      final requestBody = {
        'contents': _conversationHistory,
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 1024,
        }
      };

      // Gọi API v1beta với model gemini-2.5-flash (verified working)
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_apiKey',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['candidates'] != null && 
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null) {
          
          final content = data['candidates'][0]['content'];
          final text = content['parts'][0]['text'] as String;
          
          // Thêm phản hồi của AI vào lịch sử
          _conversationHistory.add(content);
          
          return text;
        } else {
          return 'Xin lỗi, tôi chưa thể trả lời câu hỏi này.';
        }
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error']?['message'] ?? 'Unknown error';
        
        if (errorMessage.contains('API_KEY')) {
          return '❌ Lỗi: API key không hợp lệ. Vui lòng kiểm tra lại.';
        } else {
          return '⚠️ Đã xảy ra lỗi API: $errorMessage';
        }
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('network')) {
        return '🌐 Lỗi: Không có kết nối internet. Vui lòng kiểm tra mạng.';
      } else {
        return '⚠️ Đã xảy ra lỗi: ${e.toString()}';
      }
    }
  }

  /// Reset chat session (giữ system prompt)
  void resetChat() {
    _conversationHistory.clear();
    _conversationHistory.add({
      'role': 'user',
      'parts': [
        {'text': _systemPrompt}
      ]
    });
    _conversationHistory.add({
      'role': 'model',
      'parts': [
        {'text': 'Tôi đã sẵn sàng trả lời các câu hỏi về hành tinh và hệ mặt trời.'}
      ]
    });
  }

  /// Welcome message
  String getWelcomeMessage() {
    return '''
Xin chào! Tôi là trợ lý AI chuyên về các hành tinh trong hệ mặt trời.

Bạn có thể hỏi tôi về:
- Các hành tinh
- Các mặt trăng
- Mặt Trời
- Các hiện tượng thiên văn

Hãy bắt đầu bằng một câu hỏi nhé!
''';
  }

  /// Câu hỏi gợi ý
  List<String> getSuggestedQuestions() {
    return [
      'Hành tinh nào lớn nhất trong hệ mặt trời?',
      'Sao Hỏa có màu đỏ vì sao?',
      'Sao Thổ có bao nhiêu vành đai?',
      'Trái Đất cách Mặt Trời bao xa?',
      'Mặt Trăng được hình thành như thế nào?',
    ];
  }
}
