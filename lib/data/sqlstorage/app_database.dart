import 'package:chatbot/data/dao/chat_data_dao.dart';
import 'package:chatbot/data/dao/chat_metadata_dao.dart';
import 'package:chatbot/data/model/chat_data.dart';
import 'package:chatbot/data/model/chat_meta_data.dart';
import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(version: 1, entities: [ChatData, ChatMetaData])
abstract class AppDatabase extends FloorDatabase{
  ChatDataDao get chatDataDao;
  ChatMetaDataDao get chatMetaDataDao;
}