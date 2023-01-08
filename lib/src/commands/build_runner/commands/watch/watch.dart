import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neo/src/cli/cli.dart';
import 'package:neo/src/cli/flutter_cli.dart';
import 'package:neo/src/commands/build_runner/commands/build_runner_helper.dart';

class WatchCommand extends Command<int> {
  WatchCommand({Logger? logger}) : logger = logger ?? Logger();

  @override
  String get description => 'Runs build_runner watch command.';

  @override
  String get name => 'watch';

  @override
  String get invocation => 'neo build_runner watch [arguments]';

  @override
  String get summary => '$invocation\n$description';

  Logger logger;

  @override
  Future<int> run() async {
    await runCommand(
      cmd: (cwd) async {
        await BuildRunnerHelper.checkAndInstallBuildRunner(
          cwd: cwd,
          logger: logger,
        );
        final progress = logger.progress('👀 Watching your files..');
        try {
          await Cmd.run(
            'flutter',
            [
              'pub',
              'run',
              'build_runner',
              'watch',
              '--delete-conflicting-outputs',
            ],
            logger: logger,
          );
          progress.complete('Completed...');
        } on ProcessException catch (e) {
          logger.err(e.message);
          progress.fail('Failed to run build command');
        }
      },
      cwd: '.',
      recursive: false,
    );

    return ExitCode.success.code;
  }
}
