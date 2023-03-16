import 'package:args/command_runner.dart';
import 'package:dart_console/dart_console.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neo/src/helpers/hive_db.dart';

class DeleteCommand extends Command<int> {
  DeleteCommand({Logger? logger}) : _logger = logger ?? Logger() {
    argParser.addOption(
      'key',
      abbr: 'k',
    );
  }

  final Logger _logger;

  @override
  String get description => 'Delete the command by key';

  @override
  String get name => 'delete';

  @override
  Future<int> run() async {
    final console = Console();
    final key = argResults?['key'];
    if (key is! String) {
      _logger.info('Please provide a valid key to delete your commands');
      return ExitCode.data.code;
    }
    final index = int.tryParse(key) ?? 0;
    if (index == 0) return ExitCode.ioError.code;
    await HiveDB.i.deleteCommand(index);
    final savedCommands = HiveDB.i.getCommands();
    final rows = savedCommands.map((e) => [e.key, e.command]).toList();
    final table = Table()
      ..insertColumn(header: 'Key', alignment: TextAlignment.center)
      ..insertColumn(header: 'Command', alignment: TextAlignment.center)
      ..insertRows(rows)
      ..borderStyle = BorderStyle.square
      ..borderColor = ConsoleColor.brightCyan
      ..borderType = BorderType.grid;
    console.writeLine(table);
    return ExitCode.success.code;
  }
}
