import 'package:args/command_runner.dart';
import 'package:dart_console/dart_console.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neo/src/app/locator.dart';
import 'package:neo/src/helpers/app_console_helper.dart';
import 'package:neo/src/services/app_services.dart';

class ListCommand extends Command<int> {
  final _hiveDbCommandService = locator<AppHiveDBCommandsService>();

  @override
  String get description => 'list all your saved commands';

  @override
  String get name => 'list';

  @override
  Future<int> run() async {
    final console = Console();
    final savedCommands = _hiveDbCommandService.getCommands();
    final rows = savedCommands
        .map(
          (value) => [
            value.id,
            value.command,
            value.alias,
          ],
        )
        .toList();
    final table = AppConsoleHelper.renderTable(
      rows,
      ['Keys', 'Command', 'Alias'],
    );
    console.writeLine(table);
    return ExitCode.success.code;
  }
}
