import 'dart:async';
import 'package:hive/hive.dart';

class SavedCommands {
  SavedCommands({
    this.key = 0,
    this.command = '',
  });
  int key;
  String command;
}

class HiveDB {
  static HiveDB i = HiveDB();

  FutureOr<void> openBox() async {
    await Hive.openBox<String>('neo');
  }

  FutureOr<bool> storeCommands(String command) async {
    try {
      final box = Hive.box<String>('neo');
      await box.add(command);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteCommand(int index) async {
    try {
      final box = Hive.box<String>('neo');
      await box.delete(index - 1);
      return true;
    } catch (_) {
      return false;
    }
  }

  List<SavedCommands> getCommands() {
    final box = Hive.box<String>('neo');
    final commands = <SavedCommands>[];
    var key = 1;
    for (final command in box.values) {
      final cmd = SavedCommands()
        ..command = command
        ..key = key;
      commands.add(cmd);
      key += 1;
    }
    return commands;
  }
}
