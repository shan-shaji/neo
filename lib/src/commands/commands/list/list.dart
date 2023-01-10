import 'package:args/command_runner.dart';
import 'package:dart_console/dart_console.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neo/src/helpers/hive_db.dart';

class ListCommand extends Command<int> {
  @override
  String get description => 'list all your saved commands';

  @override
  String get name => 'list';

  @override
  Future<int> run() async {
    final console = Console();
    final savedCommands = HiveDB.i.getCommands();
    final rows = savedCommands.map((e) => [e.key, e.command]).toList();
    final table = Table()
      ..insertColumn(header: 'Key', alignment: TextAlignment.center)
      ..insertColumn(header: 'Command', alignment: TextAlignment.center)
      ..insertRows(rows)
      ..borderStyle = BorderStyle.square
      ..borderColor = ConsoleColor.brightCyan
      ..borderType = BorderType.vertical;
    console.writeLine(table);
    return ExitCode.success.code;
  }
}
