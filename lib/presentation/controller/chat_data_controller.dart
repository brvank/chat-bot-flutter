import 'package:chatbot/data/bloc/loader_bloc.dart';
import 'package:chatbot/data/model/chat_data.dart';
import 'package:chatbot/data/model/chat_meta_data.dart';
import 'package:chatbot/data/network/app_chatbot_ai.dart';
import 'package:chatbot/data/sqlstorage/app_database_impl.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatDataController {
  LoaderBloc loaderBloc = LoaderBloc();
  AppDataBaseImpl appDataBaseImpl = AppDataBaseImpl();
  AppChatBotAI appChatBotAi = AppChatBotAI();

  ChatDataController() {
    loaderBloc.add(LoaderLoading());
  }

  Future<int> addChatMetaData(String title) async {
    loaderBloc.add(LoaderLoading());

    int res = await appDataBaseImpl.database.chatMetaDataDao
        .insertChatMetaData(ChatMetaData(null, title));

    loaderBloc.add(LoaderStopped());

    return res;
  }

  Future<void> updateChatMetaData(ChatMetaData chatMetaData) async {
    loaderBloc.add(LoaderLoading());

    await appDataBaseImpl.database.chatMetaDataDao
        .updateChatMetaData(chatMetaData);

    loaderBloc.add(LoaderStopped());
  }

  Future<void> addChatData(ChatData chatData) async {
    loaderBloc.add(LoaderLoading());

    await appDataBaseImpl.database.chatDataDao
        .insertChatData(chatData);

    loaderBloc.add(LoaderStopped());
  }

  Future<String?> sendQuery(String query) async {
    loaderBloc.add(LoaderLoading());

    GenerateContentResponse? res = await appChatBotAi.sendQuery(query);

    loaderBloc.add(LoaderStopped());

    if (res != null) {
      return res.text;
    } else {
      return null;
    }
  }

  Future<List<ChatData>> getAllChatData(int metaDataId) async {
    loaderBloc.add(LoaderLoading());

    List<ChatData> list = await appDataBaseImpl.database.chatDataDao.findAllChatData(metaDataId);

    loaderBloc.add(LoaderStopped());

    return list;
  }
}
