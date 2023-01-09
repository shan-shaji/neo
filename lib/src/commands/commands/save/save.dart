import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neo/src/helpers/hive_db.dart';

class Save extends Command<int> {
  Save({required Logger logger}) : _logger = logger;

  final Logger _logger;

  @override
  String get description => 'Save your flutter commands to your system.';

  @override
  String get name => 'save';

  @override
  Future<int> run() async {
    try {
      final response = _logger.prompt('Enter or paste your command to save: ');
      if (response.isEmpty) return ExitCode.noInput.code;
      await HiveDB.i.storeCommands(response);
      return ExitCode.success.code;
    } catch (e) {
      return ExitCode.software.code;
    }
  }
}
