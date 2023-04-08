import 'dart:async';
import 'package:hive/hive.dart';
import 'package:neo/src/models/cli_command_model.dart';

part 'app_hive_db_commands_service.dart';

part 'app_hive_db_boxes.dart';

class AppHiveDbService {
  FutureOr<void> openBox() async {
    Hive.registerAdapter(CliCommandAdapter());
    await Hive.openBox<CliCommand>(_cliCommandsBox);
  }
}
