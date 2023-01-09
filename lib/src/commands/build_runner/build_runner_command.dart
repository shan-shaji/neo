import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neo/src/commands/build_runner/commands/build/build.dart';

/// {@template build_runner}
///
/// `neo build_runner`
/// A [Command] to exemplify a sub command.
/// This command will only run with a sub command(branch command).
/// {@endtemplate}
class BuildRunnerCommand extends Command<int> {
  /// {@macro build_runner}
  BuildRunnerCommand({required Logger logger}) {
    addSubcommand(BuildCommand(logger: logger));
  }

  @override
  String get summary => '$invocation\n$description';

  @override
  String get description =>
      'Command that helps to run all build_runner commands.';

  @override
  String get name => 'build_runner';

  @override
  String get invocation => 'neo build_runner <subcommand> [arguments]';
}
