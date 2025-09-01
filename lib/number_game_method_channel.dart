import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'number_game_platform_interface.dart';

/// An implementation of [NumberGamePlatform] that uses method channels.
class MethodChannelNumberGame extends NumberGamePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('number_game');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
