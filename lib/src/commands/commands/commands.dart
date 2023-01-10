import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neo/src/commands/commands/list/list.dart';
import 'package:neo/src/commands/commands/save/save.dart';
import 'package:neo/src/commands/commands/select/select.dart';

class Commands extends Command<int> {
  Commands({required Logger logger}) {
    addSubcommand(Save(logger: logger));
    addSubcommand(SelectCommand(logger: logger));
    addSubcommand(ListCommand());
  }

  @override
  String get description => 'Save your flutter commands to your system.';

  @override
  String get name => 'commands';

  @override
  String get invocation => 'neo commands <subcommand> [arguments]';
}
