import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neo/src/commands/commands/delete/delete.dart';
import 'package:neo/src/commands/commands/list/list.dart';
import 'package:neo/src/commands/commands/save/save.dart';
import 'package:neo/src/commands/commands/select/select.dart';
import 'package:neo/src/helpers/extensions/app_string_extension_helper.dart';

class Commands extends Command<int> {
  Commands() {
    addSubcommand(Save());
    addSubcommand(SelectCommand());
    addSubcommand(ListCommand());
    addSubcommand(DeleteCommand());
  }

  @override
  String get description => 'neo_commands_description'.tr;

  @override
  String get name => 'commands';

  @override
  String get invocation => 'neo commands <subcommand> [arguments]';
}
