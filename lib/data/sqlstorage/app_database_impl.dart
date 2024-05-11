import 'package:chatbot/data/sqlstorage/app_database.dart';
import 'package:chatbot/util/constants.dart';

class AppDataBaseImpl{

  late AppDatabase database;

  init() async {
    database = await $FloorAppDatabase.databaseBuilder(databaseName).build();
  }
}