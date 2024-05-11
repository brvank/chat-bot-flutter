import 'package:floor/floor.dart';

@entity
class ChatMetaData{

  @PrimaryKey(autoGenerate: true)
  int? id;
  String title;

  ChatMetaData(this.id, this.title);

}