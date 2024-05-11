import 'package:chatbot/data/bloc/loader_bloc.dart';
import 'package:chatbot/data/model/chat_meta_data.dart';
import 'package:chatbot/data/network/app_chatbot_ai.dart';
import 'package:chatbot/data/sqlstorage/app_database_impl.dart';

class ChatMetaDataController {
  LoaderBloc loaderBloc = LoaderBloc();
  AppDataBaseImpl appDataBaseImpl = AppDataBaseImpl();

  ChatMetaDataController() {
    loaderBloc.add(LoaderLoading());
  }

  Future<List<ChatMetaData>> getAllMetadata() async {
    loaderBloc.add(LoaderLoading());

    List<ChatMetaData> list =
        await appDataBaseImpl.database.chatMetaDataDao.getAllChatMetaData();

    loaderBloc.add(LoaderStopped());

    return list;
  }

  Future<void> deleteChatMetaData(ChatMetaData chatMetaData) async {
    loaderBloc.add(LoaderLoading());

    await appDataBaseImpl.database.chatMetaDataDao.deleteChatMetaData(chatMetaData);
    await appDataBaseImpl.database.chatDataDao.deleteChatData(chatMetaData.id!);

    loaderBloc.add(LoaderStopped());
  }
}
