import 'package:hive/hive.dart';
import 'package:notes_app_hive_database_flutter/models/notes_model.dart';

class Boxes{
  static Box<NotesModel> getData()=> Hive.box<NotesModel>('notes');
}