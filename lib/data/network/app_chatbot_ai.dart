import 'package:chatbot/util/constants.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AppChatBotAI {
  late GenerativeModel model;

  AppChatBotAI() {

    model = GenerativeModel(model: 'gemini-pro', apiKey: 'AIzaSyBt688Du4Avht7O2EsUwVtTigiqKHO6hxI');
  }

  Future<GenerateContentResponse?> sendQuery(String query) async {
    if (query.isEmpty) {
      return null;
    }

    return await model.generateContent([
      Content.text(query),
    ]);
  }
}
