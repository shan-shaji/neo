import 'dart:io' show Directory, FileSystemEntity, Platform;
import 'package:path/path.dart' as path_lib;

/// Static helper class for determining platform's app data path.
///
/// Does not require [AppData] to work, can be standalone.
/// Paths for MacOS and Linux were choosen based on popular
/// StackOverflow answers. Submit a PR if you believe these are
/// wrong.
class Locator {
  static String getPlatformSpecificCachePath() {
    final os = Platform.operatingSystem;
    switch (os) {
      case 'windows':
        return _verify(_findWindows());
      case 'linux':
        return _verify(_findLinux());
      case 'macos':
        return _verify(_findMacOS());
      case 'android':
      case 'ios':
        throw const LocatorException(
          'App caches are not supported for mobile devices',
        );
    }
    throw LocatorException(
      'Platform-specific cache path for platform "$os" was not found',
    );
  }

  static String _verify(String path) {
    if (Directory(path).existsSync()) {
      return path;
    }
    throw LocatorException(
      'The user application path'
      ' for this platform'
      ' ("$path") does not exist on this system',
    );
  }

  static String _findWindows() {
    return path_lib.join(
      Platform.environment['UserProfile']!,
      'AppData',
      'Roaming',
    );
  }

  static String _findMacOS() {
    return path_lib.join(
      Platform.environment['HOME']!,
      'Library',
      'Application Support',
    );
  }

  static String _findLinux() {
    return path_lib.join('home', Platform.environment['HOME']);
  }
}

class LocatorException implements Exception {
  const LocatorException(this.message);
  final String message;

  @override
  String toString() => 'LocatorException: $message';
}

/// Represents a custom folder in the platform's AppPlatformhelper
/// folder equivalence.
///
/// Use [name] to define the name of the folder.
/// It will automatically be created
/// if it does not exist already. Access the path of the cache using [path] or
/// directly access the directory by using [directory].
class AppPlatformhelper {
  AppPlatformhelper.findOrCreate(this.name) {
    _findOrCreate();
  }
  final String name;

  String get path => _path;
  Directory get directory => _directory;

  late String _path;
  late Directory _directory;

  void _findOrCreate() {
    final cachePath = Locator.getPlatformSpecificCachePath();
    _path = path_lib.join(cachePath, name);

    _directory = Directory(_path);

    if (!_directory.existsSync()) {
      _directory.createSync();
    }
  }

  void delete() {
    _directory.delete(recursive: true);
  }

  void clear() {
    _directory.list(recursive: true).listen((FileSystemEntity entity) {
      entity.delete(recursive: true);
    });
  }
}
