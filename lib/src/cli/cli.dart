import 'dart:async';
import 'dart:io';

import 'package:mason_logger/mason_logger.dart';

const _asyncRunZoned = runZoned;

/// Type definition for [Process.run].
typedef RunProcess = Future<ProcessResult> Function(
  String executable,
  List<String> arguments, {
  String? workingDirectory,
  bool runInShell,
});

/// This class facilitates overriding [Process.run].
/// It should be extended by another class in client code with overrides
/// that construct a custom implementation.
abstract class ProcessOverrides {
  static final _token = Object();

  /// Returns the current [ProcessOverrides] instance.
  ///
  /// This will return `null` if the current [Zone] does not contain
  /// any [ProcessOverrides].
  ///
  /// See also:
  /// * [ProcessOverrides.runZoned] to provide [ProcessOverrides]
  /// in a fresh [Zone].
  ///
  static ProcessOverrides? get current {
    return Zone.current[_token] as ProcessOverrides?;
  }

  /// Runs [body] in a fresh [Zone] using the provided overrides.
  static R runZoned<R>(
    R Function() body, {
    RunProcess? runProcess,
  }) {
    final overrides = _ProcessOverridesScope(runProcess);
    return _asyncRunZoned(body, zoneValues: {_token: overrides});
  }

  /// The method used to run a [Process].
  RunProcess get runProcess => Process.run;
}

class _ProcessOverridesScope extends ProcessOverrides {
  _ProcessOverridesScope(this._runProcess);

  final ProcessOverrides? _previous = ProcessOverrides.current;
  final RunProcess? _runProcess;

  @override
  RunProcess get runProcess {
    return _runProcess ?? _previous?.runProcess ?? super.runProcess;
  }
}

/// Abstraction for running commands via command-line.
class Cmd {
  /// Runs the specified [cmd] with the provided [args].
  ///
  /// If [throwOnError] is set to `true` (default), the method will
  /// throw an exception
  /// if the process returns a non-zero exit code.
  ///
  /// [workingDirectory] specifies the working directory of the command.
  ///
  /// [logger] is used to log output messages.
  static Future<ProcessResult> run(
    String cmd,
    List<String> args, {
    bool throwOnError = true,
    String? workingDirectory,
    required Logger logger,
  }) async {
    logger.detail('Running: $cmd with $args');
    // Get the overridden Process.run function if it exists, otherwise use the
    // default implementation.
    final runProcess = ProcessOverrides.current?.runProcess ?? Process.run;
    final result = await runProcess(
      cmd,
      args,
      workingDirectory: workingDirectory,
      runInShell: true,
    );
    logger
      ..detail('stdout:\n${result.stdout}')
      ..detail('stderr:\n${result.stderr}');
    if (throwOnError) {
      _throwIfProcessFailed(result, cmd, args);
    }
    return result;
  }

  /// Runs a specified function on all files and directories that match a
  /// specified condition.
  ///
  /// For each file or directory in [cwd] and its subdirectories, the function
  /// [run] is called if the file or directory satisfies [where]. Returns an
  /// iterable of the returned values from each invocation of [run].
  static Iterable<Future<T>> runWhere<T>({
    required Future<T> Function(FileSystemEntity) run,
    required bool Function(FileSystemEntity) where,
    String cwd = '.',
  }) {
    return Directory(cwd).listSync(recursive: true).where(where).map(run);
  }

  static void _throwIfProcessFailed(
    ProcessResult pr,
    String process,
    List<String> args,
  ) {
    if (pr.exitCode != 0) {
      final values = {
        'Standard out': pr.stdout.toString().trim(),
        'Standard error': pr.stderr.toString().trim(),
      }..removeWhere((k, v) => v.isEmpty);

      var message = 'Unknown error';
      if (values.isNotEmpty) {
        message = values.entries.map((e) => '${e.key}\n${e.value}').join('\n');
      }

      throw ProcessException(process, args, message, pr.exitCode);
    }
  }
}
