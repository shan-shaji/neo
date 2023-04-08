import 'package:dart_console/dart_console.dart';

class AppConsoleHelper {
  static Table renderTable(List<List<dynamic>> rows, List<String> columns) {
    var table = Table();
    for (final column in columns) {
      table = table
        ..insertColumn(
          header: column,
          alignment: TextAlignment.center,
        );
    }
    table
      ..insertRows(rows as List<List<Object>>)
      ..borderStyle = BorderStyle.square
      ..borderColor = ConsoleColor.brightCyan
      ..borderType = BorderType.grid;

    return table;
  }
}
