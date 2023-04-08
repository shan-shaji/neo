import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neo/src/app/locator.dart';
import 'package:neo/src/cli/cli.dart';
import 'package:neo/src/helpers/extensions/app_string_extension_helper.dart';
import 'package:neo/src/services/app_services.dart';

class SelectCommand extends Command<int> {
  final _hiveDbCommandService = locator<AppHiveDBCommandsService>();
  final _logger = locator<Logger>();

  @override
  String get description => 'neo_select_command_decription'.tr;

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
      final localCommands = _hiveDbCommandService.getCommands();
      final commands = localCommands.map((value) => value.command).toList();
      final command = _logger.chooseOne(
        'neo_select_command_question'.tr,
        choices: commands,
      );
      await executeCommand(command!);
      return ExitCode.success.code;
    } catch (e) {
      return ExitCode.software.code;
    }
  }
}
