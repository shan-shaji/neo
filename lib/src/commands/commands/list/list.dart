import 'package:args/command_runner.dart';
import 'package:dart_console/dart_console.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neo/src/helpers/app_console_helper.dart';
import 'package:neo/src/helpers/app_hive_db_helper.dart';

class ListCommand extends Command<int> {
  @override
  String get description => 'list all your saved commands';

  @override
  String get name => 'list';

  @override
  Future<int> run() async {
    final console = Console();
    final savedCommands = HiveDB.i.getCommands();
    final rows =
        savedCommands.map((value) => [value.key, value.command]).toList();
    final table = AppConsoleHelper.renderTable(rows, ['Keys', 'Command']);
    console.writeLine(table);
    return ExitCode.success.code;
  }
}
