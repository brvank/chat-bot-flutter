import 'package:floor/floor.dart';

@entity
class ChatData{

  @PrimaryKey(autoGenerate: true)
  int? id;
  final String data;
  final int metaDataId;
  final int owner;

  //using two integer constants for setting the chat data owner
  @ignore
  static int user = 1;
  @ignore
  static int bot = 2;

  ChatData(this.id, this.data, this.metaDataId, this.owner);
}