part of 'app_hive_db_service.dart';

class AppHiveDBCommandsService {
  FutureOr<bool> storeCommands(String command, String alias) async {
    try {
      final box = Hive.box<CliCommand>(_cliCommandsBox);

      // Ensure alias is unique
      if (box.values.any((cliCommand) => cliCommand.alias == alias)) {
        return false;
      }

      final newCommand = CliCommand()
        ..command = command
        ..alias = alias
        ..id = DateTime.now().millisecondsSinceEpoch;

      await box.add(newCommand);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteCommand(int id) async {
    try {
      final box = Hive.box<CliCommand>(_cliCommandsBox);
      final key = box.keys
          .firstWhere((key) => box.get(key)!.id == id, orElse: () => -1);
      if (key == -1) {
        return false;
      }
      await box.delete(key);
      return true;
    } catch (_) {
      return false;
    }
  }

  List<CliCommand> getCommands() {
    final box = Hive.box<CliCommand>(_cliCommandsBox);
    return box.values.toList();
  }
}
