
import 'number_game_platform_interface.dart';

class NumberGame {
  Future<String?> getPlatformVersion() {
    return NumberGamePlatform.instance.getPlatformVersion();
  }
}
