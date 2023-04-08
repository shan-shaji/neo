import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neo/src/app/locator.dart';
import 'package:neo/src/helpers/extensions/app_string_extension_helper.dart';
import 'package:neo/src/services/app_services.dart';

class Save extends Command<int> {
  final _hiveDbCommandService = locator<AppHiveDBCommandsService>();
  final _logger = locator<Logger>();

  @override
  String get description => 'neo_save_command_description'.tr;

  @override
  String get name => 'save';

  @override
  Future<int> run() async {
    try {
      final response = _logger.prompt('Enter or paste your command to save: ');
      if (response.isEmpty) return ExitCode.noInput.code;

      final commandAlias = _logger.prompt(
        'Enter alias for the command (optional): ',
      );

      await _hiveDbCommandService.storeCommands(
        response,
        commandAlias,
      );
      return ExitCode.success.code;
    } catch (e) {
      return ExitCode.software.code;
    }
  }
}
