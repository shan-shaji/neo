import 'package:args/command_runner.dart';
import 'package:dart_console/dart_console.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neo/src/app/locator.dart';
import 'package:neo/src/helpers/app_console_helper.dart';
import 'package:neo/src/services/hive_db/app_hive_db_service.dart';

class DeleteCommand extends Command<int> {
  DeleteCommand() {
    argParser.addOption('key', abbr: 'k');
  }

  final _hiveDbCommandService = locator<AppHiveDBCommandsService>();
  final Logger _logger = locator<Logger>();

  @override
  String get description => 'Delete the command by key';

  @override
  String get name => 'delete';

  @override
  Future<int> run() async {
    final console = Console();
    final key = argResults?['key'];
    if (key is! String) {
      _logger.warn('Please provide a valid key to delete your commands!');
      return ExitCode.data.code;
    }
    final index = int.tryParse(key) ?? 0;
    await _hiveDbCommandService.deleteCommand(index);
    final savedCommands = _hiveDbCommandService.getCommands();
    final rows =
        savedCommands.map((value) => [value.key, value.command]).toList();
    final table = AppConsoleHelper.renderTable(rows, ['Keys', 'Command']);
    console.writeLine(table);
    return ExitCode.success.code;
  }
}
