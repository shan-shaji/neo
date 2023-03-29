import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neo/src/cli/cli.dart';
import 'package:neo/src/helpers/app_hive_db_helper.dart';

class SelectCommand extends Command<int> {
  SelectCommand({required Logger logger}) : _logger = logger;

  final Logger _logger;

  @override
  String get description => 'select your saved commands to run.';

  @override
  String get name => 'select';

  FutureOr<void> executeCommand(String command) async {
    final cmds = command.split(' ');
    await Cmd.runProcessAndLog(
      programName: cmds.elementAt(0),
      arguments: [...cmds.sublist(1)],
      logger: _logger,
    );
  }

  @override
  Future<int> run() async {
    try {
      final localCommands = HiveDB.i.getCommands();
      final commands = localCommands.map((value) => value.command).toList();
      final command = _logger.chooseOne(
        'Select your command?',
        choices: commands,
      );
      await executeCommand(command);
      return ExitCode.success.code;
    } catch (e) {
      return ExitCode.software.code;
    }
  }
}
