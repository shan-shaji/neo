import 'dart:async';
import 'package:hive/hive.dart';

class HiveDB {
  static HiveDB i = HiveDB();

  FutureOr<void> openBox() async {
    await Hive.openBox<List<String>>('neo');
  }

  FutureOr<bool> storeCommands(String command) async {
    try {
      final box = Hive.box<List<String>>('neo');
      final oldCommands = box.get('commands');
      await box.put('commands', [command, ...?oldCommands]);
      return true;
    } catch (e) {
      return false;
    }
  }

  FutureOr<List<String>> getCommands() async {
    try {
      final box = Hive.box<List<String>>('neo');
      final oldCommands = box.get('commands');
      return oldCommands ?? [];
    } catch (e) {
      return [];
    }
  }
}
