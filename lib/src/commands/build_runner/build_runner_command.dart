import 'package:args/command_runner.dart';
import 'package:neo/src/commands/build_runner/commands/build.dart';

/// {@template build_runner}
///
/// `neo build_runner`
/// A [Command] to exemplify a sub command
/// {@endtemplate}
class BuildRunnerCommand extends Command<int> {
  /// {@macro build_runner}
  BuildRunnerCommand() {
    addSubcommand(BuildCommand());
  }

  @override
  String get summary => '$invocation\n$description';

  @override
  String get description => 'A command to generate dart code.';

  @override
  String get name => 'build_runner';

  @override
  String get invocation => 'neo build_runner <subcommand> [arguments]';
}
