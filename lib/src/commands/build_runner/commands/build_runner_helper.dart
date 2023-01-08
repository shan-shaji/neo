import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:neo/src/cli/cli.dart';
import 'package:neo/src/cli/flutter_cli.dart';
import 'package:path/path.dart' as p;
import 'package:pubspec_parse/pubspec_parse.dart';

class BuildRunnerHelper {
  static Future<bool> _installBuildRunner({
    required String cwd,
    required Logger logger,
  }) async {
    final installProgress = logger.progress('Installing build_runner..');
    await runCommand(
      cmd: (cwd) async {
        try {
          await Cmd.run(
            'flutter',
            [
              'pub',
              'add',
              'build_runner',
              '--dev',
            ],
            logger: logger,
          );
          installProgress.complete('Successfully installed build_runner');
          return true;
        } catch (e) {
          logger.err('$e');
          installProgress.fail('Failed to install build_runner');
          return false;
        }
      },
      cwd: cwd,
      recursive: false,
    );
    return false;
  }

  /// Function that checks if the `build_runner` is installed
  /// inside the current directory `pubspec.yaml` file.
  ///
  /// If `build_runner` is not insalled the package can be installed
  /// using this function.
  static Future<bool> checkAndInstallBuildRunner({
    required String cwd,
    required Logger logger,
  }) async {
    final pubspec = File(p.join(cwd, 'pubspec.yaml'));
    final result = await pubspec.readAsString();
    final devDependencies = Pubspec.parse(result).devDependencies;
    final isBuildRunnerFound = devDependencies.containsKey('build_runner');
    if (isBuildRunnerFound) return isBuildRunnerFound;

    final promptResult = logger
        .prompt('Do you want to install build_runner (y/n) ?')
        .toLowerCase();
    if (!['n', 'y'].contains(promptResult) || promptResult == 'n') return false;
    final isInstalled = await _installBuildRunner(cwd: cwd, logger: logger);
    return isInstalled;
  }

  static String parsedError(String message) {
    final severeErrorIndex = message.indexOf('[SEVERE]');
    final buildCompleteIndex =
        message.indexOf('Try fixing the errors and re-running the build');
    return '\n${message.substring(severeErrorIndex, buildCompleteIndex)}';
  }
}
