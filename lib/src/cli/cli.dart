import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mason_logger/mason_logger.dart';

part 'process_overrides.dart';

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

  /// It runs a process and logs the output to the
  /// console when [verbose] is true.
  ///
  /// Args:
  ///  - [programName] (String): The name of the program to run.
  ///  - [arguments] (List<String>): The arguments to pass
  ///    to the program. Defaults to const []
  ///  - [workingDirectory] (String): The directory to run the command in.
  ///  - [verbose] (bool): Determine when to log the output to the console.
  ///  - [handleOutput] (Function): Function passed to handle the output.
  static Future<void> runProcessAndLog({
    required String programName,
    List<String> arguments = const [],
    String? workingDirectory,
    bool verbose = true,
    Future<void> Function(List<String> lines)? handleOutput,
    required Logger logger,
  }) async {
    if (verbose) {
      final hasWorkingDirectory = workingDirectory != null;
      logger.info('Running $programName ${arguments.join(' ')} '
          '${hasWorkingDirectory ? 'in $workingDirectory/' : ''}...');
    }

    try {
      final process = await Process.start(
        programName,
        arguments,
        workingDirectory: workingDirectory,
        runInShell: true,
      );

      final lines = <String>[];
      const lineSplitter = LineSplitter();
      await process.stdout.transform(utf8.decoder).forEach((output) {
        if (verbose) {
          logger.detail(output);
        }

        if (handleOutput != null) {
          lines.addAll(
            lineSplitter
                .convert(output)
                .map((l) => l.trim())
                .where((l) => l.isNotEmpty)
                .toList(),
          );
        }
      });
      await handleOutput?.call(lines);
      final exitCode = await process.exitCode;
      if (verbose) logger.success('$exitCode');
    } on ProcessException catch (e, _) {
      final message = 'Command failed. Command executed: $programName '
          '${arguments.join(' ')}\nException: ${e.message}';
      logger.err(message);
    } catch (e, _) {
      final message = 'Command failed. Command executed: $programName'
          '${arguments.join(' ')}\nException: $e';
      logger.err(message);
    }
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
