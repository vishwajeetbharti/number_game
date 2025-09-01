import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'number_game_method_channel.dart';

abstract class NumberGamePlatform extends PlatformInterface {
  /// Constructs a NumberGamePlatform.
  NumberGamePlatform() : super(token: _token);

  static final Object _token = Object();

  static NumberGamePlatform _instance = MethodChannelNumberGame();

  /// The default instance of [NumberGamePlatform] to use.
  ///
  /// Defaults to [MethodChannelNumberGame].
  static NumberGamePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NumberGamePlatform] when
  /// they register themselves.
  static set instance(NumberGamePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
