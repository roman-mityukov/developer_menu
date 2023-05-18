library developer_menu;
export 'src/ui/developer_menu_widget.dart';

class DeveloperMenu {
  static String? logFilePath;
  static void init(String path) {
    logFilePath = path;
  }
}
