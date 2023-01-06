import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:neo/src/cli/cli.dart';
import 'package:path/path.dart' as p;

const _ignoredDirectories = {
  'ios',
  'android',
  'windows',
  'linux',
  'macos',
  '.symlinks',
  '.plugin_symlinks',
  '.dart_tool',
  'build',
  '.fvm',
};

bool _isPubspec(FileSystemEntity entity) {
  final segments = p.split(entity.path).toSet();
  if (segments.intersection(_ignoredDirectories).isNotEmpty) return false;
  if (entity is! File) return false;
  return p.basename(entity.path) == 'pubspec.yaml';
}

/// Run a command on directories with a `pubspec.yaml`.
Future<List<T>> _runCommand<T>({
  required Future<T> Function(String cwd) cmd,
  required String cwd,
  required bool recursive,
}) async {
  if (!recursive) {
    final pubspec = File(p.join(cwd, 'pubspec.yaml'));
    if (!pubspec.existsSync()) throw PubspecNotFound();

    return [await cmd(cwd)];
  }

  final processes = Cmd.runWhere<T>(
    run: (entity) => cmd(entity.parent.path),
    where: _isPubspec,
    cwd: cwd,
  );

  if (processes.isEmpty) throw PubspecNotFound();

  final results = <T>[];
  for (final process in processes) {
    results.add(await process);
  }
  return results;
}

/// Thrown when `flutter packages get` or `flutter pub get`
/// is executed without a `pubspec.yaml`.
class PubspecNotFound implements Exception {}

/// {@template build_runner}
///
/// `neo build_runner build`
/// A [Command] to exemplify a sub command
/// {@endtemplate}
class BuildCommand extends Command<int> {
  /// {@macro build_runner}
  BuildCommand({Logger? logger}) : logger = logger ?? Logger();

  @override
  String get summary => '$invocation\n$description';

  @override
  String get description => 'A command to generate dart code.';

  @override
  String get name => 'build';

  @override
  String get invocation => 'neo build_runner build [arguments]';

  final Logger logger;

  @override
  Future<int> run() async {
    await _runCommand(
        cmd: (cwd) async {
          final pubspec = File(p.join(cwd, 'pubspec.yaml'));
          if (!pubspec.existsSync()) throw PubspecNotFound();

          final progress = logger.progress('👀 Building your files..');
          try {
            await Cmd.run(
              'flutter',
              [
                'pub',
                'run',
                'build_runner',
                'build',
                '--delete-conflicting-outputs',
              ],
              logger: logger,
            );
            progress.complete('Exited...');
          } catch (e) {
            progress.fail();
          }
        },
        cwd: '.',
        recursive: false);

    return ExitCode.success.code;
  }
}
