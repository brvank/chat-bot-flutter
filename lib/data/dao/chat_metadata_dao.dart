import 'package:chatbot/data/model/chat_meta_data.dart';
import 'package:floor/floor.dart';

@dao
abstract class ChatMetaDataDao{

  @Query('SELECT * FROM ChatMetaData')
  Future<List<ChatMetaData>> getAllChatMetaData();

  @insert
  Future<int> insertChatMetaData(ChatMetaData chatMetaData);

  @update
  Future<int> updateChatMetaData(ChatMetaData chatMetaData);

  @delete
  Future<void> deleteChatMetaData(ChatMetaData chatMetaData);
}