import 'package:hive/hive.dart';

part 'cli_command_model.g.dart';

@HiveType(typeId: 0)
class CliCommand extends HiveObject {
  @HiveField(0)
  String? command;

  @HiveField(1)
  String? alias;

  @HiveField(2)
  int? id;
}
