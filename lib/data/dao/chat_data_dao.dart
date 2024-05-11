import 'package:chatbot/data/model/chat_data.dart';
import 'package:floor/floor.dart';

@dao
abstract class ChatDataDao{

  @Query('SELECT * FROM ChatData WHERE metaDataId = :metaDataId')
  Future<List<ChatData>> findAllChatData(int metaDataId);

  @insert
  Future<int> insertChatData(ChatData chatData);

  @Query('DELETE FROM ChatData WHERE metaDataId = :metaDataId')
  Future<void> deleteChatData(int metaDataId);
}