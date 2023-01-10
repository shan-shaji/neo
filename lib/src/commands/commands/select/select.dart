import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neo/src/cli/cli.dart';
import 'package:neo/src/helpers/hive_db.dart';

class SelectCommand extends Command<int> {
  SelectCommand({required Logger logger}) : _logger = logger;

  final Logger _logger;

  @override
  String get description => 'select your saved commands to run.';

  @override
  String get name => 'select';

  FutureOr<void> executeCommand(String command) async {
    final progress = _logger.progress('Running $command..');
    try {
      final cmds = command.split(' ');
      await Cmd.run(cmds.elementAt(0), [...cmds.sublist(1)], logger: _logger);
      progress.complete('Completed..');
    } catch (e) {
      progress
        ..cancel()
        ..fail('$e');
    }
  }

  @override
  Future<int> run() async {
    try {
      final savedCommands = HiveDB.i.getCommands();
      final commands = savedCommands.map((e) => e.command).toList();
      final command = _logger.chooseOne(
        'Select your command',
        choices: commands,
      );
      await executeCommand(command);
      return ExitCode.success.code;
    } catch (e) {
      return ExitCode.software.code;
    }
  }
}
