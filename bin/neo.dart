import 'dart:io';

import 'package:hive/hive.dart';
import 'package:neo/src/app/locator.dart';
import 'package:neo/src/command_runner.dart';
import 'package:neo/src/helpers/app_platform_helper.dart';
import 'package:neo/src/services/app_services.dart';

Future<void> main(List<String> args) async {
  // Initialize hive every time when the script runs
  setupLocator();
  final neoDir = AppPlatformhelper.findOrCreate('.neo');
  Hive.init(neoDir.path);
  await locator<AppHiveDbService>().openBox();
  locator<AppLocalizationService>().setLanguage('en');
  await _flushThenExit(await NeoCommandRunner().run(args));
}

/// Flushes the stdout and stderr streams, then exits the program with the given
/// status code.
///
/// This returns a Future that will never complete, since the program will have
/// exited already. This is useful to prevent Future chains from proceeding
/// after you've decided to exit.
Future<void> _flushThenExit(int status) {
  return Future.wait<void>([stdout.close(), stderr.close()])
      .then<void>((_) => exit(status));
}
